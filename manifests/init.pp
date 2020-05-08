# @summary Set up requirements for running as ISPConfig managed server role
#
# From a range of different predefined roles it installs and configures all
# required software regarding to latest howtoforge perfect server tutorials
# but does not install ISPConfig itself.
# @param role
#   The role of the current server in your server setup
# @example
#   include isp3node # role is 'master' or taken from hiera isp3node::role
class isp3node (
  Enum['full', 'master', 'dns', 'web', 'mail'] $role = 'master'
) {
  class{"isp3node::profile::${role}":}
}
