defmodule ReportRepair do
  @value_to_equal 2020

  def part1 do
    sorted_filtered = get_values() |> filter_list

    result =
      Enum.with_index(sorted_filtered)
      |> Enum.reduce_while(0, fn {x, index}, acc ->
        y = @value_to_equal - x

        case Enum.find_index(sorted_filtered, &(&1 == y)) do
          nil -> {:cont, acc}
          j -> {:halt, Enum.fetch!(sorted_filtered, j) * Enum.fetch!(sorted_filtered, index)}
        end
      end)

    IO.puts(result)
  end

  # Forgive me, it's 3am and I'm sleepy already
  # Don't code like this, come up with more neat solution than me
  def part2 do
    sorted_filtered = get_values() |> filter_list_for_second_part

    Enum.each(sorted_filtered, fn a ->
      Enum.each(sorted_filtered, fn b ->
        if a != b do
          Enum.each(sorted_filtered, fn c ->
            if b != c do
              if a + b + c === @value_to_equal do
                IO.puts(a * b * c)
                break
              end
            end
          end)
        end
      end)
    end)
  end

  defp filter_list_for_second_part(values_list) do
    largest_possible = @value_to_equal - Enum.fetch!(values_list, 0) - Enum.fetch!(values_list, 1)
    Enum.filter(values_list, fn x -> x <= largest_possible end)
  end

  defp filter_list(value_list) do
    largest_possible = @value_to_equal - hd(value_list)
    Enum.filter(value_list, fn x -> x <= largest_possible end)
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort()

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part1 answer:")
ReportRepair.part1()
IO.puts("Part2 answer:")
ReportRepair.part2()
