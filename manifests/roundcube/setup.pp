# @summary Install Roundcube webmail from package management
#
# @example
#   include isp3node::roundcube::setup
# @param packages
#   List of required packages for Roundcube
class isp3node::roundcube::setup(
  Array[String] $packages
) {
  debconf{'roundcube/dbconfig-upgrade':
    package => 'roundcube-core',
    item    => 'roundcube/dbconfig-upgrade',
    type    => 'boolean',
    value   => 'true',
  }
  -> debconf{'roundcube/dbconfig-install':
    package => 'roundcube-core',
    item    => 'roundcube/dbconfig-install',
    type    => 'boolean',
    value   => 'true',
  }
  -> debconf{'roundcube/mysql/app-pass':
    package => 'roundcube-core',
    item    => 'roundcube/mysql/app-pass',
    type    => 'password',
  }
  -> debconf{'roundcube/app-password-confirm':
    package => 'roundcube-core',
    item    => 'roundcube/app-password-confirm',
    type    => 'password',
  }
  -> package{$packages: ensure => latest}
}
