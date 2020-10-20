defmodule ScenicTimer.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph
  alias ScenicTimer.Countdown

  def init(_args, _opts) do
    graph =
      Graph.build()
      |> Countdown.add_to_graph(5)

    {:ok, graph, push: graph}
  end
end
