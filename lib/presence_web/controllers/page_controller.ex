defmodule PresenceWeb.PageController do
  use PresenceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
