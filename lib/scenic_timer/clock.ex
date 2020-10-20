defmodule ScenicTimer.Clock do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(_args) do
    Process.send_after(self(), :tick, :timer.seconds(1))
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, :timer.seconds(1))
    GenServer.cast(ScenicTimer.Countdown, :tick)
    {:noreply, state}
  end
end
