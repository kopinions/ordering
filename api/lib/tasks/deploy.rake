
ENVIRONMENTS = {
    :production => 'order_production'
}



namespace :deploy do
  desc "test"
  task :deploy_test do
    out = %x{ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant; ls > /dev/null; echo $?'}
    unless out.strip. == '0'
      puts "fails"
      exit 1
    end
  end
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
    puts "Generage secret file"
    require 'securerandom'
    FileUtils.cd Rails.root do
      secret = SecureRandom.hex(64)
      system("echo SECRET_KEY_BASE=#{secret} > .env")
      puts "Copy secret file to remote machine"
      system("scp  -P 2222  -i /Users/twer/.vagrant.d/insecure_private_key .env vagrant@127.0.0.1:/home/vagrant/ordering;")
    end
  end


  task :after_deploy, :env, :branch do |t, args|
    puts "Deployment Complete"
  end

  task :run, :env, :branch do |t, args|
    puts "Start to deploy"
    FileUtils.cd Rails.root do
      status = %x{"ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant/ordering; bundle install --without test development > /dev/null; echo $?'"}
      puts status
      unless status.strip == "0"
        puts "error when bundle install"
        exit 1
      end
      start_status = %x{" ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant/ordering; nohup bundle exec rails server -d -e production </dev/null 2>&1 1>nohup.out & ; echo $?'"}
      puts start_status
      unless start_status.strip == "0"
        puts "error when start server"
        exit 1
      end
    end
  end
end