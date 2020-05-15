defmodule Tokenizer do

  alias Tokenizer.{Functions, End, Expression, Variables}

  def start(tokens) when is_list(tokens) do
    build(tokens)
  end
  def start(_), do: []

  defp build(tokens) when is_list(tokens) do
    case tokens do
      [head | tail] ->
        [transform(head)] ++ build(tail)
      _ -> []
    end
  end

  defp transform(tokens) when is_list(tokens) do
    case tokens do
      [head | tail] ->
        case head do
          "var"       -> Variables.make(tail)
          "fonction"  -> Functions.make_params(tail)
          "retourne"  -> Expression.make(tail)
          "fin"       -> End.make(tail)
          _           -> Expression.make([head] ++ tail)
        end
      _ -> %{}
    end
  end

end