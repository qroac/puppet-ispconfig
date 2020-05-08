# @summary Install and manage fail2ban on the server node
#
# @example
#   include isp3node::fail2ban
class isp3node::fail2ban {
  include isp3node::fail2ban::setup
}
