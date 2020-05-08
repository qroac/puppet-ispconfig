# @summary Installs packages required for user quota
#
# @example
#   include isp3node::quota::setup
class isp3node::quota::setup(
  Array[String] $packages,
) {
  package{$packages: ensure => latest}
}
