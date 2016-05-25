defmodule CFM.HttpServer do 
    use Cauldron
    
    alias CFM.ServiceStatus
    
    def listen(port) do 
        IO.puts "HttpServer listening @ " <> to_string(port)
        Cauldron.start(__MODULE__, port: port)
    end
    
    def handle("GET", %URI{path: "/"}, req) do 
        req |> Request.reply(200, "CFM!")
    end
    
    def handle("GET", %URI{path: "/alive"}, req) do 
        status = ServiceStatus.is_alive
        if status do 
            req |> Request.reply(200, "alive")
        else
            req |> Request.reply(503, "dead")
        end
    end
end