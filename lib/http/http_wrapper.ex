defmodule CFM.HttpWrapper do 
    
    def start do
        HTTPoison.start
    end
     
    def get(url) do 
        response = HTTPoison.get! url
        IO.inspect response
        response
    end 
end