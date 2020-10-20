defmodule ScenicTimer.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives

  def init(_, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      Graph.build()
      |> add_specs_to_graph([
        text_spec("5",
          font_size: 100,
          text_align: :center_middle,
          translate: {width / 2, height / 2}
        )
      ])

    {:ok, graph, push: graph}
  end
end
