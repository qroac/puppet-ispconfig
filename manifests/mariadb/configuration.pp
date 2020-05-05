# @summary Configure mariadb for ispconfig
#
# Enable passwordless login for root user and system config scripts
# with ispconfig 
#
# @example
#   include isp3node::mariadb::configuration
# @param root_password
#   DB root user password in cleartext
class isp3node::mariadb::configuration(
  $root_password,
) {
  exec{'enalbe native password for root':
    command => "mysql -uroot -p${root_password} -D mysql -e \"update mysql.user set plugin = 'mysql_native_password' where user = 'root';\" \
  && touch /usr/local/ispconfig-puppet/mariadb_rootuser_plugin_set",
    creates => '/usr/local/ispconfig-puppet/mariadb_rootuser_plugin_set',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => File['/usr/local/ispconfig-puppet'],
  }
  -> file{'/etc/mysql/debian.cnf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('ispconfig3/mariadb/debian.cnf', { root_pw => $root_password }),
  }

  # TODO Move this to a more senseful location when required for roundcube ...
  # exec{'dbconfig-common adjustment for roundcube':
  #   command => 'sed -i -r \'s/_dbc_nodb="yes" dbc_mysql_exec/_dbc_nodb="yes"; dbc_mysql_exec/g\' /usr/share/dbconfig-common/internal/mysql',
  #   onlyif  => 'grep "_dbc_nodb=\"yes\" dbc_mysql_exec" /usr/share/dbconfig-common/internal/mysql',
  #   path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  # }
}
