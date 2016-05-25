defmodule CFM.App do 
    use Application
    
    def start(_type, _args) do
        IO.puts "App starting Supervisor.."
        CFM.Supervisor.start_link
    end
end

defmodule CFM.Supervisor do 
    use Supervisor
    
    alias CFM.AppClient
    alias CFM.DistStore
    alias CFM.Repo
    
    def start_link do 
        Supervisor.start_link(__MODULE__, [])
    end
    
    def init([]) do 
        children = [ 
            worker(DistStore, []),
            worker(Repo, []),
            worker(AppClient, [])
        ]
        
        supervise(children, strategy: :one_for_one)
    end
end