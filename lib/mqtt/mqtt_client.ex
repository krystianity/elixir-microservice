defmodule CFM.MqttClient do
    use Hulaaki.Client
    
    alias CFM.MqttWrapper
    alias CFM.AppClient
    
    def on_connect_ack(options) do
        IO.puts "Mqtt connection established; sending ping.."
        MqttWrapper.ping
    end
    
    def on_pong(options) do
        AppClient.mqtt_ready
    end
    
    def on_subscribe_ack(options) do
        IO.puts "Mqtt subscription made."
    end
    
    def on_subscribed_publish(options) do
        AppClient.on_mqtt_message(options[:message].id, options[:message].topic, options[:message].message)
    end
end