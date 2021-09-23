defmodule MotivusWbApi.ListenerCompleted do
  use GenServer
  alias Phoenix.PubSub
  import Ecto.Changeset
  alias MotivusWbApi.Repo
  alias MotivusWbApi.Users
  alias MotivusWbApi.Processing.Task
  alias MotivusWbApi.Stats

  def start_link(_) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_) do
    {:ok, {Phoenix.PubSub.subscribe(MotivusWbApi.PubSub, "completed")}}
    |> IO.inspect(label: "Subscribed to completed PubSub")
  end

  # Callbacks

  def handle_info(
        {"task_completed", _name,
         %{
           body: body,
           type: type,
           ref: ref,
           client_id: client_id,
           channel_id: channel_id,
           task_id: task_id,
           tid: tid
         }},
        state
      ) do
    IO.inspect(label: "new completed")
    [user_uuid, _] = channel_id |> String.split(":")

    user = Repo.get_by!(Users.User, uuid: user_uuid)

    MotivusWbApi.QueueProcessing.drop(MotivusWbApi.QueueProcessing, channel_id, tid)

    result = body
    # result = %{time: Enum.at(body,0), flops: Enum.at(body,1), rvs: Enum.at(body,2)}
    Repo.get_by(Task, id: task_id, user_id: user.id)
    |> change(%{date_out: DateTime.truncate(DateTime.utc_now(), :second), result: result})
    |> Repo.update()

    MotivusWbApiWeb.Endpoint.broadcast!(
      "room:client:" <> client_id,
      "result",
      %{uid: 1, body: body, type: "response", ref: ref, client_id: client_id, task_id: task_id}
    )

    current_season = Stats.get_current_season(DateTime.utc_now())

    MotivusWbApiWeb.Endpoint.broadcast!(
      "room:worker:" <> channel_id,
      "stats",
      %{uid: 1, body: Stats.get_user_stats(user.id, current_season), type: "stats"}
    )

    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch!(state, key), state}
  end
end
