defmodule ScenicTimer.Countdown do
  use Scenic.Component
  import Scenic.Primitives, only: [text: 2, text: 3, update_opts: 2]
  alias Scenic.{Graph, ViewPort}

  @graph Graph.build()
         |> text("",
           id: :text,
           font_size: 100,
           text_align: :center_middle
         )

  def info(data), do: "Data must be an integer, but got #{inspect(data)}"

  def verify(initial_seconds) when is_integer(initial_seconds), do: {:ok, initial_seconds}
  def verify(_), do: :invalid_data

  def init(initial_seconds, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      @graph
      |> Graph.modify(:text, &text(&1, to_string(initial_seconds)))
      |> Graph.modify(:text, &update_opts(&1, translate: {width / 2, height / 2}))

    state = %{
      graph: graph,
      seconds_remaining: initial_seconds
    }

    {:ok, state, push: graph}
  end
end
