defmodule PxUAuth0.Plugs.EnsureAuthenticated do
  import Plug.Conn
  alias Plug.HTML

  def init(opts), do: opts

  def call(conn, opts) do
    case get_session(conn, :current_user) do
      nil ->
        url = opts[:auth_path]
        body = "<html><body>You are being <a href=\"#{HTML.html_escape(url)}\">redirected</a>.</body></html>"

        conn
        |> put_session(:preauth_path, conn.request_path)
        |> delete_session(:preauth_path)
        |> put_resp_header("location", url)
        |> put_resp_header("content-type", "text/html")
        |> resp(302, body)
        |> halt()

      user ->
        conn
        |> assign(:current_user, user)
        |> maybe_redirect()
    end
  end

  defp maybe_redirect(conn) do
    case get_session(conn, :preauth_path) do
      nil ->
        conn

      redirect_path ->
        body = "<html><body>You are being <a href=\"#{HTML.html_escape(redirect_path)}\">redirected</a>.</body></html>"

        conn
        |> delete_session(:preauth_path)
        |> put_resp_header("location", redirect_path)
        |> put_resp_header("content-type", "text/html")
        |> resp(302, body)
        |> halt()
    end
  end
end
