defmodule Parser do

  alias Parser.{Variables, Functions}

  def start(instructions) do
    scope = %{name: :global, variables: %{}, functions: %{}}
    apply_all(instructions, scope, scope)
  end

  defp apply_all(instructions, scope, initial) do
    case instructions do
      [ins | tail] ->
        case ins.t do
          :variable_definition ->
            var   = %Variables{name: ins.name, type: ins.type, value: ins.value.value.value }
            scope = %{ scope | variables: Map.put(scope.variables, ins.name, var) }

            if scope.name == :global, do: initial = scope
            [var] ++ apply_all(tail, scope, initial)

          :function_definition ->
            func    = %Functions{name: ins.name, scope: scope}
            func    = Functions.set_params(func, ins.params)
            scope = %{ scope | functions: Map.put(scope.functions, ins.name, func) }

            [func] ++ apply_all(tail, func, scope)

          :end_function        ->
            apply_all(tail, initial, initial)

          _ ->
            apply_all(tail, initial, initial)
        end
      _ -> []
    end
  end


end