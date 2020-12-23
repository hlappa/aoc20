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

  def part2 do
    count = Enum.reduce(get_values(), 0, fn str, acc ->
      people_count = str |> String.split(" ") |> Enum.count()
      answered_questions_count = str |> String.replace(" ", "") |> String.graphemes() |> Enum.frequencies() |> :maps.values()

      if people_count == 1 do
        acc + String.length(str)
      else
        multi_answer = Enum.reduce(answered_questions_count, 0, fn q_count, acc ->
          if q_count/people_count == 1, do: acc + 1, else: acc
        end)
        acc + multi_answer
      end
    end)

    IO.puts(count)
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n\n", trim: true)
        |> Enum.map(fn str -> String.replace(str, "\n", " ") |> String.trim_trailing(" ") end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part1:")
CustomCustoms.part1()
IO.puts("Part2:")
CustomCustoms.part2()
