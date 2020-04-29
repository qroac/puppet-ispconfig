# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::dovecot::ssl
class isp3node::dovecot::ssl {
  $dovecot_settings = {'' => {
    ssl_cert => "</etc/ssl/local/${facts['fqdn']}.bundle.crt",
    ssl_key  => "</etc/ssl/local/${facts['fqdn']}.key",
  }}
  create_ini_settings($dovecot_settings, { path => '/etc/dovecot/dovecot.conf'})
  unless (lookup('isp3node::base::ssl::letsencrypt', undef, undef, false)){
    File["/etc/ssl/local/${facts['fqdn']}.bundle.crt"] ~> Service['dovecot']
  }
}
