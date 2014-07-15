# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{127.0.0.1}
role :web, %w{127.0.0.1}
role :db,  %w{127.0.0.1}

set :rails_env, :production
set :stage, :production
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server '127.0.0.1', user: 'vagrant', roles: %w{web app db}, my_property: :my_value

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
server '127.0.0.1',
  port: 2222,
  user: 'vagrant',
  roles: %w{web app db},
  ssh_options: {
    user: 'vagrant', # overrides user setting above
    keys: %w(/Users/twer/.vagrant.d/insecure_private_key),
    forward_agent: true,
    auth_methods: %w(publickey password)
    # password: 'please use keys'
  }
