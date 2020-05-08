# @summary Setup Quota on this host
#
# @example
#   include isp3node::quota
class isp3node::quota {
  class {'isp3node::quota::setup':}
  -> class {'isp3node::quota::config':}
}
