# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'knife-bento/version'

Gem::Specification.new do |s|
  s.name         = 'knife-bento'
  s.version      = KnifeBento::VERSION
  s.authors      = ['Baptiste.Bonnaudet']
  s.email        = ['freshair@mailbox.org']
  s.homepage     = 'https://github.com/baptiste-bonnaudet/knife-bento'
  s.summary      = 'Manage hashicorp vault through knife plugin'
  s.description  = 'show, edit, debug'
  s.license      = 'Nonstandard'

  s.files        = `git ls-files`.split("\n")
  s.files        = s.files.reject { |f| f.include?('.gem') }
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.require_paths = ['lib']
  s.metadata['allowed_push_host'] = 'foo'
end
