defmodule ScenicTimer.Scene.Home do
  use Scenic.Scene

  alias Scenic.{Graph,ViewPort}
  alias ScenicTimer.Countdown

  def init(_args, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      Graph.build()
      |> Countdown.add_to_graph(5, name: Countdown, translate: {width / 2, height / 2})

    {:ok, graph, push: graph}
  end
end
