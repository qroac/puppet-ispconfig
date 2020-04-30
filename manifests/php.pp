# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::php
# @param set
#   Defined config set to apply on the node
class isp3node::php(
  Optional[String] $set = undef,
) {
  class {'isp3node::php::setup': set => $set}
}
