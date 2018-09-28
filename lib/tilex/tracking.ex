defmodule Tilex.Tracking do
  alias Tilex.Repo
  alias TilexWeb.Endpoint

  def track(conn) do
    spawn(fn ->
      if Application.get_env(:tilex, :request_tracking, false) do
        with [referer | _] <- Plug.Conn.get_req_header(conn, "referer") do
          page = String.replace(referer, Endpoint.static_url(), "")
          Ecto.Adapters.SQL.query!(Repo, "insert into requests (page) values ($1);", [page])
        end
      end
    end)
  end
end
