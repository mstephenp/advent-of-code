defmodule AocDaySeven do
  @input "input/colorful_bags_short.txt"
  @shiny_gold "shiny gold bag"

  def get_answer() do
    {:ok, bag_collector} = Agent.start_link(fn -> [] end)

    read_data(@input) |> count(bag_collector, @shiny_gold)

    length(Enum.uniq(Agent.get(bag_collector, & &1)))
  end

  def get_answer_part_two() do
    {:ok, _agent} = Agent.start_link(fn -> [] end)

    read_data(@input)
    |> Enum.map(fn {bag_name, bags} ->
      {String.trim_trailing(bag_name, " bags"), Enum.map(bags, &String.split(&1))}
    end)
    |> Enum.map(fn {bag_name, bags} ->
      {bag_name,
       Enum.map(
         bags,
         fn [count | name] ->
           {String.trim_trailing(Enum.join(name, " "), " bags")
            |> String.trim_trailing(" bags.")
            |> String.trim_trailing(" bag")
            |> String.trim_trailing(" bag."), count}
         end
       )}
    end)
    |> Enum.map(fn {bag, bags} -> {bag, Enum.into(bags, %{})} end)
    |> Enum.into(%{})

    # |> get_counts()
    # |> count_total("shiny gold", 1)
    # |> List.flatten()
    # |> Enum.sum()
  end

  def get_counts(bag_data) do
    for {bag_name, bags} = _bag <- bag_data do
      for bag <- bags do
        {bag_name, count_bag(bag, 0)}
      end
    end
  end

  def count_bag({name, count} = bag, acc) do
    if name == "other" do
      acc + 1
    else
      (acc + 1) * String.to_integer(count)
    end
  end

  def read_data(input) do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [bag_name | bags] -> {bag_name, String.split(List.to_string(bags), ",")} end)
  end

  def count(bags, agent, bag_name) do
    if !String.contains?(bag_name, @shiny_gold) do
      Agent.update(agent, &[bag_name | &1])
    end

    for {bag, contains} <- bags,
        bag != bag_name,
        c <- contains,
        String.contains?(c, String.trim_trailing(bag_name, " bags")) do
      count(bags, agent, bag)
    end
  end
end
