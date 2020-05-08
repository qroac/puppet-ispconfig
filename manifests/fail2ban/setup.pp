# @summary Setup fail2ban on the future ISPConfig server node
#
# Installs fail2ban on the host and enables jails as given in the parameters
#
# @example
#   include isp3node::fail2ban::setup
# @param jails
#   Predefined jails to apply to f2b, see list: https://forge.puppet.com/puppet/fail2ban/readme#pre-defined-jails
# @param servicejails
#   Jails to apply if the services are installed on the node (see fact isp3node::[servicename]::installed)
# @param custom_jails
#   Custom jail definitions to apply to f2b
# @param custom_servicejails
#   Custom jail definitions to apply if the service is installed (see fact isp3node::[servicename]::installed)
class isp3node::fail2ban::setup(
  Array[String] $jails,
  Hash[String, Array[String]] $servicejails,
  Optional[Hash[String, Hash]] $custom_jails = {},
  Optional[Hash[String, Hash[String, Hash]]] $custom_servicejails = {},
) {
  $servicejails.each |$s, $j| {
    if($facts['isp3node'][$s][installed]){
      $jails << $j
    }
  }
  $custom_servicejails.each |$s, $j| {
    if($facts['isp3node'][$s][installed]){
      $custom_jails << $j
    }
  }
  class { 'fail2ban':
    package_ensure => 'latest',
    jails          => $jails,
    custom_jails   => $custom_jails,
  }
}
