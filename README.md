# (CF)M - (Elixir Base) Microservice

- Mqtt 3.1 (using hulaaki)
- Http Client (using httpoison)
- Http Server (using cauldron)
- DSL/ORM/Database for MySQL (using ecto & mariaex)
- Cache/Redis (using redix)
- Json Parsing (using poison)
- Logging (using logger)

# How to setup & run
- install Erlang
- install Elixir
- install Mix
- http://elixir-lang.org/install.html#unix-and-unix-like

- git clone the repo
- chmod 777 ./run
- ./run

#Testing
- run mix test

# Info
- Mqtt, MySQL and Redis clients have been turned of by default (see /config/config.exs)
- because the Base should be easy to start out of the box (without requiring the 3d party services)
- simply enable change the values to "true" in the config.exs to run the examples

# Further
- to use ecto & mariaex example: u need a MySQL Server with the Sample Table, make sure to configure /config/config.exs
- to use redix example: u need a Redis Server, make sure to configure /config/config.exs
- to use mqtt example: u need a running Mqtt v2.+ better v3.+ Broker, best is "emqtt", make sure to configure /config/config.exs

# FAQ
- Christian Fröhlingsdorf <chris@5cf.de>