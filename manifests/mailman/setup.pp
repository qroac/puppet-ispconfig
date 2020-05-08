# @summary Install mailman on the host
#
# @example
#   include isp3node::mailman::setup
# @param packages
#   Required packages to install
class isp3node::mailman::setup(
  Array[String] $packages,
) {
  package{$packages:
    ensure => latest
  }
}
