# @summary Install pureftpd
#
# Installs required packages and ensures, the pureftpd service is running
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
