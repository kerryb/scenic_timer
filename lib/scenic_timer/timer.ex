defmodule ScenicTimer.Timer do
  use GenServer

  alias ScenicTimer.Countdown

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl GenServer
  def init([initial_seconds]) do
    initial_ms = initial_seconds * 1000

    {:ok,
     %{
       initial_ms: initial_ms,
       ms_remaining: initial_ms,
       running: false
     }}
  end

  def start, do: GenServer.cast(__MODULE__, :start)
  def stop, do: GenServer.cast(__MODULE__, :stop)
  def reset, do: GenServer.cast(__MODULE__, :reset)
  def tick, do: GenServer.cast(__MODULE__, :tick)

  @impl GenServer
  def handle_cast(:start, state) do
    {:noreply, %{state | running: true}}
  end

  def handle_cast(:stop, state) do
    {:noreply, %{state | running: false}}
  end

  def handle_cast(:reset, state) do
    ms_remaining = state.initial_ms
    Countdown.update(ms_remaining, state.initial_ms)
    {:noreply, %{state | ms_remaining: ms_remaining, running: false}}
  end

  def handle_cast(:tick, %{running: true} = state) do
    ms_remaining = state.ms_remaining - 10
    running = ms_remaining > 0
    state = %{state | ms_remaining: ms_remaining, running: running}
    Countdown.update(ms_remaining, state.initial_ms)
    {:noreply, state}
  end

  def handle_cast(:tick, state), do: {:noreply, state}
end
