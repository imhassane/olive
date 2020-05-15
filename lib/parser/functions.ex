defmodule Parser.Functions do

  defstruct [name: nil, scope: %{name: :function}, variables: %{}, body: [], return: nil]

  alias Parser.{Functions, Variables}

  def set_params(%Functions{} = function, params) do
    make_variables(function, params)
  end

  defp make_variables(%Functions{} = func, params) do
    case params do
      [%{name: name, type: type} | tail] ->
        func = %Functions{ func | variables: Map.put(func.variables, name, %Variables{name: name, type: type, value: nil})}
      _ -> nil
    end
    func
  end

end