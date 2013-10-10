# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#
#
# Production Environment setup for YamOverflow
#
class yamoverflow::production {
  package{["nginx-full","postgresql","build-essential","libpq-dev"]:
    ensure => present,
  }

  group{ yamoverflow:
    ensure => present,
  }

  user{ yamoverflow:
    ensure => present,
    gid => yamoverflow,
    shell => "/bin/bash",
    require => Group[yamoverflow],
  }

  file{"/opt/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
    mode => 0644,
    require => [Group[yamoverflow],User[yamoverflow]],
  }

  file{["/var/run/yamoverflow","/var/lock/yamoverflow"]:
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
  }

  file{"/var/log/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
  }

  file{"/etc/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
  }

  file{"/usr/local/bin/update_questions.sh":
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    source => "puppet:///modules/yamoverflow/update_questions.sh",
  }

  cron{"update-questions":
    ensure => present,
    command => "/usr/local/bin/update_questions.sh",
    user => yamoverflow,
    hour => "*/2",
    minute => 0,
    environment => "PATH=/sbin:/bin:/usr/sbin:/usr/bin",
  }

  file{"/etc/init/yamoverflow.conf":
    ensure => present,
    source => "puppet:///modules/yamoverflow/yamoverflow.conf",
    owner => root,
    group => root,
    mode => 0644,
  }

  file{"/etc/nginx/sites-available/yamoverflow":
    ensure => present,
    owner => root,
    group => root,
    mode => 0600,
    source => "puppet:///modules/yamoverflow/nginx.conf",
    notify => Service[nginx],
  }

  file{"/etc/nginx/sites-enabled/yamoverflow":
    ensure => link,
    target => "/etc/nginx/sites-available/yamoverflow",
    notify => Service[nginx],
  }

  service{"nginx":
    ensure => running,
  }

  #rvm setup
  package{"ruby-rvm":
    ensure => purged,
  }

  file{["/usr/share/ruby-rvm","/etc/rvmrc","/etc/profile.d/rvm.sh"]:
    ensure => absent,
    recurse => true,
  }

  exec {"install-rvm":
    path => ["/usr/bin","/usr/sbin","/sbin","/bin"],
    command => "curl -L https://get.rvm.io | bash -s stable",
    creates => "/usr/local/rvm",
  }
}
