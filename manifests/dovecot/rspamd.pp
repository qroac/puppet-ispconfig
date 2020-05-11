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

  $mynetworks = ['127.0.0.0/8, ::ffff:127.0.0.0/104, ::1/128']
  # Query PuppetDB for IPs of satellite servers that use this MTA
  # as relay host
  $ips_query = "inventory[facts.networking.ip,facts.networking.ip6] { facts.isp3node.postfix.mode = 'satellite' and facts.isp3node.postfix.relay='${facts[fqdn]}' }"
  $satellite_ips = puppetdb_query($ips_query)
  $mysatellites = $satellite_ips.map |$satellite| {
      "${satellite['facts.networking.ip']}, ${satellite['facts.networking.ip6']}"
  }
  $options = { options => {
    local_addrs => "[${join($mynetworks + $mysatellites, ', ')}]",
    dns => {
      nameserver => ['127.0.0.1:53:10']
    }
  }}
  rspamd::create_config_file_resources($config + $options)

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
