# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix::standalone
class isp3node::postfix::standalone {
  # TODO Collect IPs from satellite servers and add to mynetworks
  class{'isp3node::postfix::setup':
    options => {
      mynetworks => '127.0.0.0/8, [::1]/128',
    }
  }
}
