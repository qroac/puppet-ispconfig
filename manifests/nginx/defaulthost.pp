# @summary Set up a default page on hosts FQDN
#
# Places a default startpage on the hosts FQDN containing links to tools for the customers
# like mailman, webmail, phpmyadmin or ispconfig.
# RSpamd is not listed as link, because usually not ment for public access.
#
# @example
#   include isp3node::nginx::defaulthost
class isp3node::nginx::defaulthost {
  file{'/var/www':
    ensure  => directory,
  }
  -> file{'/var/www/default':
    ensure  => directory,
  }
  -> concat{'/var/www/default/index.html':
    ensure  => present,
  }

  concat::fragment{'startpage_header':
    target  => '/var/www/default/index.html',
    content => epp('isp3node/web/startpage.head.html'),
    order   => '00'
  }
  concat::fragment{'startpage_begin':
    target  => '/var/www/default/index.html',
    content => epp('isp3node/web/startpage.body1.html'),
    order   => '01'
  }
  concat::fragment{'startpage_end':
    target  => '/var/www/default/index.html',
    content => epp('isp3node/web/startpage.body2.html'),
    order   => '98'
  }

  nginx::resource::server { "${facts['fqdn']}-http":
    ensure              => present,
    server_name         => [$facts['fqdn']],
    listen_ip           => $facts['networking']['ip'],
    ipv6_listen_ip      => $facts['networking']['ip6'],
    ipv6_enable         => true,
    www_root            => '/var/www/default',
    location_cfg_append => {
      'rewrite' => '^ https://$server_name$request_uri? permanent'
    },
  }

  nginx::resource::server { $facts['fqdn']:
    ensure         => present,
    listen_port    => 443,
    listen_ip      => $facts['networking']['ip'],
    ipv6_listen_ip => $facts['networking']['ip6'],
    ipv6_enable    => true,
    www_root       => '/var/www/default',
    ssl            => true,
    ssl_cert       => "/etc/ssl/local/${facts['fqdn']}.bundle.crt",
    ssl_key        => "/etc/ssl/local/${facts['fqdn']}.key",
  }

  unless (lookup('isp3node::base::ssl::letsencrypt', undef, undef, false)){
    File["/etc/ssl/local/${facts['fqdn']}.bundle.crt"] ~> Service['nginx']
  }
}
