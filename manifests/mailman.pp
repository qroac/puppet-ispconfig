# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::mailman
class isp3node::mailman {
  class{'isp3node::mailman::setup':}
  -> class{'isp3node::mailman::configure':}
  -> class{'isp3node::mailman::config::nginx':}
}
