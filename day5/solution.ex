defmodule BinaryBoarding do
  use Bitwise

  def part1 do
    IO.puts(find_seat() |> Enum.max())
  end

  def part2 do
    my_seat =
      find_seat()
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [n, m] -> m - n == 2 end)
      |> hd()
      |> hd()

    IO.inspect(my_seat + 1)
  end

  defp find_seat do
    Enum.reduce(get_values(), [], fn pass, acc ->
      pass_bin = Enum.map(pass, &char_to_bin/1)

      seat_id =
        pass_bin
        |> Enum.reverse()
        |> Enum.with_index()
        |> Enum.reduce(0, fn {bin, exp}, acc -> acc + bsl(bin, exp) end)

      acc ++ [seat_id]
    end)
  end

  defp char_to_bin(char) do
    case char do
      "B" -> 1
      "R" -> 1
      _ -> 0
    end
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)
        |> Enum.map(fn n ->
          String.graphemes(n)
        end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part1:")
BinaryBoarding.part1()
IO.puts("Part2:")
BinaryBoarding.part2()
