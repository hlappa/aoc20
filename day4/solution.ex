defmodule PassportProcessing do
  @required ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
  @valid_eye_color ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  def part1 do
    valid_count =
      Enum.reduce(get_values(), 0, fn pp, acc ->
        fields_with_values = get_fields_and_values(pp)
        if validate_fields(fields_with_values), do: acc + 1, else: acc
      end)

    IO.puts(valid_count)
  end

  def part2 do
    valid_passports =
      Enum.reduce(get_values(), 0, fn pp, acc ->
        fields_with_values = get_fields_and_values(pp)
        if validate(fields_with_values), do: acc + 1, else: acc
      end)

    IO.puts(valid_passports)
  end

  defp validate(passport) do
    has_all_fields = validate_fields(passport)

    if !has_all_fields do
      false
    else
      passport_hash = enum_to_hash_map(passport)

      byr_valid = validate_between(passport_hash["byr"], 1920, 2002)
      iyr_valid = validate_between(passport_hash["iyr"], 2010, 2020)
      eyr_valid = validate_between(passport_hash["eyr"], 2020, 2030)
      hgt_valid = validate_height(passport_hash["hgt"])
      hcl_valid = validate_hair(passport_hash["hcl"])
      ecl_valid = validate_eye_color(passport_hash["ecl"])
      pid_valid = validate_passport_id(passport_hash["pid"])

      if byr_valid && iyr_valid && eyr_valid && hgt_valid && hcl_valid && ecl_valid && pid_valid,
        do: true,
        else: false
    end
  end

  defp validate_height(height) do
    if String.ends_with?(height, "cm") do
      String.trim_trailing(height, "cm") |> validate_between(150, 193)
    else
      String.trim_trailing(height, "in") |> validate_between(59, 76)
    end
  end

  defp validate_hair(hair_color) do
    String.match?(hair_color, ~r/^#[[:alnum:]]/) && String.length(hair_color) == 7
  end

  defp validate_eye_color(eye_color) do
    Enum.member?(@valid_eye_color, eye_color)
  end

  defp validate_passport_id(id) do
    String.match?(id, ~r/^[[:digit:]]/) && String.length(id) == 9
  end

  defp validate_between(value, min, max) do
    n = String.to_integer(value)
    n >= min && n <= max
  end

  defp validate_fields(fields) do
    list_of_fields = Enum.map(fields, fn item -> hd(item) end)

    case Enum.reject(@required, fn x ->
           Enum.member?(list_of_fields, x)
         end) do
      ["cid"] -> true
      [] -> true
      _ -> false
    end
  end

  defp enum_to_hash_map(enum) do
    Enum.reduce(enum, %{}, fn n, acc ->
      Map.put(acc, hd(n), List.last(n))
    end)
  end

  defp get_fields_and_values(passport) do
    String.split(passport, " ")
    |> Enum.map(fn key_value_pair -> String.split(key_value_pair, ":") end)
    |> Enum.filter(fn val -> length(val) == 2 end)
  end

  defp get_values do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n\n", trim: true)
        |> Enum.map(fn passport -> String.replace(passport, "\n", " ") end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part1:")
PassportProcessing.part1()
IO.puts("Part2:")
PassportProcessing.part2()
