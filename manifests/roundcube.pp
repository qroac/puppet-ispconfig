# @summary Install and configure Roundcube webmail on this host
#
# @example
#   include isp3node::roundcube
class isp3node::roundcube {
  class{'isp3node::roundcube::setup':}
  -> class{'isp3node::roundcube::config':}
}
