defmodule PxUAuth0.APIToken do
  use Joken.Config
  alias Joken.Signer
  alias Ueberauth.Strategy.Auth0.OAuth

  def token_config do
    %{}
    |> add_claim(
      "aud",
      fn -> config(:app_baseurl) end,
      fn val -> val == config(:app_baseurl) end
    )
    |> add_claim(
      "iss",
      fn -> "https://#{config(:domain)}/" end,
      fn val -> val == "https://#{config(:domain)}/" end
    )
  end

  def signer, do: Signer.parse_config(:rs256)

  defp config(name), do: :ueberauth |> Application.get_env(OAuth) |> Keyword.get(name)
end
