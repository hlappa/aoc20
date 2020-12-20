defmodule CustomCustoms do
  def part1 do
    sum =
      get_values()
      |> Enum.map(fn str -> String.replace(str, " ", "") |> String.graphemes() |> Enum.uniq() end)
      |> Enum.reduce(0, fn str, acc ->
        acc + length(str)
      end)

    IO.inspect(sum)
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n\n", trim: true)
        |> Enum.map(fn question -> String.replace(question, "\n", " ") end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part1:")
CustomCustoms.part1()
