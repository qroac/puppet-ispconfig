# @summary Configure base requirements for ispconfig node management with puppet
#
# Creates a local folder to create lockfiles for certain configuration steps
#
class isp3node::base::puppet {
  file{'/usr/local/ispconfig-puppet': ensure => directory}
}
