# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::nginx::automail
class isp3node::nginx::automail(
  String $repository,
  String $remoteuser = undef,
  String $remotepass = undef,
  String $service_name = $facts['fqdn'],
  String $service_shortname = $facts['domain'],
) {
  # Only on mailservers
  if($facts['isp3node']['postfix']['installed'] and
  $facts['isp3node']['postfix']['mode'] == 'standalone' and
  $facts['isp3node']['dovecot']['installed']) {
    unless($remoteuser and $remotepass) {
      notify{'skip-automail':
        message => "Skipping automail configuration due to missing remoteuser credentials\n
        To use automail, please set isp3node::nginx::automail::remoteuser and isp3node::nginx::automail::remotepass"
      }
    } else {
      # Checkout automail project
      ensure_resource('package', 'git')
      vcsrepo { '/var/www/automail':
        ensure   => latest,
        provider => git,
        source   => $repository,
        require  => Package['git'],
      }
      # Write configfile
      -> file{'/var/www/automail/config.php':
        ensure  => file,
        mode    => '0400',
        content => epp('isp3node/web/automail/config.php', {
          remoteuser        => $remoteuser,
          remotepass        => $remotepass,
          service_name      => $service_name,
          service_shortname => $service_shortname,
          masterserver      => lookup('isp3node::master'),
        })
      }

      # add automail paths to defaulthost
      nginx::resource::location{'automail-files':
        ensure              => present,
        server              => $facts['fqdn'],
        ssl                 => true,
        ssl_only            => true,
        location            => '~* ^(/mail/config-v1.1.xml|/autodiscover)',
        location_cfg_append => { 'rewrite' => '^(.*)$ /index.php?file=$1 last' },
      }
      nginx::resource::location{'automail-php':
        ensure              => present,
        server              => $facts['fqdn'],
        ssl                 => true,
        ssl_only            => true,
        location            => '/index.php',
        www_root            => '/var/www/automail',
        index_files         => ['index.php'],
        fastcgi_params      => '/etc/nginx/fastcgi_params',
        fastcgi             => '127.0.0.1:9000',
        fastcgi_index       => 'index.php',
        fastcgi_param       => {
          'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name',
        },
        location_cfg_append => {
          fastcgi_buffer_size          => '128k',
          fastcgi_buffers              => '256 4k',
          fastcgi_busy_buffers_size    => '256k',
          fastcgi_temp_file_write_size => '256k',
          fastcgi_intercept_errors     => 'on',
          'access_log'                 => '/var/log/nginx/automail_access.log',
          'error_log'                  => '/var/log/nginx/automail_error.log',
        },
      }

      # Ordering
      Vcsrepo['/var/www/automail']
      -> Nginx::Resource::Location['automail-php']
    }
  }
}
