# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix
class isp3node::postfix(
  Enum['standalone', 'satellite'] $mode,
) {
  class {"isp3node::postfix::${mode}":
    before => Class['isp3node::postfix::ssl']
  }
  include isp3node::postfix::ssl
}
