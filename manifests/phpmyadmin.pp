# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::phpmyadmin
class isp3node::phpmyadmin(
  Boolean $frontend = false,
) {
  class{'isp3node::phpmyadmin::setup': frontend => $frontend}
  if ($frontend) {
    class{'isp3node::phpmyadmin::config::nginx':}
  }

  # Ordering
  Class['isp3node::phpmyadmin::setup']
  -> Class['isp3node::phpmyadmin::config::nginx']
}
