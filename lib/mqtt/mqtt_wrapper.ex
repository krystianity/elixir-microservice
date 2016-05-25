defmodule CFM.MqttWrapper do
    use GenServer
    
    alias CFM.DistStore
    alias CFM.MqttClient

    def start_link(client_id, host, port) do
        {:ok, spid} = GenServer.start_link(__MODULE__, %{}, name: :mqtt_wrapper)
        Process.monitor spid
        
        DistStore.set("mqtt_client_id", client_id)
        DistStore.set("mqtt_host", host)
        DistStore.set("mqtt_port", port)
        
        {:ok, pid} = MqttClient.start_link(%{})
        DistStore.set("mqtt_wrapper_pid", pid)
        Process.monitor pid
        
        connect(pid, client_id, host, port)
    end
    
    def connect(pid, p_client_id, p_host, p_port) do
        options = [client_id: p_client_id, host: p_host, port: p_port]
        MqttClient.connect(pid, options)
        {:ok, pid}
    end
    
    def ping do
        GenServer.cast(:mqtt_wrapper, {:ping})
    end
    
    def subscribe(p_topics) do
        options = [id: 11_111, topics: p_topics, qoses: [0]]
        GenServer.cast(:mqtt_wrapper, {:subscribe, options})
    end
    
    def publish(p_topic, p_message) do
        options = [id: 22_222, topic: p_topic, message: p_message, dup: 0, qos: 0, retain: 0]
        GenServer.cast(:mqtt_wrapper, {:publish, options})
    end
    
    def disconnect do
        GenServer.cast(:mqtt_wrapper, {:disconnect})
    end
    
    #async handles
    
    def handle_cast({:ping}, state) do
        {:ok, pid} = DistStore.get("mqtt_wrapper_pid")
        MqttClient.ping pid
        
        {:noreply, state}
    end
    
    def handle_cast({:subscribe, options}, state) do
        {:ok, pid} = DistStore.get("mqtt_wrapper_pid")
        MqttClient.subscribe(pid, options)
        
        {:noreply, state}
    end
    
    def handle_cast({:publish, options}, state) do 
        {:ok, pid} = DistStore.get("mqtt_wrapper_pid")
        MqttClient.publish(pid, options)
        
        {:noreply, state}
    end
    
    def handle_cast({:disconnect}, state) do 
        {:ok, pid} = DistStore.get("mqtt_wrapper_pid")
        MqttClient.disconnect pid
        MqttClient.stop pid
        
        {:noreply, state}
    end 
    
    def init do
        {:ok, %{}}
    end
end 