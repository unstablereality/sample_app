#!/bin/bash

bundle exec rake db:reset
bundle exec rake db:populate
bundle exec rake test:prepare
