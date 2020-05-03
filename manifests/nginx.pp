# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::nginx
class isp3node::nginx {
  include isp3node::nginx::setup
  include isp3node::nginx::defaulthost

  Class['isp3node::nginx::setup']
  -> Class['isp3node::nginx::defaulthost']
}
