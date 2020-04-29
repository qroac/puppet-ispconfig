# Configuration profile for standalone ISP3 mail server
# feat. postfix and dovecot with rspamd 
# optional with mailman ran under additional minimal nginx
# manages SSL certificates for services (optional obtained from LE)
class isp3node::profile::mail() {
  class {'isp3node::base':
    le_deploycommands => ['systemctl restart postfix']
  }
  -> class {'isp3node::mariadb':}
  -> class {'isp3node::postfix': mode => 'standalone'}
}
