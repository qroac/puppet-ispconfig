# @summary Configure Roundcube Webmail
#
# Confiures basic settings in Roundcubes config file and adds required locations
# to nginx FQDN host to access Webmail at /roundcube and /webmail
# Further adds a Link to webmail to the default server startpage
#
# @example
#   include isp3node::roundcube::config
class isp3node::roundcube::config {
  $settings = {'' => {
    '$config[\'smtp_server\']'  => '\'localhost\';',
  }}
  create_ini_settings($settings, {path => '/etc/roundcube/config.inc.php'})
  nginx::resource::location{'roundcube':
    ensure              => present,
    server              => $facts['fqdn'],
    ssl                 => true,
    ssl_only            => true,
    location            => '/roundcube',
    www_root            => '/usr/share',
    location_cfg_append => {
      'access_log' => '/var/log/nginx/roundcube_access.log',
      'error_log'  => '/var/log/nginx/roundcube_error.log',
    },
    raw_append          => epp('isp3node/roundcube/nginx.location.cfg'),
  }
  nginx::resource::location{'webmail':
    ensure        => present,
    server        => $facts['fqdn'],
    ssl           => true,
    ssl_only      => true,
    location      => '/webmail/',
    rewrite_rules => ['^/* /squirrelmail last']
  }
  isp3node::nginx::startpageentry { 'roundcube':
    verbose_name => 'Webmail',
    path         => '/roundcube/',
  }
}
