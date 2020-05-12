# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::nginx::automail
class isp3node::nginx::automail {
  # Only if this is a standalone postfix server and automail.fqdn resolves to this host
  if($facts['isp3node']['postfix']['installed'] and
    $facts['isp3node']['postfix']['mode'] == 'standalone' and
    $facts['isp3node']['dovecot']['installed']) {
      $dns = dns_lookup("automail.${$facts['fqdn']}")
      notify{'dns-lookup': message => $dns}
  }
}
