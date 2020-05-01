# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::pureftpd::setup
class isp3node::pureftpd::setup (
  Array[String] $packages,
) {
  package {$packages: ensure => latest}
  service{'pure-ftpd-mysql':
    ensure => running,
  }
}
