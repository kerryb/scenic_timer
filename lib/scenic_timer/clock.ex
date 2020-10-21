defmodule ScenicTimer.Clock do
  use GenServer

  alias ScenicTimer.Timer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(_args) do
    Process.send_after(self(), :tick, 10)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, 10)
    Timer.tick()
    {:noreply, state}
  end
end
