# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::bind::setup
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
