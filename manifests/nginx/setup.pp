# @summary Installs nginx and enables FQDN default host
#
# A description of what this class does
#
# @example
#   include isp3node::nginx::setup
class isp3node::nginx::setup {
  # Ensure a2 is not running
  service{'apache2':
    ensure => stopped,
    enable => false,
  }
  class{'nginx':
    manage_repo    => true,
    package_source => 'nginx-stable'
}
}
