# @summary Install Webstat tools
#
# Installs Webalizer and AWStats as required for ISPConfig webservers
#
# @example
#   include isp3node::webstats
class isp3node::webstats {
  include isp3node::webstats::setup
}
