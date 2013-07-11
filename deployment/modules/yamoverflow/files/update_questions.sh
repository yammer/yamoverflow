#!/bin/bash
(
  flock -n -s 200
	source /opt/yamoverflow/current/environment
	source /etc/yamoverflow/creds
	cd /opt/yamoverflow/current/
	bundle exec rake update_questions
  ) 200>/var/lock/yamoverflow/update_questions