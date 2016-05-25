defmodule CFM.DistStore do
    use GenServer
  
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :dist_store)
  end

  def get(key) when is_bitstring(key) do
    GenServer.call(:dist_store, {:lookup, key})
  end
  
  def set(key, value) when is_bitstring(key) do
    GenServer.cast(:dist_store, {:create, key, value})
  end
  
  def all do
    GenServer.call(:dist_store, {:all})
  end
  
  def init do
    {:ok, %{}}
  end

  def handle_call({:lookup, key}, _from, stored) do
    {:reply, Map.fetch(stored, key), stored}
  end

  def handle_cast({:create, key, value}, stored) do
    if Map.has_key?(stored, key) do
      IO.puts "DistStore overwriting existing key " <> key
    else
      IO.puts "DistStore storing new key " <> key
    end
      stored = Map.put(stored, key, value)
      {:noreply, stored}
  end
  
  def handle_call({:all}, _from, stored) do
    {:reply, stored, stored}
  end
end