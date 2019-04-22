defmodule PxUAuth0.UserToken do
  use Joken.Config
  alias Joken.Signer

  @claim_namespace "https://pxu.co/claims/"

  def token_config do
    %{}
    |> add_claim(
      "aud",
      fn -> config(:client_id) end,
      fn val -> val == config(:client_id) end
    )
    |> add_claim(
      "iss",
      fn -> "https://#{config(:domain)}/" end,
      fn val -> val == "https://#{config(:domain)}/" end
    )
  end

  def claim_namespace, do: @claim_namespace

  defp config(name) do
    :ueberauth |> Application.get_env(Ueberauth.Strategy.Auth0.OAuth) |> Keyword.get(name)
  end

  def signer, do: Signer.parse_config(:rs256)
end
