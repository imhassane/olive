defmodule Tokenizer.Expression do

  @variables  ~r/^[[:alpha:]]+$/

  def make(tokens) when is_list(tokens) do
    build(tokens)
  end
  def make(_), do: %{}

  defp build(tokens) do
    case tokens do
      [head | tail] ->
        is_function?      =
          case (Kernel.length tail) > 0 do
            true ->
              [p | _] = tail
              if p == "(" do
                true
              else
                false
              end
            false -> false
          end
        is_variable?      = (is_function? == false) and String.match?(head, @variables)
        is_only_variable? = is_variable?  and (Kernel.length tail) == 0
        is_only_number?   = (Kernel.length tail) == 0

        if is_only_variable? do
          %{ t: :expression, value: %{ t: :variable_call, name: String.to_atom(head) }}
        else
          if is_only_number? do
            value = convert_to_number(head)
            %{ t: :expression, value: %{ t: :value_call, value: value }}
          else
            if is_function? do
              Tokenizer.Functions.make_func_call([head] ++ tail)

            else
              # If it's not a number or a variable call it might be an operation such as 2 + 2 or age + 1.
              if (Kernel.length tail) < 2 do
                %{ t: :error, message: "The expression is not correct" }
              else
                [op | rest] = tail
                result = is_operation?(op)

                if result do
                  if is_variable? do
                    right = make(rest)
                    %{
                      t: :expression,
                      value: Tokenizer.Operation.make(
                        %{ t: :variable_call, name: String.to_atom(head) },
                        op,
                        right
                      )
                    }
                  else
                    value = convert_to_number(head)
                    right = make(rest)
                    %{t: :expression, value: Tokenizer.Operation.make(value, op, right)}
                  end
                else
                  %{t: :error, message: "The expression is not correct"}
                end
              end
            end
          end
        end
      _ -> %{}
    end
  end

  defp convert_to_number(value) do
    case String.contains?(value, ".") do
      true  -> String.to_float(value)
      false -> String.to_integer(value)
    end
  end

  defp is_operation?(op) do
    result = op == "+"
    result = result or op == "-"
    result = result or op == "*"
    result = result or op == "**"
    result = result or op == "="
    result or op == "/"
  end

end