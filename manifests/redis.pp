# @summary Install a local redis server on this host
#
# @example
#   include isp3node::redis
class isp3node::redis {
  class {'::redis':}
}
