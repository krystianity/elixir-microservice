# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :kv, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:kv, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :cfm,
    run_mqtt_client: false,
    mqtt_c: "cfm.client",
    mqtt_host: "localhost",
    mqtt_port: 1883,
    mqtt_topics: [ "cfm.global", "cfm.info", "cfm.wurst" ],
    
    run_http_client: true,
    run_http_server: true,
    http_server_port: 44124,
    
    run_mysql_client: false,
    
    run_redis_client: false,
    redis_host: "localhost",
    redis_port: 6379
    
config :cfm, ecto_repos: [CFM.Repo]
config :cfm, CFM.Repo,
    adapter: Ecto.Adapters.MySQL,
    database: "cfm_test",
    username: "root",
    password: ""

config :logger,
    backends: [:console],
    compile_time_purge_level: :info