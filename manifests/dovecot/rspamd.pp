# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::dovecot::rspamd
# @param config
#   Configuration for rspamd
# @param nameserver
#   Package to install as local nameserver. Set to undef if there is already another nameserver present on the system.
class isp3node::dovecot::rspamd(
  Hash $config,
  Optional[String] $nameserver = undef,
) {
  # rspamd requires a local nameserver
  if($nameserver) {
    package{$nameserver: ensure => latest}
  }

  class { 'rspamd': }
  rspamd::create_config_file_resources($config)
  
  Class['isp3node::redis'] -> Class['rspamd']
}
