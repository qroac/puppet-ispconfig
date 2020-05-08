# @summary Install webstat tools to the server
#
# Installs common required packages along with packages required for Webstats and AWStats
#
# @example
#   include isp3node::webstats::setup
# @param packages
#   Common required packages
# @param packages_webalizer
#   Software required for webalizer
# @param packages_awstats
#   Software required for awstats
# @param awstats_conffile
#   System path to awstats cronfile, will be cleared as ISPConfig triggers updates itself
# @param webalizer
#   Install Webalizer or not
# @param awstats
#   Install AWStats or not
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
