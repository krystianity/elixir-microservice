defmodule CFM.EctoWrapper do 
    import Ecto.Query
    
    alias CFM.Repo
    alias CFM.SampleDto
    
    def keyword_query do
        query = from w in SampleDto,
        where: w.id > 0 or is_nil(w.bla),
        select: w
        res = Repo.all(query)
        IO.inspect res
        res
    end
    
    def pipe_query do 
        SampleDto
        |> where(id: 1)
        |> order_by(:id)
        |> limit(1)
        |> Repo.all
    end 
end