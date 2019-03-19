defmodule PresenceWeb.VoteChannel do
  use PresenceWeb, :channel
  alias PresenceWeb.Presence

  def join("vote:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("vote", payload, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.user_id, %{
      vote: payload["vote"]
    })
    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{})
    {:noreply, socket}
  end
end
