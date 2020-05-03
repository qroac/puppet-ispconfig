# Configure node for usage as ISP3 Webserver Node
# with apache2 or nginx
# public listening mariadb
# multiple php installations with all suggested packages
# phpmyadmin
# webmail
# jailkit
# managed ssl certificate for hostname fqdn (optional from LE)
class isp3node::profile::web(){
  class {'isp3node::base':
    le_deploycommands => [
      'systemctl reload nginx',
      'systemctl restart pure-ftpd-mysql'
    ]
  }
  -> class {'isp3node::mariadb':
    public => true,
  }
  -> class {'isp3node::postfix': mode => 'satellite'}
  -> class {'isp3node::nginx':}
  -> class {'isp3node::php': set => 'web'}
  -> class {'isp3node::phpmyadmin':}
  -> class {'isp3node::pureftpd':}
  -> class {'isp3node::quota':}
  -> class {'isp3node::webstats':}
  -> class {'isp3node::jailkit':}
  -> class {'isp3node::fail2ban':}
}
