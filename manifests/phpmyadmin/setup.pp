# @summary Setup phpMyAdmin
#
# A description of what this class does
#
# @example
#   include isp3node::phpmyadmin::setup
# @param frontend
#   Set up a PMA web frontend or just list the server on other frontends
# @param source
#   Source URL to download latest PMA release
# @blowfish_secret
#   Secret string for session encryption
# @controluser
#   Control user username to create for PMA access to its config database
# @controlpass
#   Control user password for PMA access to its config database
# @config_file
#   Location of PMAs config file
class isp3node::phpmyadmin::setup(
  Boolean $frontend,
  Hash $source,
  String $blowfish_secret,
  String $controluser,
  String $controlpass,
  String $config_file = '/usr/share/phpmyadmin/config.inc.php',
) {
  # Enlist server as DB server in phpmyadmin
  @@isp3node::phpmyadmin::pmanode { $facts['fqdn']:
    server_group => 'ispconfig',
    controluser  => $controluser,
    controlpass  => $controlpass,
  }
  if($frontend){
    # Install phpMyAdmin
    file {'/usr/share/phpmyadmin': ensure => directory}
    -> file {'/etc/phpmyadmin': ensure => directory}
    -> file {'/var/lib/phpmyadmin': ensure => directory, owner => 'www-data', group => 'www-data'}
    -> file {'/var/lib/phpmyadmin/tmp': ensure => directory, owner => 'www-data', group => 'www-data'}
    -> file {'/etc/phpmyadmin/htpasswd.setup': ensure => file}
    -> archive { '/tmp/phpmyadmin.tar.gz':
      ensure          => present,
      extract         => true,
      extract_path    => '/usr/share/phpmyadmin',
      source          => $source['url'],
      checksum        => $source['checksum'],
      checksum_type   => $source['checksum_type'],
      cleanup         => true,
      extract_command => 'tar xfz %s --strip 1',
      creates         => '/usr/share/phpmyadmin/index.php',
    }
    # Write Config
    -> concat { $config_file:
      owner => '0',
      group => '0',
      mode  => '0644',
    }
    -> concat::fragment { '00_phpmyadmin_header':
      target  => $config_file,
      order   => '01',
      content => epp('isp3node/phpmyadmin/config.head.part', {
        blowfish_secret => $blowfish_secret,
      }),
    }
    -> isp3node::phpmyadmin::pmanode { "${facts['fqdn']}-localhost":
      target        => $config_file,
      myserver_name => '127.0.0.1',
      verbose_name  => 'localhost',
      server_group  => 'ispconfig',
      controluser   => $controluser,
      controlpass   => $controlpass,
    }
    # Include all ispconfig servers with pma module. 
    -> Isp3node::Phpmyadmin::Pmanode <<| server_group == 'ispconfig' and myserver_name != $facts['fqdn'] |>> {
      target => $config_file,
    }
    -> concat::fragment { '255_phpmyadmin_footer':
      target  => $config_file,
      order   => '255',
      content => epp('isp3node/phpmyadmin/config.globals.part'),
    }
    # Import PMA Tables and create control user
    -> mysql::db { 'phpmyadmin':
      user     => $controluser,
      password => $controlpass,
      host     => 'localhost',
      grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
      sql      => '/usr/share/phpmyadmin/sql/create_tables.sql'
    }
  }
}
