# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::roundcube::plugin::ispconfig
class isp3node::roundcube::plugins(
  Array $base_plugins,
  String $ispconfig_repo,
  Array $ispconfig_plugins,
  Array[String] $additional = [],
  String $remoteuser = Undef,
  String $remotepass = Undef,
  String $api_host = lookup('isp3node::master'),
) {
  if($remoteuser and $remotepass and $api_host){
    $rc_plugindir = '/usr/local/ispconfig-puppet/roundcube/plugins-ispconfig'
    file{'rc-pluginfolder':
      ensure => directory,
      path   => $rc_plugindir
    }
    ensure_resource('package', 'git')
    vcsrepo { '/usr/local/ispconfig-puppet/roundcube/plugins-ispconfig':
      ensure   => latest,
      provider => git,
      source   => $ispconfig_repo,
      require  => [Package['git'], File['rc-pluginfolder']],
    }
    $ispconfig_plugins.each |$p| {
      $p_loc = "/usr/local/ispconfig-puppet/roundcube/plugins-ispconfig/${p}"
      file{"/usr/share/roundcube/plugins/${p}":
        ensure => link,
        target => $p_loc
      }
      file{"/var/lib/roundcube/plugins/${p}":
        ensure => link,
        target => $p_loc
      }
    }
    file{'roundcube-plugin-ispconfig3_account-config':
      ensure  => file,
      path    => '/usr/local/ispconfig-puppet/roundcube/plugins-ispconfig/ispconfig3_account/config/config.inc.php',
      content => epp('isp3node/roundcube/plugin.ispconfig_account.config.php', {
        api_host => $api_host,
        api_user => $remoteuser,
        api_pass => $remotepass,
      })
    }
    $pluginstring = join($base_plugins + $additional + $ispconfig_plugins, '", "')
    $ini_settings = {'' => {
      '$config[\'identities_level\']' => '2;',
      '$config[\'default_host\']' => '\'\';',
      '$config[\'plugins\']' => "array(\"${pluginstring}\");"
    }}
    create_ini_settings($ini_settings, {path => '/etc/roundcube/config.inc.php'})
    # remove remaining closing bracket that is usually in next line of plugin definition
    file_line{'rc-config-no-orphan-bracket':
      ensure => absent,
      path   => '/etc/roundcube/config.inc.php',
      line   => ');'
    }
  }
}
