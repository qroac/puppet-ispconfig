# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::webstats::setup
class isp3node::webstats::setup(
  Array[String] $packages,
  Array[String] $packages_webalizer,
  Array[String] $packages_awstats,
  String $awstats_cronfile,
  Boolean $webalizer = true,
  Boolean $awstats = true,
) {
  package{$packages: ensure => latest}
  if($awstats) {
    package{$packages_awstats: ensure => latest}
    # Drop the awstats cronjobs -> will be triggered by ISPConfig
    -> file{$awstats_cronfile: ensure => absent}
  }
  if($webalizer) {
    package{$packages_webalizer: ensure => latest}
  }
}
