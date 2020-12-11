defmodule AocDayOne do
  @input "input/numbers.txt"

  def get_answer_part_one() do
    with file <- File.read!(@input),
         strs <- String.split(file, "\n"),
         nums <- Enum.map(strs, &elem(Integer.parse(&1), 0)),
         negs <- Enum.map(nums, &(2020 - &1)),
         pair <- Enum.filter(negs, &Enum.member?(nums, &1)) do
      Enum.reduce(pair, fn n, acc -> n * acc end)
    end
  end

  def get_answer_part_one_another_way() do
    numbers = File.read!(@input) |> String.split("\n") |> Enum.map(&String.to_integer/1)
    [{x,y} | _] = for i <- numbers, j <- numbers, i + j == 2020 do
      {i,j}
    end
    x * y
  end

  def get_answer_part_two() do
    numbers = File.read!(@input) |> String.split("\n") |> Enum.map(&String.to_integer/1)
    [{x,y,z} | _] = for i <- numbers, j <- numbers, k <- numbers, i + j + k == 2020 do
      {i,j,k}
    end
    x * y * z
  end
end
