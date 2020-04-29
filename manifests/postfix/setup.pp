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
  Optional[Boolean] $mailman = false,
  Optional[Array[String]] $additional_packages = [],
) {
  $default_opts = {
    root_mail_recipient => lookup('isp3node::email'),
    myorigin => $facts['fqdn'],
    mailman => $mailman,
    master_submission => $master_submission,
    master_smtps => $master_smtps,
    manage_mailx => true,
    # ? use_amavisd => true,
    # ? use_dovecot_lda = true,
  }
  class {'postfix':
    * => $options + $default_opts
  }
  -> package{$additional_packages:
    ensure => latest,
  }
}
