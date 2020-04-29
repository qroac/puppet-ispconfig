# ISPConfig Node Profile for running as multiserver master with panel
# Will manage minimum required nginx, php and mariadb
# along with SSL certificate (optional obtained from LE)
class isp3node::profile::master() {
  class {'isp3node::base':}
  -> class {'isp3node::mariadb':
    public => true,
  }
  -> class {'isp3node::postfix': mode => 'satellite'}
}
