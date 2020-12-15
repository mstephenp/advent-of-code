defmodule AocDaySix do

  @input "input/customs_answers.txt"

  def get_answer() do
    File.read!(@input)
    |> String.split("\n\n")
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&length/1)\
    |> Enum.sum()
  end

  def get_answer_part_two() do
    File.read!(@input)
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(&Enum.map(&1, fn n -> String.graphemes(n) end ))
    |> Enum.map(&process_lines/1)
    |> Enum.sum()

  end

  def process_lines(lines) do
    {:ok, agent} =
      Agent.start_link(
        fn -> List.first(Enum.sort(lines, &(length(&1) < length(&2)))) end)

    for line <- lines do
      agent_line = Agent.get(agent, fn line -> line end)
      for diff <- agent_line -- line do
        Agent.update(agent, fn line -> List.delete(line, diff) end)
      end
    end
    length(Agent.get(agent, fn line -> line end))
  end
end
