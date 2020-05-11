# @summary Setup this host as standalone postfix MTA
#
# @example
#   include isp3node::postfix::standalone
# @param options
#   Additional options to add to the postifx setup
class isp3node::postfix::standalone(
  Hash $options,
  String $master_submission,
  String $master_smtps,
) {
  $mynetworks = ['127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128']
  # Query PuppetDB for IPs of satellite servers that use this MTA
  # as relay host
  $ips_query = "inventory[facts.networking.ip,facts.networking.ip6] { facts.isp3node.postfix.mode = 'satellite' and facts.isp3node.postfix.relay='${facts[fqdn]}' }"
  $satellite_ips = puppetdb_query($ips_query)
  $mysatellites = $satellite_ips.map |$satellite| {
      "${satellite['facts.networking.ip']} [${satellite['facts.networking.ip6']}]"
  }

  $myoptions = $options + {
    # Not using modules mta settings here, too less configurable. 
    # mta        => true,
    relayhost         => 'direct',
    mynetworks        => join($mynetworks + $mysatellites, ' '),
    smtp_listen       => 'all',
    # Add client ports
    master_submission => $master_submission,
    master_smtps      => $master_smtps,
  }
  class{'isp3node::postfix::setup':
    options => $myoptions,
  }
  postfix::config {
    'relayhost':     ensure => 'blank';
    'mynetworks':    value => join($mynetworks + $mysatellites, ' ');
  }
}
