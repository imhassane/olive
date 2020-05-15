defmodule Tokenizer.Functions do

  def make_params(tokens) when is_list(tokens) do
    make(tokens)
  end
  def make_params(_), do: []

  def make_func_call(tokens) when is_list(tokens) do
    make_call(tokens)
  end
  def make_func_call(_), do: %{}

  defp make(tokens) when is_list(tokens) do
    if (Kernel.length tokens) < 4, do: %{ t: :error, message: "La définition de la fonction est incorrecte"}
    [name | tail] = tokens
    params = make_args(tail)
    %{ t: :function_definition, name: String.to_atom(name), params: params}
  end

  defp make_args(args) do
    if (Kernel.length args) == 3 do
     [%{}]
    else
      args
        |> Enum.filter(fn(x) -> x != "(" and x != ")" and x != "faire" end)
        |> get_args
    end
  end

  defp get_args(args) do
    case args do
      [type | r] ->
        [name | tail] = r
        [%{ t: :param_declaration, name: String.to_atom(name), type: String.to_atom(type) }] ++ get_args(tail)
      _ -> []
    end
  end

  defp make_call(tokens) do
    case tokens do
      [name | tail] ->
        %{
          t: :func_arguments,
          name: String.to_atom(name),
          args: make_func_call_args(tail)
        }
      _ -> %{}
    end
  end

  defp make_func_call_args(tokens) do
    case tokens do
      [head | tail] ->
        case head do
          "(" -> make_func_call_args(tail)
          ")" -> []
          _   ->
            expr = Tokenizer.Expression.make([head])
            [expr] ++ make_func_call_args(tail)
        end
      _ -> []
    end
  end

end