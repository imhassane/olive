defmodule Lexer do

  def start(content) when is_binary(content) do
    content
      |> String.split("\n")
      |> Enum.map(fn(x) -> String.trim(x) end)
      |> make_blocks
      |> Enum.filter(fn(x) -> Kernel.length(x) > 0 end)
  end

  defp make_blocks(content) when is_list(content) do
    case content do
      [head | tail] ->
        [make_blocks(head)] ++ make_blocks(tail)
      _ ->
        []
    end
  end

  defp make_blocks(content) when is_binary(content) do
    content = content |> String.graphemes
    content
      |> format_block
      |> String.split(" ")
      |> Enum.filter(fn(x) -> String.length(x) > 0 end)
  end

  defp format_block(block) when is_list(block) do
    # ['a', 'b', '(', 'd', ')'] => ['ab', '(', 'd', ')']
    case block do
      [head | tail] ->
        case head do
          "," ->          format_block(tail)
          ":" -> " : " <> format_block(tail)
          "(" -> " ( " <> format_block(tail)
          ")" -> " ) " <> format_block(tail)
          _   ->  head <> format_block(tail)
        end

      _ -> ""
    end
  end
end