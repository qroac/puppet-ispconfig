# @summary Setup and configure nginx
#
# Installs nginx and configures required settings for ISPConfig along with
# a default page on the hosts FQDN having links to public interfaces like Webmail
#
# @example
#   include isp3node::nginx
class isp3node::nginx {
  include isp3node::nginx::setup
  include isp3node::nginx::defaulthost
  include isp3node::nginx::ispproxyhost
  include isp3node::nginx::automail

  Class['isp3node::nginx::setup']
  -> Class['isp3node::nginx::defaulthost']
  Class['isp3node::nginx::setup']
  -> Class['isp3node::nginx::ispproxyhost']
  Class['isp3node::nginx::setup']
  -> Class['isp3node::nginx::automail']
}
