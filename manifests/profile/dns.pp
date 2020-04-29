# Configuration profile for standalone ISP3 Bind DNS server
class isp3node::profile::dns () {
  class {'isp3node::base':}
  -> class {'isp3node::mariadb':}
  -> class {'isp3node::postfix': mode => 'satellite'}
}
