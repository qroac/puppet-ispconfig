# @summary Manages a nodes hosts entries
#
# Adds the node itself, all other managed nodes and additional entries from hiera to the hosts file
#
# @param hostname
#   The servers hostname, defaults to facter
# @param domain
#   The servers domain name, defaults to facter
# @param ip
#   The servers main IP address, defaults to facter
# @param entries
#   Hash of additional entries to add to the hostsfile
#
# @example
#   include isp3node::base::hostname
# @example
#   class{'isp3node::base::hostname': entries => {'my-host-name': {ensure => present, ip => '1.2.3.4'}}}
class isp3node::base::hosts(
  String $hostname = lookup('isp3node::base::hostname', String, undef, $facts['networking']['hostname']),
  String $domain = lookup('isp3node::base::domain', String, undef, $facts['networking']['domain']),
  String $ip = lookup('isp3node::base::ip', String, undef, $facts['ipaddress']),
  Optional[Hash[String, Hash]] $entries = {}
) {
  # Export own host data
  @@host {"${hostname}.${domain}":
    ensure  => present,
    tag     => ['ispnode'],
    alias   => $hostname,
    ip      => $ip,
    comment => "ISPConfig node ${hostname}, provisioned by puppet"
  }
  Host <<| tag == 'ispnode' |>>

  create_resources(host, $entries)
}

