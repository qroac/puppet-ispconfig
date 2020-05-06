# @summary Connects instances to the ISPConfig Master Database
#
# If this instance is a slave node, this class exports a mariadb user
# to be created on the master and be used during ISPConfig install and update
#
# If it is the master, it realizes all exported users for creation
#
# @example
#   include isp3node::mariadb::connect_master
class isp3node::mariadb::connect_master(
  String $user,
  String $password,
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
      tag           => ['isp3node-slave', 'isproot-on-master'],
      password_hash => mysql::password($password),
      }
    $users.each |$u| {
      @@mysql_grant{ "${u}/dbispconfig":
        ensure  => present,
        tag     => ['isp3node-slave', 'isproot-on-master'],
        user    => $u,
        require => Mysql_user[$u],
      }
    }
  }
  else {
    # Realize the exported users and grants
    Mysql_user <<| tag == 'isp3node-slave' and tag == 'isproot-on-master' |>>{
      max_user_connections     => 0,
      max_connections_per_hour => 0,
      max_updates_per_hour     => 0,
      max_queries_per_hour     => 0
    }
    Mysql_grant <<| tag == 'isp3node-slave' and tag == 'isproot-on-master' |>>{
      table      => 'dbispconfig',
      privileges => ['ALL'],
      options    => ['GRANT']
    }
  }
}
