# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::postfix::satellite
class isp3node::postfix::satellite(
  String $relay
) {
  # TODO Add a collectible information with my ip for the relay server
  class{'isp3node::postfix::setup':
    options => {
      satellite  => true,
      mynetworks => '127.0.0.0/8, [::1]/128',
      relayhost  => $relay,
    }
  }
}
