# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::base::ssl
# @param letsencrypt
#   Obtain certificate from letsencrypt
# @param email
#   Mail address for notifications from LE CA
# @param domains
#   Domains to obtain certificates for, Systems FQDN is automatically included
# @param cert
#   Certificate, if LE is not used
# @param ca
#   CA Cert, if LE is not used
# @param key
#   Private Key, if LE is not used
class isp3node::base::ssl(
  Integer $dhparamsize,
  Optional[Boolean] $letsencrypt = true,
  # TODO Need a better way to restart services after cert renewal ... Maybe a restart script and every service adds itself with concat?
  Optional[Array[String]] $le_deploycommands = ['systemctl restart postfix'],
  Optional[String] $email = lookup('isp3node::email', undef, undef, undef),
  Optional[Array[String]] $domains = [],
  Optional[String] $cert = undef,
  Optional[String] $ca = undef,
  Optional[String] $key = undef,
) {
  # TODO add option to switch to webroot for servers running nginx
  File{
    owner => root,
    group => root,
    mode  => '0444',
  }
  file{'/etc/ssl/local':
    ensure => directory,
  }
  exec{'ssl-dhparam':
    command => "openssl dhparam -out /etc/ssl/local/dhparam.pem ${dhparamsize}",
    require => [File['/etc/ssl/local']],
    creates => '/etc/ssl/local/dhparam.pem',
    path    => $facts['path'],
    timeout => 1800,
  }
  if($letsencrypt) {
    # Deploy hook to generate pem containing the key
    $deployhooks = [
      "cat /etc/letsencrypt/live/${facts['fqdn']}/privkey.pem > /etc/ssl/local/${facts['fqdn']}.keybundle.pem",
      "cat /etc/letsencrypt/live/${facts['fqdn']}/fullchain.pem >> /etc/ssl/local/${facts['fqdn']}.keybundle.pem",
      "chmod 600 /etc/ssl/local/${facts['fqdn']}.keybundle.pem",
    ]
    class { 'letsencrypt':
      email             => $email,
      package_ensure    => 'latest',
      renew_cron_ensure => present,
    }
    unless($facts['isp3node']['nginx']['installed'] and
      ('80/tcp' in $facts['isp3node']['ports'] or '80/tcp6' in $facts['isp3node']['ports'])
    ){
      letsencrypt::certonly { $facts['fqdn']:
        domains              => [$facts['fqdn']] + $domains,
        deploy_hook_commands => $deployhooks + $le_deploycommands,
      }
    } else {
      letsencrypt::certonly { $facts['fqdn']:
        domains              => [$facts['fqdn']] + $domains,
        deploy_hook_commands => $deployhooks + $le_deploycommands,
        plugin               => 'webroot',
        webroot_paths        => ['/var/www/default']
      }
    }

    file{"/etc/ssl/local/${facts['fqdn']}.crt":
      ensure => link,
      target => "/etc/letsencrypt/live/${facts['fqdn']}/cert.pem",
    }
    file{"/etc/ssl/local/${facts['fqdn']}.bundle.crt":
      ensure => link,
      target => "/etc/letsencrypt/live/${facts['fqdn']}/fullchain.pem",
    }
    file{'/etc/ssl/local/ca.crt':
      ensure => link,
      target => "/etc/letsencrypt/live/${facts['fqdn']}/chain.pem",
    }
    file{"/etc/ssl/local/${facts['fqdn']}.key":
      ensure => link,
      target => "/etc/letsencrypt/live/${facts['fqdn']}/privkey.pem",
      mode   => '0400',
    }
  }
  else {
    file{"/etc/ssl/local/${facts['fqdn']}.crt":
      ensure  => file,
      content => $cert,
    }
    file{"/etc/ssl/local/${facts['fqdn']}.bundle.crt":
      ensure  => link,
      content => "${cert}\n${ca}"
    }
    file{'/etc/ssl/local/ca.crt':
      ensure  => file,
      content => $ca,
    }
    file{"/etc/ssl/local/${facts['fqdn']}.key":
      ensure  => file,
      content => $key,
      mode    => '0400',
    }
  }
}
