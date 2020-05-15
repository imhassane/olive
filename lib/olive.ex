defmodule Olive do

  @content  """
              fonction addition(entier a, entier b) faire
                retourne a + b
              fin fonction

              fonction plus_un(entier a) faire
                retourne a + 1
              fin fonction

              var a: entier = 15
              var b: entier = 12
              var r: entier = 0

              r = addition(a, b)
              r = plus_un(r)
            """

  def start(_) do
    @content
      |> Lexer.start
      |> Tokenizer.start
      |> Parser.start
  end
end
