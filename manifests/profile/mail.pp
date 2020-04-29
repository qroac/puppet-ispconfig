# Configuration profile for standalone ISP3 mail server
# feat. postfix and dovecot with rspamd 
# optional with mailman ran under additional minimal nginx
# manages SSL certificates for services (optional obtained from LE)
class isp3node::profile::mail() {
  class {'isp3node::base':
    le_deploycommands => [
      'systemctl restart postfix',
      'systemctl restart dovecot',
      'systemctl reload nginx'
    ]
  }
  -> class {'isp3node::mariadb':}
  -> class {'isp3node::postfix': mode => 'standalone'}
  # Redis is required by rspamd as configured by dovecot
  -> class {'isp3node::redis':}
  -> class {'isp3node::dovecot':}
  -> class {'isp3node::nginx':}
}
