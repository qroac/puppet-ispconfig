# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::mailman::config::nginx
class isp3node::mailman::config::nginx {
  nginx::resource::location {'mm-main':
    ensure              => present,
    server              => $facts['fqdn'],
    ssl                 => true,
    ssl_only            => true,
    location            => '/cgi-bin/mailman',
    www_root            => '/usr/lib',
    fastcgi             => 'unix:/var/run/fcgiwrap.socket',
    fastcgi_params      => '/etc/nginx/fastcgi_params',
    fastcgi_param       => {
      'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name',
      'PATH_INFO'       => '$fastcgi_path_info',
      'PATH_TRANSLATED' => '$document_root$fastcgi_path_info',
    },
    location_cfg_append => {
      fastcgi_intercept_errors => 'on',
      fastcgi_split_path_info  => '(^/cgi-bin/mailman/[^/]*)(.*)$'
    }
  }
  nginx::resource::location {'mm-images':
    ensure         => present,
    server         => $facts['fqdn'],
    ssl            => true,
    ssl_only       => true,
    location       => '/images/mailman',
    location_alias => '/usr/share/images/mailman',
  }
  nginx::resource::location {'mm-pipermail':
    ensure         => present,
    server         => $facts['fqdn'],
    ssl            => true,
    ssl_only       => true,
    location       => '/pipermail',
    location_alias => '/var/lib/mailman/archives/public',
    autoindex      => 'on',
  }
}
