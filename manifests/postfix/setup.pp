# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix::setup
class isp3node::postfix::setup(
  Hash $options,
  String $master_submission,
  String $master_smtps,
  Hash $ispopts = {}, # applied to postfix main class
  Hash $ispconf = {}, # applied as additional config resource
  Hash $ispsettings_mailman = {},
  Optional[Boolean] $mailman = false,
  Optional[Array[String]] $additional_packages = [],
) {
  # TODO merge strings in ispsettings_mailman into ispsettings if mailman is installed, keep main config clean
  $default_opts = {
    root_mail_recipient => lookup('isp3node::email'),
    myorigin => $facts['fqdn'],
    mydestination => "${facts[fqdn]}, localhost, localhost.localdomain",
    master_submission => $master_submission,
    master_smtps => $master_smtps,
    manage_mailx => true,
    # ? use_amavisd => true,
    # ? use_dovecot_lda = true,
  }
  class {'postfix':
    * => $options + $default_opts + $ispopts
  }
  -> package{$additional_packages:
    ensure => latest,
  }
  $ispconf.each |$s, $v| {
    postfix::config{$s:
      ensure => present,
      value  => $v,
    }
  }
}
