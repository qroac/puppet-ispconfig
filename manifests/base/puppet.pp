# @summary Configure base requirements for ispconfig node management with puppet
#
# Creates a local folder within ispconfig installation path to create lockfiles 
# for certain configuration steps
#
# @example
#   include isp3node::base::puppet
class isp3node::base::puppet {
  file{'/usr/local/ispconfig-puppet': ensure => directory}
}
