defmodule CFM.SampleDto do 
    use Ecto.Schema
    
    schema "sample" do
        #field :id, :integer is always set by ecto
        field :bla, :string
        field :id_again, :integer
        field :blup, :float, default: 0.0
    end
end