# @summary Install and configure MariaDB on the host
#
# Install, configure and secure MariaDB on this host.
# Further exports a ISPROOT user from each non-master node to be
# collected on the master node, which automatically adds them 
# with permission to dbispconfig.*
#
# @example
#   include isp3node::mariadb
# @param root_password
#   Password to set for user root
# @param public
#   Listen on public IP or bind to 127.0.0.1
class isp3node::mariadb(
  String $root_password,
  Boolean $public = false,
) {
  class {'isp3node::mariadb::setup':
    root_password => $root_password,
    public        => $public,
  }
  -> class {'isp3node::mariadb::configuration':
    root_password => $root_password,
  }
  -> class {'isp3node::mariadb::connect_master':}
  # TODO Control Port in firewall dependent on listen state
  # TODO Introduce parameter Bool $restricted, to open port in firewall only for other isp nodes
}
