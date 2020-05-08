# @summary Setup phpMyAdmin
#
# Install phpMyAdmin and configure required nginx settings to access the database explorer
# on FQDN/phpmyadmin
# Also add the link to the default page on this host
#
# @example
#   include isp3node::phpmyadmin
class isp3node::phpmyadmin(
  Boolean $frontend = false,
) {
  class{'isp3node::phpmyadmin::setup': frontend => $frontend}
  if ($frontend) {
    class{'isp3node::phpmyadmin::config::nginx':}

    isp3node::nginx::startpageentry { 'phpmyadmin':
      verbose_name => 'Database',
      path         => '/phpmyadmin',
    }

    # Ordering
    Class['isp3node::phpmyadmin::setup']
    -> Class['isp3node::phpmyadmin::config::nginx']
  }
}
