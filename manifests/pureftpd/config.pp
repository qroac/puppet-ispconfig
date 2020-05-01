# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::pureftpd::config
# @param tlslevel
#   Enable ftp daemon to offer tls connections: 0->off; 1->on; 2->tls only
class isp3node::pureftpd::config(
  Integer[0, 2] $tlslevel,
) {
  $configfile = {
    ensure => present,
    path   => '/etc/default/pure-ftpd-common',
    notify => Service['pure-ftpd-mysql'],
  }
  $settings = {'' => {
    'STANDALONE_OR_INETD' => 'standalone',
    'VIRTUALCHROOT'       => true,
  }}
  create_ini_settings($settings, $configfile)

  file{'pureftpd-conf-tls':
    ensure  => file,
    path    => '/etc/pure-ftpd/conf/TLS',
    content => "${tlslevel}",
    notify  => Service['pure-ftpd-mysql'],
  }
  file{'/etc/ssl/private/pure-ftpd.pem':
      ensure => link,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      target => "/etc/ssl/local/${facts['fqdn']}.keybundle.pem",
      notify => Service['pure-ftpd-mysql'],
  }
  file{'/etc/ssl/private/pure-ftpd-dhparams.pem':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    target  => '/etc/ssl/local/dhparam.pem',
    notify  => Service['pure-ftpd-mysql'],
    require => Exec['ssl-dhparam'],
  }
}
