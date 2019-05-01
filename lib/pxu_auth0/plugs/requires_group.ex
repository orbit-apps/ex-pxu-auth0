defmodule PxUAuth0.Plugs.RequiresGroup do
  import Plug.Conn

  alias PxUAuth0.UserHelpers

  def init(config), do: config

  def call(conn, opts) do
    with true <- UserHelpers.logged_in?(conn),
         true <- UserHelpers.in_group?(conn, Keyword.get(opts, :group)) do
      conn
    else
      _ ->
        conn
        |> resp(401, "Not Authorized.")
        |> halt()
    end
  end
end
