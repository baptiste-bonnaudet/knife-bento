#!/usr/bin/env ruby
system 'rm -rf knife-*gem'
gem_loc = ARGV[0]
gem_loc ||= 'gem'
system "#{gem_loc} uninstall knife-vaultdatabag"
system "#{gem_loc} build knife-vaultdatabag.gemspec"
system "#{gem_loc} install knife-vaultdatabag --local"
