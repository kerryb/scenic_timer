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
    initial_ms = initial_seconds * 1000
    graph = Graph.modify(@graph, :text, &text(&1, to_string(initial_seconds)))

    state = %{
      graph: graph,
      initial_ms: initial_ms,
      ms_remaining: initial_ms,
      running: false
    }

    {:ok, state, push: graph}
  end

  def start, do: GenServer.cast(__MODULE__, :start)
  def tick, do: GenServer.cast(__MODULE__, :tick)

  def handle_cast(:start, state) do
    {:noreply, %{state | running: true}}
  end

  def handle_cast(:tick, %{running: true} = state) do
    ms_remaining = state.ms_remaining - 100

    graph =
      state.graph
      |> Graph.modify(:text, &text(&1, (ms_remaining / 1000) |> ceil() |> to_string()))
      |> Graph.modify(:arc, &arc(&1, remaining_arc(ms_remaining, state.initial_ms)))
      |> turn_red_if_finished(ms_remaining)

    running = ms_remaining > 0
    state = %{state | ms_remaining: ms_remaining, graph: graph, running: running}
    {:noreply, state, push: graph}
  end

  def handle_cast(:tick, state), do: {:noreply, state}

  defp remaining_arc(ms_remaining, initial_ms) do
    {100, 0, :math.pi() * 2 * ms_remaining / initial_ms}
  end

  defp turn_red_if_finished(graph, ms_remaining) when ms_remaining == 0 do
    Graph.modify(graph, :circle, &update_opts(&1, fill: :red))
  end

  defp turn_red_if_finished(graph, _ms_remaining), do: graph
end
