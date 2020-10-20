defmodule ScenicTimer do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  alias ScenicTimer.Clock

  def start(_type, _args) do
    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:scenic_timer, :viewport)

    # start the application with the viewport
    children = [
      {Scenic, viewports: [main_viewport_config]},
      {Clock, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
