defmodule MotivusWbApi.ListenerMatches do
  use GenServer
  alias Phoenix.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_) do
    {:ok, {Phoenix.PubSub.subscribe(MotivusWbApi.PubSub, "matches")}}
     |> IO.inspect(label: "subscribed to matches PubSub")
  end

  # Callbacks

  def handle_info({_topic, _name, data}, state) do
    MotivusWbApi.Scheduler.match()
    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch!(state, key), state}
  end
end
