defmodule PxUAuth0.UserHelpers do
  @moduledoc """
  Conveniences for Auth0 authentication.
  """

  @fallback_avatar "https://twemoji.maxcdn.com/2/72x72/1f913.png"

  def current_user(conn), do: conn.assigns[:current_user]

  def logged_in?(conn), do: Map.has_key?(conn.assigns, :current_user)

  def in_group?(conn, group_name),
    do: conn |> current_user() |> Map.get(:groups, []) |> Enum.member?(group_name)

  def user_avatar(conn) do
    case current_user(conn) do
      %{avatar: ""} -> @fallback_avatar
      %{avatar: avatar} -> avatar
    end
  end
end
