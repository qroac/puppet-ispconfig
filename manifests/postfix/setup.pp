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
  Optional[Hash] $ispopts_mailman = {},
  Hash $ispconf = {}, # applied as additional config resource
  Hash $ispconf_mailman = {},
  Optional[Boolean] $mailman = false,
  Optional[Array[String]] $additional_packages = [],
) {
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
  unless($facts['isp3node']['mailman']['installed']){
    class {'postfix':
      * => $options + $default_opts + $ispopts
    }
  } else{
    class {'postfix':
      * => $options + $default_opts + $ispopts + $ispopts_mailman
    }
  }
  package{$additional_packages:
    ensure  => latest,
    require => Class['postfix'],
  }
  # Add ispconfig settings only if ispconfig server is installed!
  if($facts['isp3node']['ispconfig']['installed']){
    unless($facts['isp3node']['mailman']['installed']){
      $ispconf.each |$s, $v| {
        postfix::config{$s:
          ensure => present,
          value  => $v,
        }
      }
    } else {
      ($ispconf + $ispconf_mailman).each |$s, $v| {
        postfix::config{$s:
          ensure => present,
          value  => $v,
        }
      }
    }
  }
}
