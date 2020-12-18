defmodule PasswordPhilosophy do
  use Bitwise

  def part1 do
    rows = get_values()

    valid_count =
      Enum.reduce(rows, 0, fn row, acc ->
        {pw, letter, least, max} = get_string_parts(row)

        if(valid?(pw, letter, least, max)) do
          acc + 1
        else
          acc
        end
      end)

    IO.puts(valid_count)
  end

  def part2 do
    rows = get_values()

    valid_count =
      Enum.reduce(rows, 0, fn row, acc ->
        {pw, letter, pos0, pos1} = get_string_parts(row)

        char0 = Enum.fetch!(pw, pos0 - 1)
        char1 = Enum.fetch!(pw, pos1 - 1)

        bit0 = if char0 == letter, do: 1, else: 0
        bit1 = if char1 == letter, do: 1, else: 0

        bit_result = bit0 ^^^ bit1

        if(bit_result === 1) do
          acc + 1
        else
          acc
        end
      end)

    IO.puts(valid_count)
  end

  defp valid?(pw, letter, times_least, times_max) do
    count =
      Enum.reduce(pw, 0, fn char, acc ->
        if char == letter, do: acc + 1, else: acc
      end)

    if(count <= times_max && count >= times_least) do
      true
    else
      false
    end
  end

  defp get_string_parts(row) do
    split = String.split(row, " ")

    {least, max} = parse_numbers(Enum.fetch!(split, 0))
    letter = String.trim(Enum.fetch!(split, 1), ":")
    pw = Enum.fetch!(split, 2) |> String.graphemes()

    {pw, letter, least, max}
  end

  defp parse_numbers(range) do
    split = String.split(range, "-")

    least = Enum.fetch!(split, 0) |> String.to_integer()
    max = Enum.fetch!(split, 1) |> String.to_integer()

    {least, max}
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part one:")
PasswordPhilosophy.part1()
IO.puts("Part two:")
PasswordPhilosophy.part2()
