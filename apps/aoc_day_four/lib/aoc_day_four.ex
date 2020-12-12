defmodule AocDayFour do
  @input "input/passports.txt"

  def get_answer() do
    File.read!(@input)
    |> String.split("\n\n")
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(&String.split/1)
    |> Enum.map(&process_passport_data/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.filter(&is_valid/1)
  end

  def process_passport_data(data_line) do
    {:ok, passport} = Agent.start_link(fn -> %Passport{} end)

    for data <- data_line do
      case String.split(data, ":") do
        ["byr", val] ->
          v = String.to_integer(val)

          if v >= 1920 && v <= 2002 do
            Agent.update(passport, &%{&1 | byr: v})
          end

        ["iyr", val] ->
          v = String.to_integer(val)

          if v >= 2010 && v <= 2020 do
            Agent.update(passport, fn p -> %{p | iyr: val} end)
          end

        ["eyr", val] ->
          v = String.to_integer(val)

          if v >= 2020 && v <= 2030 do
            Agent.update(passport, fn p -> %{p | eyr: v} end)
          end

        ["hgt", val] ->
          r = ~r/\d*(cm|in)/

          if val =~ r do
            if String.contains?(val, "cm") do
              [v, _] = String.split(val, "cm")

              iv = String.to_integer(v)

              if iv >= 105 && iv <= 193 do
                Agent.update(passport, fn p -> %{p | hgt: v} end)
              end
            else
              [v, _] = String.split(val, "in")

              iv = String.to_integer(v)

              if iv >= 59 && iv <= 76 do
                Agent.update(passport, fn p -> %{p | hgt: v} end)
              end
            end
          end

        ["hcl", val] ->
          r = ~r/[#]\w{6}/

          if val =~ r do
            Agent.update(passport, fn p -> %{p | hcl: val} end)
          end

        ["ecl", val] ->
          if val in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] do
            Agent.update(passport, fn p -> %{p | ecl: val} end)
          end

        ["pid", val] ->
          r = ~r/(?<!\d)\d{9}(?!\d)/

          if val =~ r do
            Agent.update(passport, fn p -> %{p | pid: val} end)
          end

        _ ->
          Agent.get(passport, fn p -> p end)
      end

      passport
    end
  end

  def is_valid([passport]) do
    p = Agent.get(passport, fn p -> p end)
    p.byr && p.iyr && p.eyr && p.hgt && p.hcl && p.ecl && p.pid && true
  end
end
