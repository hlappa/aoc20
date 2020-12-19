defmodule TobogganTrajectory do
  @part2_points [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

  def part1 do
    trees = calculate_trees(3, 1)

    IO.puts(trees)
  end

  def part2 do
    multiplied =
      Enum.reduce(@part2_points, 1, fn {right, down}, acc ->
        acc * calculate_trees(right, down)
      end)

    IO.puts(multiplied)
  end

  def calculate_trees(right, down) do
    rows = get_values()

    filtered_rows =
      Enum.zip(0..Enum.count(rows), rows)
      |> Enum.filter(fn {index, _} -> rem(index, down) == 0 end)

    {_, trees} =
      Enum.reduce(filtered_rows, {0, 0}, fn {_, row}, {pos, trees} ->
        tree = String.at(row, pos) == "#"
        trees = if tree, do: trees + 1, else: trees
        pos = rem(pos + right, String.length(row))

        {pos, trees}
      end)

    IO.puts(trees)

    trees
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

# IO.puts("Part1:")
# TobogganTrajectory.part1()
IO.puts("Part2:")
TobogganTrajectory.part2()
