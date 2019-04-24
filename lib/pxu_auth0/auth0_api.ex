defmodule PxUAuth0.Auth0API do
  use HTTPoison.Base
  alias Ueberauth.Strategy.Auth0.OAuth

  def fetch_token(request_body),
    do:
      post("https://#{config(:domain)}/oauth/token", request_body, [
        {"Accept", "application/json"},
        {"Content-Type", "application/json"}
      ])

  def process_request_body(body), do: Jason.encode!(body)

  def process_response_body(body) do
    case Jason.decode(body) do
      {:ok, body} ->
        body

      error ->
        error
    end
  end

  def create_token_request do
    %{
      client_id: config(:client_id),
      client_secret: config(:client_secret),
      audience: config(:app_baseurl),
      grant_type: "client_credentials"
    }
  end

  defp config(name), do: :ueberauth |> Application.get_env(OAuth, []) |> Keyword.get(name)
end
