# @summary Setup mailman mailing list software on the host
#
# Installs and configures mailman along with required nginx locations
# Further adds links to mailman and list archives to the servers default page
#
# @example
#   include isp3node::mailman
class isp3node::mailman {
  class{'isp3node::mailman::setup':}
  -> class{'isp3node::mailman::configure':}
  -> class{'isp3node::mailman::config::nginx':}

  isp3node::nginx::startpageentry { 'mailman':
    verbose_name => 'Mailinglists',
    path         => '/cgi-bin/mailman/listinfo',
  }
  isp3node::nginx::startpageentry { 'pipermail':
    verbose_name => 'Archive',
    path         => '/pipermail',
  }
}
