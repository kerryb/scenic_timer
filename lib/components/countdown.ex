defmodule ScenicTimer.Countdown do
  use Scenic.Component
  import Scenic.Primitives, only: [text: 2, text: 3]
  alias Scenic.Graph

  @graph Graph.build()
         |> text("",
           id: :text,
           font_size: 100,
           text_align: :center_middle
         )

  def info(data), do: "Data must be an integer, but got #{inspect(data)}"

  def verify(initial_seconds) when is_integer(initial_seconds), do: {:ok, initial_seconds}
  def verify(_), do: :invalid_data

  def init(initial_seconds, _opts) do
    graph =
      @graph
      |> Graph.modify(:text, &text(&1, to_string(initial_seconds)))

    state = %{
      graph: graph,
      initial_seconds: initial_seconds,
      seconds_remaining: initial_seconds,
      running: true
    }

    {:ok, state, push: graph}
  end

  def handle_cast(:tick, %{running: true} = state) do
    seconds_remaining = state.seconds_remaining - 1
    graph = state.graph |> Graph.modify(:text, &text(&1, to_string(seconds_remaining)))
    running = seconds_remaining > 0
    state = %{state | seconds_remaining: seconds_remaining, graph: graph, running: running}
    {:noreply, state, push: graph}
  end

  def handle_cast(:tick, state), do: {:noreply, state}
end
