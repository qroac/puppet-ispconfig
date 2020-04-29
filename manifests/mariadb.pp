# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::mariadb
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
  # TODO Control Port in firewall dependent on listen state
  # TODO Introduce parameter Bool $restricted, to open port in firewall only for other isp nodes
}
