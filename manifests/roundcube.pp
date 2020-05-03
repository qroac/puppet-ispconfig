# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::roundcube
class isp3node::roundcube {
  class{'isp3node::roundcube::setup':}
  -> class{'isp3node::roundcube::config':}
}
