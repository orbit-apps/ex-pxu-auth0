defmodule PxUAuth0.AccessToken do
  use Agent
  alias PxUAuth0.Auth0API

  @default_token_life 23 * 60 * 60 * 1000
  @moduledoc """
  The client application for Auth0. To use, your Ueberauth.Strategy.Auth0.OAuth config
  should be set up. The Auth0 client pulls it's config from there.

  The `token_life` config can be set in the `pxu_auth0` config.

  ```
  config :pxu_auth0, token_life: 10_000
  ``

  ## Usage

  ```
  iex(1)> PxUAuth0.AccessToken.start_link()
  iex(2)> PxUAuth0.fetch
  {:ok, nkkdaknwpiepoqiwe....
  ```
  """

  def start_link(initial_state \\ %{}) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  @doc """
  Get a cached Auth0 access token. If one does not exist in the cache it will be 
  fetched from the Auth0 api.
  """
  def fetch do
    case get() do
      nil ->
        Auth0API.create_token_request()
        |> Auth0API.fetch_token()
        |> store()

        fetch()

      token ->
        token
    end
  end

  def store(%{"access_token" => token}, date_time_impl \\ NaiveDateTime) do
    Agent.update(__MODULE__, fn state ->
      Map.merge(state, %{access_token: token, update_date: date_time_impl.utc_now()})
    end)
  end

  def get do
    with %{access_token: access_token, update_date: update_date} <- Agent.get(__MODULE__, & &1),
         expiry_time = Application.get_env(:pxu_auth0, :token_life, @default_token_life),
         true <-
           update_date
           |> NaiveDateTime.diff(NaiveDateTime.utc_now(), :millisecond)
           |> Kernel.<(expiry_time) do
      {:ok, access_token}
    else
      _ ->
        nil
    end
  end

  @doc """
    Clear access token cache.
  """
  def empty do
    Agent.update(__MODULE__, fn _state -> %{} end)
  end
end
