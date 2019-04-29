defmodule PxUAuth0.UserHelpers do
  @moduledoc """
  Conveniences for Auth0 authentication.
  """

  def current_user(conn), do: conn.assigns[:current_user]

  def logged_in?(conn), do: Map.has_key?(conn.assigns, :current_user)

  def in_group?(conn, group_name),
    do: conn |> current_user() |> Map.get(:groups, []) |> Enum.member?(group_name)
end
