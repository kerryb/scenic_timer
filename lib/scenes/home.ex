defmodule ScenicTimer.Scene.Home do
  use Scenic.Scene

  import Scenic.Components, only: [button: 3]
  import Scenic.Primitives, only: [update_opts: 2]

  alias Scenic.{Graph, ViewPort}
  alias ScenicTimer.Countdown

  @impl Scenic.Scene
  def init(_args, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      Graph.build()
      |> Countdown.add_to_graph(5, name: Countdown, translate: {width / 2, height / 2})
      |> button("Start", id: :start, translate: {width / 2 - 100, height - 100})
      |> button("Stop", id: :stop, translate: {width / 2 - 100, height - 100}, hidden: true)

    {:ok, graph, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :start}, _from, graph) do
    graph = Graph.modify(graph, :start, &update_opts(&1, hidden: true))
    graph = Graph.modify(graph, :stop, &update_opts(&1, hidden: false))
    Countdown.start()
    {:halt, graph, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :stop}, _from, graph) do
    graph = Graph.modify(graph, :start, &update_opts(&1, hidden: false))
    graph = Graph.modify(graph, :stop, &update_opts(&1, hidden: true))
    Countdown.stop()
    {:halt, graph, push: graph}
  end
end
