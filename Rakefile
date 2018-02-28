require 'fileutils'
require 'html-proofer'
require 'etc'

task :test do
  FileUtils.rm_rf('./.testcontent')
  sh "bundle exec jekyll build --config _config.yml,_config_test.yml"
  HTMLProofer.check_directory("./.testcontent", {
    :allow_hash_href => true,
    :check_html => true,
    :file_ignore => [/javadoc/, /v2/, /pydoc/],
    :parallel => { :in_processes => Etc.nprocessors },
    }).run
end
