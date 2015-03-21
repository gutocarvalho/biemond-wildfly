class wildfly::params {

  $group   = 'wildfly'
  $user    = 'wildfly'
  $dirname = '/opt/wildfly'

  $service_file  = $::osfamily? {
    Debian  => 'wildfly-init-debian.sh',
    RedHat  => 'wildfly-init-redhat.sh',
    default => 'wildfly-init-redhat.sh',
  }

  $mode              = 'standalone'
  $config            = 'standalone-full.xml'

  $mgmt_bind         = '0.0.0.0'
  $mgmt_http_port    = '9990'
  $mgmt_https_port   = '9993'

  $public_bind       = '0.0.0.0'
  $public_http_port  = '8080'
  $public_https_port = '8443'

  $ajp_port          = '8009'

  $java_xmx          = '512m'
  $java_xms          = '128m'
  $java_maxpermsize  = '256m'

  $users_mgmt = {
    'wildfly' => {
      username => 'wildfly',
      password => 'wildfly',
    },
  }

}