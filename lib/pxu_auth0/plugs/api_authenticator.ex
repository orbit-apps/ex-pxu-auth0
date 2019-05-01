defmodule PxUAuth0.Plugs.APIAuthenticator do
  import Plug.Conn

  alias PxUAuth0.APIToken

  def init(config), do: config

  def call(conn, _) do
    case verify_jwt(conn) do
      {:ok, claims} ->
        conn
        |> assign(:jwt_claims, claims)

      _res ->
        conn
        |> resp(401, "{\"Error\": \"Not Authorized\"}")
        |> halt()
    end
  end

  defp verify_jwt(conn),
    do: conn |> fetch_token() |> APIToken.verify_and_validate(APIToken.signer())

  defp fetch_token(conn) do
    conn
    |> get_req_header("authentication")
    |> List.first()
    |> String.split(" ")
    |> List.last()
  end
end
