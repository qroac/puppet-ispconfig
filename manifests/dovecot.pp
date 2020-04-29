# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::dovecot
class isp3node::dovecot {
  include isp3node::dovecot::setup
  include isp3node::dovecot::ssl
  include isp3node::dovecot::rspamd
  Class['isp3node::dovecot::setup']
    -> Class['isp3node::dovecot::ssl']
    -> Class['isp3node::dovecot::rspamd']
}
