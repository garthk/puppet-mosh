class test_server {
  group { 'puppet': 
    ensure => present,
  }

  include mosh
}

include test_server
