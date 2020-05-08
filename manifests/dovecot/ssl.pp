# @summary Configure Dovecot to use local managed SSL Certificates
#
# @example
#   include isp3node::dovecot::ssl
class isp3node::dovecot::ssl {
  $dovecot_settings = {'' => {
    ssl_cert => "</etc/ssl/local/${facts['fqdn']}.bundle.crt",
    ssl_key  => "</etc/ssl/local/${facts['fqdn']}.key",
    ssl_dh   => '</etc/ssl/local/dhparam.pem',
  }}
  create_ini_settings($dovecot_settings, {
    path => '/etc/dovecot/dovecot.conf',
    notify => Service['dovecot'],
  })
  unless (lookup('isp3node::base::ssl::letsencrypt', undef, undef, false)){
    File["/etc/ssl/local/${facts['fqdn']}.bundle.crt"] ~> Service['dovecot']
  }
}
