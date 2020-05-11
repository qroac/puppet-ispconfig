# @summary Connects instances to the ISPConfig Master Database
#
# If this instance is a slave node, this class exports a mariadb user
# to be created on the master and be used during ISPConfig install and update
#
# If it is the master, it realizes all exported users for creation
#
# @example
#   include isp3node::mariadb::connect_master
# @param user
#   username to add to the master DB for access from this host
#   DO NOT USE root, this resource is already defined in mysql core setup and will
#   cause puppet to fail. Beside that, do you want a privileged user root with external access?
# @param password
#   Password for authentication to master servers database
class isp3node::mariadb::connect_master(
  String $user,
  String $password,
  String $collect_tag = 'isp3node-masterdb-slave',
) {
  unless($facts['fqdn'] == lookup('isp3node::master')) {
    # Export Users to be created on the master node
    $users = [
      "${user}@${facts['fqdn']}",
      "${user}@${facts['networking']['ip']}",
      "${user}@${facts['networking']['ip6']}",
    ]
    @@mysql_user{$users:
      ensure        => present,
      tag           => $collect_tag,
      password_hash => mysql::password($password),
      }
    $users.each |$u| {
      @@mysql_grant{ "${u}/*.*":
        ensure  => present,
        tag     => $collect_tag,
        user    => $u,
        require => Mysql_user[$u],
      }
    }
  }
  else {
    # Realize the exported users and grants
    Mysql_user <<| tag == $collect_tag |>>{
      max_user_connections     => 0,
      max_connections_per_hour => 0,
      max_updates_per_hour     => 0,
      max_queries_per_hour     => 0
    }
    Mysql_grant <<| tag == $collect_tag |>>{
      table      => '*.*',
      privileges => ['ALL'],
      options    => ['GRANT']
    }
  }
}
