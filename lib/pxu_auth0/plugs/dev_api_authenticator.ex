defmodule PxUAuth0.Plugs.DevAPIAuthenticator do
  import Plug.Conn

  def init(config), do: config

  def call(conn, _) do
    claims = %{
      "iss" => "Joken",
      "sub" => "rN6MgsqhuypTSzjGO5ZG7I8Q12XIOr6r@clients",
      "aud" => "Joken",
      "iat" => :os.system_time() - 100,
      "exp" => :os.system_time() + 36_000,
      "azp" => "rN6MgsqhuypTSzjGO5ZG7I8Q12XIOr6r",
      "scope" => "write:auth_tokens write:shops",
      "gty" => "client-credentials"
    }

    conn
    |> assign(:jwt_claims, claims)
  end
end
