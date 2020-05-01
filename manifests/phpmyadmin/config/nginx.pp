# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::phpmyadmin::config::nginx
class isp3node::phpmyadmin::config::nginx(
  $fastcgi_socket = '127.0.0.1:9000',
) {
  nginx::resource::location {'phpmyadmin':
    ensure      => present,
    server      => $facts['fqdn'],
    ssl         => true,
    ssl_only    => true,
    location    => '/phpmyadmin',
    www_root    => '/usr/share/',
    index_files => ['index.php', 'index.html', 'index.htm'],
  }
  nginx::resource::location {'phpmyadmin-php':
    ensure              => present,
    server              => $facts['fqdn'],
    ssl                 => true,
    ssl_only            => true,
    location            => '~ ^/phpmyadmin/(.+\.php)$',
    try_files           => ['$uri', '=404'],
    www_root            => '/usr/share/',
    fastcgi             => $fastcgi_socket,
    fastcgi_param       => {
      'HTTPS'           => '$https',
      'SCRIPT_FILENAME' => '$request_filename',
      'PATH_INFO'       => '$fastcgi_script_name',
    },
    fastcgi_params      => '/etc/nginx/fastcgi_params',
    fastcgi_index       => 'index.php',
    location_cfg_append => {
      fastcgi_buffer_size          => '128k',
      fastcgi_buffers              => '256 4k',
      fastcgi_busy_buffers_size    => '256k',
      fastcgi_temp_file_write_size => '256k',
      fastcgi_intercept_errors     => 'on',
    },
  }
}
