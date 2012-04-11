define ppa($user, $package) {
  $slashed="${user}/${package}"
  $dashed="${user}-${package}"
  $sentinel = "/var/lib/apt/first-puppet-run"

  file { "source-${dashed}":
    ensure  => present,
    path    => "/etc/apt/sources.list.d/${dashed}-${lsbdistcodename}.list",
    content => "deb http://ppa.launchpad.net/${user}/${package}/ubuntu ${lsbdistcodename} main",
  }

  exec { "ppa-repo-ready-${dashed}" :
    command => "/usr/bin/apt-get update && touch ${sentinel}",
    require => File["source-${dashed}"],
    creates => "/var/lib/apt/lists/ppa.launchpad.net_${dashed}_ubuntu_dists_${lsbdistcodename}_Release",
    timeout => 3600,
  }
}
