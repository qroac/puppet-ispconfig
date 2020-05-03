define isp3node::nginx::startpageentry (
  String $verbose_name,
  String $path,
  Optional[Integer[20, 40]] $order = 30,
) {
  concat::fragment { "startpage_headlink_${name}":
    order   => $order,
    target  => '/var/www/default/index.html',
    content => epp('isp3node/web/startpage.headlink.html', {
      verbose_name => $verbose_name,
      path         => $path
    }),
  }
}
