# @summary Install BIND DNS Server
#
# Installs the current BIND DNS Server from package repository and automatically
# adds a special daemon for enhanced system entropy (required for DNSSEC) on
# virtualized nodes.
#
# @example
#   include isp3node::bind::setup
#
# @param packages
#   Package list to install for BIND
# @param entropy_packages
#   Packages to install for enhanced system entropy
# @param entropy_service
#   Name of the entropy daemon to ensure running
# @param boost_entropy
#   Boost entropy on physical server, too (irrelevant on VMs, entropy is forcibly installed there!)
class isp3node::bind::setup(
  Array[String] $packages,
  Array[String] $entropy_packages,
  String $entropy_service,
  Optional[Boolean] $boost_entropy = false,
) {
  package{$packages: ensure => latest}
  if($facts['virtual'] != 'physical' or $boost_entropy) {
    package{$entropy_packages: ensure => latest}
    -> service{$entropy_service: ensure => running, enable => true}
  } else {
    package{$entropy_packages: ensure => absent}
  }
}
