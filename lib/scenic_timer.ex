defmodule ScenicTimer do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  alias ScenicTimer.{Clock, Timer}

  def start(_type, _args) do
    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:scenic_timer, :viewport)

    # start the application with the viewport
    children = [
      {Scenic, viewports: [main_viewport_config]},
      {Timer, [Application.get_env(:scenic_timer, :initial_seconds)]},
      {Clock, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
