defmodule Tokenizer.End do

  def make(tokens) do
    if (Kernel.length tokens) != 1 do
      %{t: :error, message: "La définition de la fin du bloc est incorrecte"}
    else
      [head | _] = tokens
      case head do
        "fonction" -> %{ t: :end_function }
        "fin si"   -> %{ t: :end_if }
      end
    end
  end

end