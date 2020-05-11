# Configuration profile for standalone ISP3 Bind DNS server
class isp3node::profile::dns () {
  class {'isp3node::base':}
  -> class {'isp3node::mariadb':}
  -> class {'isp3node::postfix': mode => 'satellite'}
  -> class {'isp3node::php':}
  -> class {'isp3node::bind':}
  -> class {'isp3node::fail2ban':}
}
