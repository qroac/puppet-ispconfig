# Setup this host with all packages for ISPConfig as single server node
class isp3node::profile::full {
  class {'isp3node::base':
    le_deploycommands => [
      'systemctl restart postfix',
      'systemctl restart dovecot',
      'systemctl reload nginx',
      'systemctl restart pure-ftpd-mysql'
    ]
  }
  -> class {'isp3node::mariadb':
    public => true,
  }
  -> class {'isp3node::postfix': mode => 'standalone'}
  # Redis is required by rspamd as configured by dovecot
  -> class {'isp3node::redis':}
  -> class {'isp3node::dovecot':}
  -> class {'isp3node::bind':}
  -> class {'isp3node::nginx':}
  -> class {'isp3node::php': set => 'web'}
  -> class {'isp3node::phpmyadmin':}
  -> class {'isp3node::pureftpd':}
  -> class {'isp3node::quota':}
  -> class {'isp3node::webstats':}
  -> class {'isp3node::jailkit':}
  -> class {'isp3node::mailman':}
  -> class {'isp3node::roundcube':}
  -> class {'isp3node::fail2ban':}
}
