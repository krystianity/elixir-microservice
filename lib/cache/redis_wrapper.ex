defmodule CFM.RedisWrapper do 

    alias CFM.DistStore
    
    def start_link(p_host, p_port) do
        IO.puts "Connecting to redis on " <> p_host <> ":" <> to_string(p_port)
        {:ok, conn} = Redix.start_link(host: p_host, port: p_port)
        DistStore.set("redix_conn", conn)
        {:ok, conn}
    end
    
    def set(key, value) do
        {:ok, conn} = DistStore.get("redix_conn")
        res = Redix.command(conn, [ "SET", key, value ])
        IO.inspect res
        res
    end
    
    def get(key) do
        {:ok, conn} = DistStore.get("redix_conn")
        Redix.command(conn, ["GET", key])
    end
end