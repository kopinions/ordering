# List of environments and their heroku git remotes
ENVIRONMENTS = {
    :production => 'myapp-production'
}

namespace :deploy do
  ENVIRONMENTS.keys.each do |env|
    desc "Deploy to #{env}"
    task env do
      current_branch = "master"
      Rake::Task['deploy:before_deploy'].invoke(env, current_branch)
      Rake::Task['deploy:run'].invoke(env, current_branch)
      Rake::Task['deploy:after_deploy'].invoke(env, current_branch)
    end
  end

  task :before_deploy, :env, :branch do |t, args|
    require 'securerandom'
    FileUtils.cd Rails.root do
      secret = SecureRandom.hex(64)
      system("echo SECRET_KEY_BASE=#{secret} > .env")
      puts "Deploying #{args[:branch]} to #{args[:env]}"
      system("scp  -P 2222  -i /Users/twer/.vagrant.d/insecure_private_key .env vagrant@127.0.0.1:/home/vagrant/ordering")
    end
  end


  task :after_deploy, :env, :branch do |t, args|
    puts "Deployment Complete"
    # output = system("rails server &")
    puts "start server complete"
  end

  task :run, :env, :branch do |t, args|
    FileUtils.cd Rails.root do
      # success = system("bundle install")
      # puts success ? "OK" : "FAIL"
      status = system("ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant/ordering; bundle install --without test development'")
      unless status
        puts "error"
        exit 1
      end
      puts status, "status"
      system(" ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant/ordering; nohup bundle exec rails server -d -e production </dev/null 2>&1 1>nohup.out &'")
      puts "Updating #{ENVIRONMENTS[args[:env]]} with branch #{args[:branch]}"
    end
  end
end