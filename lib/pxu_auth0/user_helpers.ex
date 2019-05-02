defmodule PxUAuth0.UserHelpers do
  @moduledoc """
  Conveniences for Auth0 authentication.
  """

  @spec current_user(map) :: map | nil
  def current_user(conn), do: conn.assigns[:current_user]

  @spec logged_in?(map) :: boolean
  def logged_in?(conn), do: Map.has_key?(conn.assigns, :current_user)

  @doc """
  Checks if logged-in user belongs to a group or is in one of the groups passed in.

  iex> in_group?(conn, "some group")
  true

  iex> in_group(conn, ["group 1", "other group"])
  true
  """
  @spec in_group?(map, String.t() | list) :: boolean
  def in_group?(conn, group_name) when is_binary(group_name),
    do: conn |> current_user() |> Map.get(:groups, []) |> Enum.member?(group_name)

  def in_group?(conn, groups) when is_list(groups) do
    conn
    |> current_user()
    |> Map.get(:groups, [])
    |> Enum.any?(fn x -> Enum.member?(groups, x) end)
  end
end
