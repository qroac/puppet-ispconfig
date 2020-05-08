# @summary Installs nginx
#
# Installs nginx Webserver with some required configuration for ISPConfig
# and ensures nginx is running while checking Apache to be stopped
#
# @example
#   include isp3node::nginx::setup
# @param ispsettings
#   Required settings to configure for ISPConfig
class isp3node::nginx::setup(
  Hash $ispsettings,
) {
  # Ensure a2 is not running
  service{'apache2':
    ensure => stopped,
    enable => false,
  }
  class{'nginx':
    manage_repo    => true,
    package_source => 'nginx-stable',
    *              => $ispsettings,
  }
}
