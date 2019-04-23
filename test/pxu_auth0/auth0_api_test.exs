defmodule PxUAuth0.Client.Auth0APITest do
  use ExUnit.Case
  alias PxUAuth0.Auth0API
  alias Ueberauth.Strategy.Auth0.OAuth

  describe "create_token_request/0" do
    test "it creates a request from configurations" do
      # all fields are nil because the config
      # is not set in this application
      expected_request_body = %{
        client_id: nil,
        client_secret: nil,
        audience: nil,
        grant_type: "client_credentials"
      }

      assert Auth0API.create_token_request() == expected_request_body
    end
  end
end
