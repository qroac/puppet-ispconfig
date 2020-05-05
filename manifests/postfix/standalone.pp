# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix::standalone
class isp3node::postfix::standalone(
  Hash $options,
) {
  $mynetworks = ['127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128']
  $ips_query = "inventory[facts.networking.ip,facts.networking.ip6] { facts.isp3node.postfix.mode = 'satellite' and facts.isp3node.postfix.relay='${facts[fqdn]}' }"
  $satellite_ips = puppetdb_query($ips_query)
  $mysatellites = $satellite_ips.map |$satellite| {
      "${satellite['facts.networking.ip']} [${satellite['facts.networking.ip6']}]"
  }

  $myoptions = $options + {
    # Not using modules mta settings here, too less configurable. 
    # mta        => true,
    relayhost  => 'direct',
    mynetworks => join($mynetworks + $mysatellites, ' '),
  }
  class{'isp3node::postfix::setup':
    options => $myoptions,
  }
  postfix::config {
    'relayhost':     ensure => 'blank';
    'mydestination': value => "${facts[fqdn]}, localhost, localhost.localdomain";
    'mynetworks':    value => join($mynetworks + $mysatellites, ' ');
  }
}
