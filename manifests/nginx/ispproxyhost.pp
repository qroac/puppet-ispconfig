# @summary Defaultpage location for ISPConfig
#
# Adds a location to the defaultpage to access ISPConfig at /cp/
# Only on the master node, because all other hosts aren't allowed to reverse proxy
# to ISPConfig
#
# @example
#   include isp3node::nginx::ispproxyhost
class isp3node::nginx::ispproxyhost {
  if($facts['fqdn'] == lookup('isp3node::master')) {
    nginx::resource::location{'cp':
      ensure   => present,
      server   => $facts['fqdn'],
      ssl      => true,
      ssl_only => true,
      location => '/cp/',
      proxy    => "https://${lookup('isp3node::master')}:8080/"
    }
    isp3node::nginx::startpageentry { 'isp':
      verbose_name => 'Control Panel',
      path         => '/cp/',
    }
  }
}
