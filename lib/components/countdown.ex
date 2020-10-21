defmodule ScenicTimer.Countdown do
  use Scenic.Component
  import Scenic.Primitives, only: [arc: 2, arc: 3, circle: 3, text: 2, text: 3, update_opts: 2]
  alias Scenic.Graph

  @graph Graph.build()
         |> circle(100, id: :circle, stroke: {2, :grey})
         |> text("",
           id: :text,
           font_size: 100,
           text_align: :center_middle
         )
         |> arc({100, 0, :math.pi() * 2}, id: :arc, stroke: {5, :white}, rotate: :math.pi() / -2)

  def info(data), do: "Data must be an integer, but got #{inspect(data)}"

  def verify(initial_seconds) when is_integer(initial_seconds), do: {:ok, initial_seconds}
  def verify(_), do: :invalid_data

  def init(initial_seconds, _opts) do
    graph = Graph.modify(@graph, :text, &text(&1, to_string(initial_seconds)))

    state = %{
      graph: graph,
      initial_seconds: initial_seconds,
      seconds_remaining: initial_seconds,
      running: true
    }

    {:ok, state, push: graph}
  end

  def handle_cast(:tick, %{running: true} = state) do
    seconds_remaining = state.seconds_remaining - 0.1

    graph =
      state.graph
      |> Graph.modify(:text, &text(&1, seconds_remaining |> round() |> to_string()))
      |> Graph.modify(:arc, &arc(&1, remaining_arc(seconds_remaining, state.initial_seconds)))
      |> turn_red_if_finished(seconds_remaining)

    # Avoid overrun from floating point inaccuracy
    running = seconds_remaining > 0.01
    state = %{state | seconds_remaining: seconds_remaining, graph: graph, running: running}
    {:noreply, state, push: graph}
  end

  def handle_cast(:tick, state), do: {:noreply, state}

  defp remaining_arc(seconds_remaining, initial_seconds) do
    {100, 0, :math.pi() * 2 * seconds_remaining / initial_seconds}
  end

  defp turn_red_if_finished(graph, seconds_remaining) when seconds_remaining < 0.01 do
    Graph.modify(graph, :circle, &update_opts(&1, fill: :red))
  end

  defp turn_red_if_finished(graph, _seconds_remaining), do: graph
end
