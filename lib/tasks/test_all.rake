begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:custom_rubocop) do |t|
    t.options = %w[--cache false --format progress --format html --out rubocop.html]
  end

  namespace :test do
    task serial: %i[custom_rubocop spec]

    task all: %i[custom_rubocop] do
      Rake::Task['parallel:setup'].invoke
      Rake::Task['parallel:spec'].invoke('--verbose-rerun-command')
    end
  end
rescue LoadError
  puts 'Could not load required dependencies to create the "test:all" task'
end
