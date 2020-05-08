# @summary Configure Postfix SSL Script
#
# Points postfix ssl configuration to the local installed ssl certificate
# If managed through hiera instead of obtained via LE, also adds a subscription 
# to the certificate file for postfix service restart
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
