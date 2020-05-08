# @summary Set up this host as postfix satellite
#
# @example
#   include isp3node::postfix::satellite
# @param relay
#   Hostname of Mail Relay server that will accept forwards from this host
class isp3node::postfix::satellite(
  String $relay
) {
  class{'isp3node::postfix::setup':
    options => {
      satellite  => true,
      mynetworks => '127.0.0.0/8, [::1]/128',
      relayhost  => $relay,
    }
  }
}
