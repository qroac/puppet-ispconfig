# @summary Setup postfix mail service on this host
#
# @example
#   include isp3node::postfix::setup
# @param options
#   Options to apply to the postfix class in addition to hardcoded default options
# @param master_submission
#   Textblock to write as subnission-block into master.cf
# @param master_smtps
#   Textblock to write as smtps block into master.cf
# @param ispopts
#   Additional options beside optional configuration via $opions, that are required by ispconfigs server setup
# @param ispopts_mailman
#   Additional options that are required, if this host is set up with mailman
# @param additional_packages
#   Additional software to install after installing and configuring postfix
class isp3node::postfix::setup(
  Hash $options,
  String $master_submission,
  String $master_smtps,
  Hash $ispopts = {}, # applied to postfix main class
  Optional[Hash] $ispopts_mailman = {},
  Hash $ispconf = {}, # applied as additional config resource
  Hash $ispconf_mailman = {},
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
