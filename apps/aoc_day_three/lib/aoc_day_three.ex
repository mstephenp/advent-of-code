defmodule AocDayThree do
  @input "input/trees.txt"

  def get_answer() do
    tree_map = create_map()
    take_path(tree_map, {1, 3})
  end

  def get_answer_part_two() do
    tree_map = create_map()

    [
      take_path(tree_map, {1, 1}),
      take_path(tree_map, {1 ,3}),
      take_path(tree_map, {1, 5}),
      take_path(tree_map, {1, 7}),
      take_path(tree_map, {2, 1})
    ]
    |> Enum.reduce(1, fn n, acc -> n * acc end)
  end

  def take_path(tree_map, route, x \\ 0, y \\ 0, count \\ 0)

  def take_path(tree_map, _, x, _y, count) when x >= map_size(tree_map) do
    count
  end

  def take_path(tree_map, {n, m}, x, y, count) do
    take_path(
      tree_map,
      {n, m},
      x + n,
      rem(y + m, map_size(tree_map[x])),
      if(is_tree(tree_map, x, y), do: count + 1, else: count)
    )
  end

  def is_tree(tree_map, x, y) do
    tree_map[x][y] != nil && tree_map[x][y] == "#"
  end

  def create_map() do
    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.map(fn l -> Enum.map(l, fn {x, y} -> {y, x} end) end)
    |> Enum.map(&Enum.into(&1, %{}))
    |> Enum.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> Enum.into(%{})
  end
end
