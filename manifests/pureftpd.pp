# @summary Install and configure pureftpd on this host
#
# @example
#   include isp3node::pureftpd
class isp3node::pureftpd {
  class{'isp3node::pureftpd::setup':}
  class{'isp3node::pureftpd::config':}
}
