defmodule CFM.AppClient do
    use GenServer
    
    require Logger

    alias CFM.MqttClient
    alias CFM.MqttWrapper
    alias CFM.DistStore
    
    #framework tests (examples..)
    alias CFM.HttpWrapper
    alias CFM.HttpServer
    alias CFM.EctoWrapper
    alias CFM.RedisWrapper
    alias CFM.ServiceStatus
    
    def start_link do
        IO.puts "Starting client.."
      
        #run a few lib tests
        try do
            run_test
        rescue
            e in RuntimeError -> e
            IO.puts to_string(e)
        end
        
        ServiceStatus.set_alive(true)
        GenServer.start_link(__MODULE__, [], name: :app_client)
    end
    
    def run_test do 
        
        #logger test
        Logger.debug "debuuug"
        Logger.info "iiinfooo"
        Logger.warn "waarniing"
        Logger.error "errorororor"
        
        #http client test
        if Application.get_env(:cfm, :run_http_client) do
            HttpWrapper.start
            HttpWrapper.get "https://www.google.de/does/not/exist"
        end
        
        #http server test
        if Application.get_env(:cfm, :run_http_server) do
            http_port = Application.get_env(:cfm, :http_server_port)
            HttpServer.listen http_port
        end
        
        #mysql orm test
        if Application.get_env(:cfm, :run_mysql_client) do
            EctoWrapper.keyword_query
        end
        
        #run mqtt test
        if Application.get_env(:cfm, :run_mqtt_client) do
            run_mqtt_client
        end
        
        #run redis test
        if Application.get_env(:cfm, :run_redis_client) do
            redis_host = Application.get_env(:cfm, :redis_host)
            redis_port = Application.get_env(:cfm, :redis_port)
            {:ok, _} = RedisWrapper.start_link(redis_host, redis_port)
            RedisWrapper.set("cfm.bla", "wurst")
            IO.inspect RedisWrapper.get("cfm.bla")
        end
        
        {:ok}
    end
    
    def run_mqtt_client do
    
        DistStore.set("mqtt_lock", nil)
        client_name = Application.get_env(:cfm, :mqtt_c)
        host = Application.get_env(:cfm, :mqtt_host)
        port = Application.get_env(:cfm, :mqtt_port)
        {:ok, pid} = MqttWrapper.start_link(client_name, host, port)
        Process.monitor pid
    end

    #called by /mqtt/mqtt_client.ex
    def mqtt_ready do
        
        {:ok, lock} = DistStore.get("mqtt_lock")
        
        if is_nil(lock) do
            DistStore.set("mqtt_lock", "set")
            IO.inspect DistStore.all
            subscribe
            MqttWrapper.publish("cfm.global", "ready")
            start_period
        else
            IO.puts "Pong-ed back, interval returned."
        end
    end
    
    #called by /mqtt/mqtt_client.ex
    def subscribe do
        IO.puts "Subscribing to topics.."
        topics = Application.get_env(:cfm, :mqtt_topics)
        Enum.map(topics, fn(topic) -> MqttWrapper.subscribe([topic]) end)
        
        MqttWrapper.publish("cfm.global", "alive")
        {:ok}
    end
    
     #called by /mqtt/mqtt_client.ex
    def on_mqtt_message(id, topic, message) do
    
        if is_nil(id) do
            id = "nil"
        end
        
        if is_nil(topic) do
            topic = "nil"
        end
        
        if is_nil(message) do
            message = "nil"
        end
    
        #MqttWrapper.publish("cfm.echo", message <> " nein.")
        IO.puts topic <> ": " <> to_string(id) <> ", " <> message
        
        case topic do
            "cfm.global" -> IO.puts "Mqtt: Info: " <> message
            "cfm.alive" -> IO.puts "Mqtt: Some1 is alive: " <> message
            "cfm.wurst" -> IO.puts "Mqtt: A message for me: " <> message
            _ -> IO.puts "Mqtt: Unknown topic: " <> topic
        end
    end
    
    def end_client do
        MqttWrapper.disconnect
    end
    
    #called by /mqtt/mqtt_client.ex
    def start_period do
        #the process will die without this internal keep-alive pinging
        IO.puts "Starting period."
        Process.send_after(:app_client, :interval, 10 * 1000)
        {:ok}
    end
    
    def handle_info(:interval, state) do
        IO.puts "Interval, sending ping."
        MqttWrapper.ping
        Process.send_after(:app_client, :interval, 10 * 1000)
        {:noreply, state}
    end
    
    def init do
        {:ok, %{}}
    end
end