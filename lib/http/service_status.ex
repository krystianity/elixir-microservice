defmodule CFM.ServiceStatus do
    
    alias CFM.DistStore
    
    def is_alive do 
        res = DistStore.get("service_status")
        status = case res do 
            {:ok, status} -> status
            {:error} -> nil
            _ -> nil
        end
        
        if is_nil(status) do 
            DistStore.set("service_status", false)
            status = false
        end
        
        status
    end
    
    def set_alive(status) when is_boolean(status) do 
        IO.puts "Changing Service Status to " <> to_string(status)
        DistStore.set("service_status", status)
    end
end