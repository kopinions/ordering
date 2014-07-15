
ENVIRONMENTS = {
    :production => 'order_production'
}

remote_src_path='/home/vagrant/ordering/api'

namespace :deploy do
  desc "test"
  task :deploy_test do
    out = system("ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd /home/vagrant; ls > /dev/null; echo $?'")
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
      system("scp  -P 2222  -i /Users/twer/.vagrant.d/insecure_private_key .env vagrant@127.0.0.1:#{remote_src_path};")
    end
  end


  task :after_deploy, :env, :branch do |t, args|
    puts "Deployment Complete"
  end

  task :run, :env, :branch do |t, args|
    puts "Start to deploy"
    FileUtils.cd Rails.root do
      status = system("ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd #{remote_src_path}; bundle install --without test development'")
      start_status = system(" ssh -i /Users/twer/.vagrant.d/insecure_private_key vagrant@127.0.0.1 -p 2222 'cd #{remote_src_path}; nohup bundle exec rails server -d -e production </dev/null 2>&1 1>nohup.out &'")
    end
  end
end