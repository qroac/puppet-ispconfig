# @summary Installs nginx and enables FQDN default host
#
# A description of what this class does
#
# @example
#   include isp3node::nginx::setup
class isp3node::nginx::setup {
  class{'nginx':
    manage_repo    => true,
    package_source => 'nginx-stable'
}
}
