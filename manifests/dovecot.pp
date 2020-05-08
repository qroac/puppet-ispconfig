# @summary Install and configure Dovecot Server
#
# Installs and configures a dovecot Mailbox server along with RSpamd 
#
# @example
#   include isp3node::dovecot
class isp3node::dovecot {
  include isp3node::dovecot::setup
  include isp3node::dovecot::ssl
  include isp3node::dovecot::rspamd
  service{'dovecot':
    ensure => running,
    enable => true,
  }
  Class['isp3node::dovecot::setup']
    -> Class['isp3node::dovecot::ssl']
    -> Class['isp3node::dovecot::rspamd']
  Class['isp3node::dovecot::setup']
    -> Service['dovecot']
}
