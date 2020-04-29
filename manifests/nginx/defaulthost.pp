# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::nginx::defaulthost
class isp3node::nginx::defaulthost {
  nginx::resource::server { "${facts['fqdn']}-http":
    ensure              => present,
    www_root            => '/usr/share/nginx/html',
    location_cfg_append => {
      'rewrite' => '^ https://$server_name$request_uri? permanent'
    },
  }

  nginx::resource::server { $facts['fqdn']:
    ensure      => present,
    listen_port => 443,
    www_root    => '/usr/share/nginx/html',
    ssl         => true,
    ssl_cert    => "/etc/ssl/local/${facts['fqdn']}.bundle.crt",
    ssl_key     => "/etc/ssl/local/${facts['fqdn']}.key",
  }

  unless (lookup('isp3node::base::ssl::letsencrypt', undef, undef, false)){
    File["/etc/ssl/local/${facts['fqdn']}.bundle.crt"] ~> Service['nginx']
  }
}
