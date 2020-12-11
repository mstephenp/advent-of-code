defmodule AocDayTwo do
  @input "input/passwords.txt"

  def get_answer() do
    rules_and_passwords = get_data()

    results =
      for [rule, pass] <- rules_and_passwords do
        process(rule, pass)
      end

    valid = Enum.filter(results, fn r -> r end)
    length(valid)
  end

  def get_answer_part_two() do
    rules_and_passwords = get_data()

    results =
      for [rule, pass] <- rules_and_passwords do
        process_part_two(rule, pass)
      end

    valid = Enum.filter(results, & &1)
    length(valid)
  end

  def process(rule, pass) do
    [count_str, letter] = String.split(rule)
    [count_min, count_max] = String.split(count_str, "-")
    {min, max} = {String.to_integer(count_min), String.to_integer(count_max)}

    if String.contains?(pass, letter) do
      letter_counts = count_letters_in_word(pass)
      count = letter_counts[letter] || 0
      count >= min && count <= max
    else
      false
    end
  end

  def process_part_two(rule, pass) do
    [count_str, letter] = String.split(rule)
    [first_pos, second_pos] = String.split(count_str, "-")
    {fpos, spos} = {String.to_integer(first_pos) - 1, String.to_integer(second_pos) - 1}

    if String.contains?(pass, letter) do
      letter_pos = get_letter_pos(pass)
      is_first = letter_pos[fpos] == letter
      is_second = letter_pos[spos] == letter
      IO.inspect({letter, pass, fpos, is_first, spos, is_second})
      (is_first || is_second) && !(is_first && is_second)
    end
  end

  def get_data() do
    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn sl -> Enum.map(sl, &String.trim/1) end)
  end

  def count_letters_in_word(word) do
    String.graphemes(word)
    |> Enum.reduce(%{}, fn char, acc -> Map.put(acc, char, (acc[char] || 0) + 1) end)
  end

  def get_letter_pos(word) do
    String.graphemes(word) |> Enum.with_index() |> into_map()
  end

  def into_map(list) do
    Enum.into(
      for {i, j} <- list do
        {j, i}
      end,
      %{}
    )
  end
end
