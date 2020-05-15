defmodule Tokenizer.Variables do

  def make(tokens) when is_list(tokens) do
    build(tokens)
  end
  def make(_), do: %{}

  def build(tokens) do
    case tokens do
      [name | tail] ->
        [_    | tail]    = tail
        [type | tail]    = tail
        [_    | tail]    = tail

        %{
          t: :variable_definition,
          name:   String.to_atom(name),
          type:   String.to_atom(type),
          value:  Tokenizer.Expression.make(tail)
        }
      _ -> %{}
    end
  end

end