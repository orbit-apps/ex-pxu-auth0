defmodule PxUAuth0.AuthRouter do
  use Plug.Router
  use Plug.ErrorHandler

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias PxUAuth0.UserFromAuth

  get "/logout" do
    IO.puts("here")

    conn
#|> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> send_resp(301, "test")
  end

  if Mix.env() == :dev do
  match "/:provider/callback", assigns: %{ueberauth_auth: "_"} do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        IO.inspect(user, label: :in_dev_success)
        conn
#|> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        |> send_resp(301, "test")

      {:error, reason} ->
        IO.inspect(reason, label: :in_dev_fail)
        conn
        |> put_flash(:error, reason)
        |> send_resp(301, "test")
    end
  end
  end

  match "/:provider/callback", assigns: %{ueberauth_failure: "_"} do
    IO.inspect("in callback failed clause")
    conn
#|> put_flash(:error, "Failed to authenticate.")
    |> send_resp(301, "test")
  end

  match "/:provider/callback", assigns: %{ueberauth_auth: "_"} do
    case UserFromAuth.find_or_create(conn.assigns.auth) do
      {:ok, user} ->
        IO.inspect(user, label: :call_back_user_success)
        conn
#|> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        |> send_resp(301, "test")

      {:error, reason} ->
        IO.inspect(reason, label: :in_callback_error)
        conn
#|> put_flash(:error, reason)
        |> send_resp(301, "test")
    end
  end

  get "/:provider/request" do
    conn
    |> send_resp(200, "ok")
#render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end
end

