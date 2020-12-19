defmodule AocDayEight do

  @input "input/instructions.txt"

  def get_answer() do
    {:ok, index_tracker} = Agent.start_link(fn -> [] end)

    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [cmd, value] -> [cmd, String.to_integer(value)] end)
    |> Enum.with_index()
    |> Enum.map(fn {i, j} -> {j, i} end)
    |> Enum.into(%{})
    |> process(index_tracker)
  end

  def process(data, index \\ 0, acc \\ 0, agent) do
    if data[index] == nil do
      # IO.puts "past end index: #{index}"
      acc
    else
      # IO.puts "-> current index: #{index}"
      Agent.update(agent, fn c -> [index | c] end)
      [cmd, value] = data[index]

      case cmd do
        "nop" ->
          # process(data, index + 1, acc, agent)
          if agent_contains(agent, index + 1) do
            IO.puts "nop change, next: #{index + 1} now: #{index + value}"
            # acc
            process(data, index + value, acc, agent)
          else
            process(data, index + 1, acc, agent)
          end

        "acc" ->
          process(data, index + 1, acc + value, agent)

        "jmp" ->
          # process(data, index + value, acc, agent)
          if agent_contains(agent, index + value) do
            IO.puts "jmp change, next: #{index + value} now #{index + 1}"
            # acc
            process(data, index + 1, acc, agent)
          else
            process(data, index + value, acc, agent)
          end
      end
    end
  end

  def agent_contains(agent, index) do
    Enum.find(Agent.get(agent, fn c -> c end), fn n -> n == index end)
  end



end
