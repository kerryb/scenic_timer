defmodule ScenicTimer.Scene.Home do
  use Scenic.Scene

  import Scenic.Components, only: [button: 3]
  import Scenic.Primitives, only: [update_opts: 2]

  alias Scenic.{Graph, ViewPort}
  alias ScenicTimer.{Countdown, Timer}

  @impl Scenic.Scene
  def init([initial_seconds], opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      Graph.build()
      |> Countdown.add_to_graph(initial_seconds, name: Countdown, translate: {width / 2, height / 2})
      |> button("Start", id: :start, width: 100, translate: {width / 2 - 150, height - 100})
      |> button("Stop",
        id: :stop,
        width: 100,
        translate: {width / 2 - 150, height - 100},
        hidden: true
      )
      |> button("Reset",
        id: :reset,
        theme: :danger,
        width: 100,
        translate: {width / 2 + 50, height - 100}
      )

    {:ok, graph, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :start}, _from, graph) do
    graph = Graph.modify(graph, :start, &update_opts(&1, hidden: true))
    graph = Graph.modify(graph, :stop, &update_opts(&1, hidden: false))
    Timer.start()
    {:halt, graph, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :stop}, _from, graph) do
    graph = Graph.modify(graph, :start, &update_opts(&1, hidden: false))
    graph = Graph.modify(graph, :stop, &update_opts(&1, hidden: true))
    Timer.stop()
    {:halt, graph, push: graph}
  end

  @impl Scenic.Scene
  def filter_event({:click, :reset}, _from, graph) do
    graph = Graph.modify(graph, :start, &update_opts(&1, hidden: false))
    graph = Graph.modify(graph, :stop, &update_opts(&1, hidden: true))
    Timer.reset()
    {:halt, graph, push: graph}
  end
end
