define isp3node::nginx::startpageentry (
  String $verbose_name,
  String $path,
) {
  concat::fragment { "startpage_headlink_${name}":
    order   => '20',
    target  => '/var/www/default/index.html',
    content => epp('isp3node/web/startpage.headlink.html', {
      verbose_name => $verbose_name,
      path         => $path
    }),
  }
}
