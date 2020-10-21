defmodule ScenicTimer.Countdown do
  use Scenic.Component

  import Scenic.Primitives, only: [arc: 2, arc: 3, circle: 3, text: 2, text: 3, update_opts: 2]

  alias Scenic.{Component, Graph, Scene}

  @graph Graph.build()
         |> circle(100, id: :circle, stroke: {2, :grey})
         |> text("",
           id: :text,
           font_size: 100,
           text_align: :center_middle
         )
         |> arc({100, 0, :math.pi() * 2}, id: :arc, stroke: {5, :white}, rotate: :math.pi() / -2)

  @impl Component
  def info(data), do: "Data must be an integer, but got #{inspect(data)}"

  @impl Component
  def verify(data) when is_integer(data), do: {:ok, data}
  def verify(_), do: :invalid_data

  @impl Scene
  def init(initial_seconds, _opts) do
    graph = Graph.modify(@graph, :text, &text(&1, to_string(initial_seconds)))
    {:ok, graph, push: graph}
  end

  def update(ms_remaining, initial_ms) do
    GenServer.cast(__MODULE__, {:update, ms_remaining, initial_ms})
  end

  @impl Scene
  def handle_cast({:update, ms_remaining, initial_ms}, graph) do
    graph =
      graph
      |> update_remaining(ms_remaining, initial_ms)
      |> turn_red_if_finished(ms_remaining)

    {:noreply, graph, push: graph}
  end

  defp remaining_arc(ms_remaining, initial_ms) do
    {100, 0, :math.pi() * 2 * ms_remaining / initial_ms}
  end

  defp update_remaining(graph, ms_remaining, initial_ms) do
    graph
    |> Graph.modify(:text, &text(&1, (ms_remaining / 1000) |> ceil() |> to_string()))
    |> Graph.modify(:arc, &arc(&1, remaining_arc(ms_remaining, initial_ms)))
  end

  defp turn_red_if_finished(graph, ms_remaining) when ms_remaining == 0 do
    Graph.modify(graph, :circle, &update_opts(&1, fill: :red))
  end

  defp turn_red_if_finished(graph, _ms_remaining) do
    Graph.modify(graph, :circle, &update_opts(&1, fill: :clear))
  end
end
