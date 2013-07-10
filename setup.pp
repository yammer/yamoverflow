#
# Production Environment setup for YamOverflow
#

package{"ruby-rvm":
  ensure => present,
}

group{ yamoverflow:
  ensure => present,
}

user{ yamoverflow:
  ensure => present,
  gid => yamoverflow,
  shell => "/bin/false",
  require => Group[yamoverflow],
}

file{"/opt/yamoverflow":
  ensure => directory,
  owner => yamoverflow,
  group => yamoverflow,
  mode => 0640,
  require => [Group[yamoverflow],User[yamoverflow]],
}
