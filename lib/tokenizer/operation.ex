defmodule Tokenizer.Operation do

  def make(left, op, right) do
    build(left, op, right)
  end

  defp build(left, "+", right) do
    %{ t: :operation, operation: :addition, left: left, right: right }
  end

  defp build(left, "-", right) do
    %{ t: :operation, operation: :soustraction, left: left, right: right }
  end

  defp build(left, "*", right) do
    %{ t: :operation, operation: :multiplication, left: left, right: right }
  end

  defp build(left, "/", right) do
    %{ t: :operation, operation: :division, left: left, right: right }
  end

  defp build(left, "**", right) do
    %{ t: :operation, operation: :power, left: left, right: right }
  end

  defp build(left, "%", right) do
    %{ t: :operation, operation: :modulo, left: left, right: right }
  end

  defp build(left, "=", right) do
    %{ t: :operation, operation: :equal, left: left, right: right }
  end

end