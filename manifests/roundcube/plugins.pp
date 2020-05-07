# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::roundcube::plugin::ispconfig
class isp3node::roundcube::plugins(
  String $repository_ispconfig,
  String $api_user = Undef,
  String $api_pass = Undef,
  String $api_host = lookup('isp3node::master'),
  Array[String] $enabled = [],
) {
  if($api_user and $api_pass and $api_host){
    ensure_resource('package', 'git')
    vcsrepo { '/usr/share/roundcube/plugins-vcs/ispconfig':
      ensure   => latest,
      provider => git,
      source   => $repository_ispconfig,
      require  => Package['git'],
    }
    $basepath = '/usr/share/roundcube'
    $folders = [
      'ispconfig3_account', 'ispconfig3_autoreply','ispconfig3_autoselect',
      'ispconfig3_fetchmail','ispconfig3_filter', 'ispconfig3_forward',
      'ispconfig3_pass', 'ispconfig3_spam', 'ispconfig3_wblist'
    ]
    $folders.each |$f| {
      file{"roundcube-plugin-${f}":
        ensure => link,
        path   => "${basepath}/plugins/${f}",
        target => "${basepath}/plugins-vcs/ispconfig/${f}",
      }
    }
    file{'roundcube-plugin-ispconfig3_account-config':
      ensure  => file,
      path    => '/usr/share/roundcube/plugins-vcs/ispconfig/ispconfig3_account/config/config.inc.php',
      content => epp('isp3node/roundcube/plugin.ispconfig_account.config.php', {
        api_host => $api_host,
        api_user => $api_user,
        api_pass => $api_pass,
      })
    }
    $pluginstring = join($enabled, '", "')
    $ini_settings = {'' => {
      '$config[\'identities_level\']' => '2;',
      '$config[\'default_host\']' => '\'\';',
      '$config[\'plugins\']' => "array(\"${pluginstring}\");"
    }}
    create_ini_settings($ini_settings, {path => '/etc/roundcube/config.inc.php'})
  }
}
