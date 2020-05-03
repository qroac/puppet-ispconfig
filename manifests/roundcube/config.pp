# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::roundcube::config
class isp3node::roundcube::config {
  $settings = {'' => {
    '$config[\'default_host\']' => '\'localhost\';',
    '$config[\'smtp_server\']'  => '\'localhost\';',
  }}
  create_ini_settings($settings, {path => '/etc/roundcube/config.inc.php'})
  nginx::resource::location{'roundcube':
    ensure              => present,
    server              => $facts['fqdn'],
    ssl                 => true,
    ssl_only            => true,
    location            => '/webmail',
    location_alias      => '/usr/share/webapps/roundcubemail',
    location_cfg_append => {
      'access_log' => '/var/log/nginx/roundcube_access.log',
      'error_log'  => '/var/log/nginx/roundcube_error.log',
    },
    raw_append          => epp('isp3node/roundcube/nginx.location.cfg'),
  }
  isp3node::nginx::startpageentry { 'roundcube':
    verbose_name => 'Webmail',
    path         => '/webmail',
  }
}
