desc "Notify new friends for all fakes marked as schedule notify"
task :notify => :environment do
  puts 'Notifing fakes friends...'
  NotifyWorker.new.perform
  puts 'Done.'
end
