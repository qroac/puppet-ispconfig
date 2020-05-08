# @summary Setup Postfix on the host
#
# Install postfix either as standalone mail transfer agent or satellite system relaying to another postfix
# and manage its configured ssl certificates
#
# @example
#   include isp3node::postfix
# @param mode
#   Run this postfix standalone or as satellite
class isp3node::postfix(
  Enum['standalone', 'satellite'] $mode = 'standalone',
) {
  class {"isp3node::postfix::${mode}":
    before => Class['isp3node::postfix::ssl']
  }
  include isp3node::postfix::ssl
}
