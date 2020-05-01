# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::quota::setup
class isp3node::quota::setup(
  Array[String] $packages,
) {
  package{$packages: ensure => latest}
}
