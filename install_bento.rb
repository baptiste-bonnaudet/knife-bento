#!/usr/bin/env ruby
system 'rm -rf knife-*gem'
gem_loc = ARGV[0]
gem_loc ||= 'gem'
system "#{gem_loc} uninstall knife-bento"
system "#{gem_loc} build knife-bento.gemspec"
system "#{gem_loc} install knife-bento --local"
