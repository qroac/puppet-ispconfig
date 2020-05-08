# @summary Setup RSpamd service with web dashboard
#
# Installs and configures RSpamd
# Further adds a nginx location at '/rspamd/' on the servers FQDN to access the dashboard
# The dashboards access password is not managed by puppet, as it should be set in ispconfig later
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
  class { 'rspamd': purge_unmanaged => false}
  rspamd::create_config_file_resources($config)

  Class['isp3node::redis'] -> Class['rspamd']

  nginx::resource::location {'rspamd-dashboard':
    ensure           => present,
    server           => $facts['fqdn'],
    ssl              => true,
    ssl_only         => true,
    location         => '/rspamd/',
    proxy            => 'http://127.0.0.1:11334/',
    proxy_set_header => [
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Real-IP $remote_addr',
      'Host $http_host',
    ],
  }
}
