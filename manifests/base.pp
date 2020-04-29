# @summary Run the full base setup for ispconfig server nodes
#
# @example
#   include isp3node::base
class isp3node::base(
  Optional[Array[String]] $le_deploycommands = undef,
) {
  include isp3node::base::puppet
  include isp3node::base::hosts
  include isp3node::base::software
  include isp3node::base::shell
  class {'isp3node::base::ssl':
    le_deploycommands => $le_deploycommands,
  }

  Class['isp3node::base::hosts'] -> Class['isp3node::base::ssl']
  Class['isp3node::base::software'] -> Class['isp3node::base::ssl']
}
