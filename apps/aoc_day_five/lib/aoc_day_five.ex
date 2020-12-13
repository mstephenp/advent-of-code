defmodule AocDayFive do
  @input "input/boarding_passes.txt"

  def get_answer() do
    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(&seat_number(&1))
    |> Enum.sort(:desc)
    |> List.first()
  end

  def get_answer_part_two() do
    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(&seat_number(&1))
    |> Enum.sort()
    |> find_my_seat()
  end

  def find_my_seat(seats) do
    Enum.chunk_every(seats, 2, 1, :discard)
    |> Enum.filter(fn [a,b] -> b - a == 2 end)
  end

  def seat_number(boarding_pass) do
    row = get_row(boarding_pass)
    col = get_col(boarding_pass)
    seat_id = row * 8 + col

    seat_id
  end

  def get_row(boarding_pass) do
    {:ok, row} = Agent.start_link(fn -> {0, 127, ""} end)

    for c <- String.graphemes(boarding_pass) do
      if c == "F" do
        Agent.update(row, fn {x, y, _c} -> {x, floor((x + y) / 2), "F"} end)
      end

      if c == "B" do
        Agent.update(row, fn {x, y, _c} -> {round((x + y) / 2), y, "B"} end)
      end
    end

    final_letter = elem(Agent.get(row, fn a -> a end), 2)

    if final_letter == "F" do
      elem(Agent.get(row, fn a -> a end), 0)
    else
      elem(Agent.get(row, fn a -> a end), 1)
    end
  end

  def get_col(boarding_pass) do
    {:ok, col} = Agent.start_link(fn -> {0, 7, ""} end)

    for c <- String.graphemes(boarding_pass) do
      if c == "R" do
        Agent.update(col, fn {x, y, _c} -> {round((x + y) / 2), y, "R"} end)
      end

      if c == "L" do
        Agent.update(col, fn {x, y, _c} -> {x, floor((x + y) / 2), "L"} end)
      end
    end

    final_letter = elem(Agent.get(col, fn a -> a end), 2)

    if final_letter == "L" do
      elem(Agent.get(col, fn a -> a end), 0)
    else
      elem(Agent.get(col, fn a -> a end), 1)
    end
  end
end
