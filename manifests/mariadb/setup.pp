# @summary Setup MariaDB Server for use with ISPConfig
#
# Further sets some filesystem settings for mariadb (NOFILE)
#
# @example
#   include isp3node::mariadb::setup
# @param root_password
#   DB root user password, can be Sensitive
# @param public
#   Whether this DB server is public (listen on public IP) or not
# @param additional_packages
#   Additional packages required to be installed after mariadb setup

class isp3node::mariadb::setup(
  String $root_password,
  Boolean $public,
  Optional[Array[String]] $additional_packages = [],
) {
  $override_options = {
    mysqld => {
      bind_address => $public ? { true => undef, false => '127.0.0.1'},
    },
  }

  class { '::mysql::server':
    root_password           => $root_password,
    create_root_user        => true,
    create_root_my_cnf      => true,
    remove_default_accounts => true,
    restart                 => true,
    service_enabled         => true,
    service_manage          => true,
    override_options        => $override_options
  }
  -> package{$additional_packages:
    ensure => latest
  }

  file{'/etc/security/limits.conf': ensure => file}
  -> file_line{'mysql-soft-limit':
    ensure => present,
    path   => '/etc/security/limits.conf',
    line   => 'mysql soft nofile 65535',
    notify => Service['mysqld'],
  }
  -> file_line{'mysql-hard-limit':
    ensure => present,
    path   => '/etc/security/limits.conf',
    line   => 'mysql hard nofile 65535',
    notify => Service['mysqld'],
  }

  file{'/etc/systemd/system/mysql.service.d': ensure => directory}
  -> file{'/etc/systemd/system/mysql.service.d/limits.conf': ensure => file}
  -> ini_setting{'mysql-service-LimitNOFILE':
    ensure  => present,
    path    => '/etc/systemd/system/mysql.service.d/limits.conf',
    section => 'Service',
    setting => 'LimitNOFILE',
    value   => 'infinity',
    notify  => Service['mysqld'],
  }
}
