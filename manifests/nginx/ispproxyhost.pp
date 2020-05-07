# @summary A short summary of the purpose of this class
#
# A description of what this class does
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
