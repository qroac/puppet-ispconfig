# @summary A short summary of the purpose of this class
#
# A description of what this class does
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
