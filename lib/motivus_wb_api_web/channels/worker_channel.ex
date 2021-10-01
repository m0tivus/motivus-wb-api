defmodule MotivusWbApiWeb.WorkerChannel do
  use Phoenix.Channel
  alias Phoenix.PubSub

  def join("room:worker:" <> channel_id, _message, socket) do
    PubSub.broadcast(
      MotivusWbApi.PubSub,
      "nodes",
      {"new_channel", :unused, %{channel_id: channel_id}}
    )

    {:ok, socket}
  end

  def join("room:private", _message, socket), do: {:ok, socket}

  def join("room:" <> _private_room_id, _params, _socket), do: {:error, %{reason: "unauthorized"}}

  def handle_in("result", %{"body" => body, "tid" => tid}, socket) do
    [_, channel_id] = socket.topic |> String.split("room:worker:")

    PubSub.broadcast(
      MotivusWbApi.PubSub,
      "completed",
      {"task_completed", :unused,
       %{
         body: body,
         channel_id: channel_id,
         tid: tid
       }}
    )

    {:noreply, socket}
  end

  def handle_in("input_request", %{"tid" => tid}, socket) do
    [_, channel_id] = socket.topic |> String.split("room:worker:")

    PubSub.broadcast(
      MotivusWbApi.PubSub,
      "nodes",
      {"new_task_slot", :unused, %{channel_id: channel_id, tid: tid}}
    )

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    [_, channel_id] = socket.topic |> String.split("room:worker:")

    PubSub.broadcast(
      MotivusWbApi.PubSub,
      "nodes",
      {"dead_channel", :unused, %{channel_id: channel_id, join_ref: socket.join_ref}}
    )
  end
end
