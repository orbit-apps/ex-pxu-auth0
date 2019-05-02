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
  $ iex -S mix
  iex(1)> PxUAuth0.AccessToken.fetch
  {:ok, nkkdaknwpiepoqiwe....
  ```
  """

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Get a cached Auth0 access token. If one does not exist in the cache it will be 
  fetched from the Auth0 api.
  """
  def fetch do
    with nil <- get(),
         :ok <- fetch_new_token() |> store() do
      fetch()
    else
      {:error, error} ->
        {:error, error}

      access_token ->
        {:ok, access_token}
    end
  end

  def store(access_token, date_time_impl \\ NaiveDateTime)

  def store({:error, _err} = error, _date_time_impl), do: error

  def store(token, date_time_impl) do
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
      access_token
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

  defp fetch_new_token do
    case Auth0API.create_token_request() |> Auth0API.fetch_token() do
      {:ok, %{body: %{"access_token" => token}}} ->
        token

      {:ok, %{body: {:error, %Jason.DecodeError{} = error}}} ->
        {:error, error}

      {:ok, %{body: error}} ->
        {:error, error}

      {:error, error} ->
        {:error, error}
    end
  end
end
