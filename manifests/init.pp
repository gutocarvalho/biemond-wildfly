class wildfly(
  $version           = '8.2.0',
  $install_source    = undef,
  $java_home         = undef,
  $group             = $wildfly::params::group,
  $user              = $wildfly::params::user,
  $dirname           = $wildfly::params::dirname, #jboss_home
  $mode              = $wildfly::params::mode, #jboss_mode
  $config            = $wildfly::params::config, #jboss_config
  $java_xmx          = $wildfly::params::java_xmx,
  $java_xms          = $wildfly::params::java_xms,
  $java_maxpermsize  = $wildfly::params::java_maxpermsize,
  $mgmt_bind         = $wildfly::params::mgmt_bind,
  $public_bind       = $wildfly::params::public_bind,
  $mgmt_http_port    = $wildfly::params::mgmt_http_port,
  $mgmt_https_port   = $wildfly::params::mgmt_https_port,
  $public_http_port  = $wildfly::params::public_http_port,
  $public_https_port = $wildfly::params::public_https_port,
  $ajp_port          = $wildfly::params::ajp_port,
  $users_mgmt        = $wildfly::params::users_mgmt,
) inherits wildfly::params {

  include wildfly::install
  include wildfly::prepare
  include wildfly::setup
  include wildfly::service

  Class['wildfly::prepare'] ->
    Class['wildfly::install'] ->
      Class['wildfly::setup'] ->
        Class['wildfly::service']

}
