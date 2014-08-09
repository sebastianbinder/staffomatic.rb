require 'rake/testtask'
require 'bundler'
Bundler::GemHelper.install_tasks

Rake::TestTask.new :spec do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.warning = true
end

task :default => :spec

namespace :doc do
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |task|
      task.files   = ['README.md', 'LICENSE.md', 'lib/**/*.rb']
      task.options = [
        '--output-dir', 'doc/yard',
        '--markup', 'markdown',
      ]
    end
  rescue LoadError
  end
end
