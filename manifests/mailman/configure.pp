# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::mailman::configure
class isp3node::mailman::configure(
  String $admin_email,
  String $admin_password,
) {
  exec { 'create_site_list':
    command => "newlist -q mailman '${admin_email}' '${admin_password}'",
    path    => '/usr/lib/mailman/bin',
    creates => '/var/lib/mailman/lists/mailman/config.pck',
  }

  $mm_aliases = {
    'mailman'             => { recipient => '"|/var/lib/mailman/mail/mailman post mailman"'},
    'mailman-admin'       => { recipient => '"|/var/lib/mailman/mail/mailman admin mailman"'},
    'mailman-bounces'     => { recipient => '"|/var/lib/mailman/mail/mailman bounces mailman"'},
    'mailman-confirm'     => { recipient => '"|/var/lib/mailman/mail/mailman confirm mailman"'},
    'mailman-join'        => { recipient => '"|/var/lib/mailman/mail/mailman join mailman"'},
    'mailman-leave'       => { recipient => '"|/var/lib/mailman/mail/mailman leave mailman"'},
    'mailman-owner'       => { recipient => '"|/var/lib/mailman/mail/mailman owner mailman"'},
    'mailman-request'     => { recipient => '"|/var/lib/mailman/mail/mailman request mailman"'},
    'mailman-subscribe'   => { recipient => '"|/var/lib/mailman/mail/mailman subscribe mailman"'},
    'mailman-unsubscribe' => { recipient => '"|/var/lib/mailman/mail/mailman unsubscribe mailman"'},
  }
  create_resources('postfix::mailalias', $mm_aliases, { ensure => present, notify => [Service['postfix'], Service['mailman']] })

  service { 'mailman':
    ensure  => running,
    require => Exec['create_site_list'],
  }
  Service['postfix'] ~> Service['mailman']
  Package['mailman'] -> Exec['create_site_list']
  Exec['create_site_list'] -> Service['mailman']
}
