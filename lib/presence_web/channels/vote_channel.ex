defmodule PresenceWeb.VoteChannel do
  use PresenceWeb, :channel
  alias PresenceWeb.Presence

  def join("vote:lobby", _payload, _socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (vote:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, "voters", %{
      online_at: inspect(System.system_time(:second))
    })
    {:noreply, socket}
  end
end
