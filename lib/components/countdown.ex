defmodule ScenicTimer.Countdown do
  use Scenic.Component
  import Scenic.Primitives, only: [arc: 2, arc: 3, circle: 3, text: 2, text: 3]
  alias Scenic.Graph

  @graph Graph.build()
         |> text("",
           id: :text,
           font_size: 100,
           text_align: :center_middle
         )
         |> circle(100, stroke: {2, :grey})
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
      |> Graph.modify(
        :arc,
        &arc(&1, {100, 0, :math.pi() * 2 * seconds_remaining / state.initial_seconds})
      )

    # Avoid overrun from floating point inaccuracy
    running = seconds_remaining > 0.01
    state = %{state | seconds_remaining: seconds_remaining, graph: graph, running: running}
    {:noreply, state, push: graph}
  end

  def handle_cast(:tick, state), do: {:noreply, state}
end
