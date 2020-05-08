# @summary Install and configure PHP
#
# Install and configure the default PHP version on the host applying a defined set of extensions, modules and features
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
