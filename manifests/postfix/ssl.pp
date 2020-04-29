# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix::ssl
class isp3node::postfix::ssl {
  postfix::config {
    'smtpd_tls_cert_file': value => "/etc/ssl/local/${facts['fqdn']}.bundle.crt";
    'smtpd_tls_key_file':  value => "/etc/ssl/local/${facts['fqdn']}.key";
  }
  unless (lookup('isp3node::base::ssl::letsencrypt', undef, undef, false)){
    File["/etc/ssl/local/${facts['fqdn']}.bundle.crt"] ~> Service['postfix']
  }
}
