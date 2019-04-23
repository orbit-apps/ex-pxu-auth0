defmodule PxUAuth0.AccessTokenTest do
  use ExUnit.Case
  alias PxUAuth0.AccessToken

  defmodule MockNaiveDateTime do
    def utc_now do
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(23 * 60 * 60 * 1000 + 10_000, :millisecond)
    end
  end

  setup do
    AccessToken.start_link()
    :ok
  end

  describe "get/0" do
    setup do
      AccessToken.empty()
      %{token: %{"foo" => "bar"}}
    end

    test "it looks up an access token if one exists", %{token: token} do
      AccessToken.store(token)
      assert AccessToken.get() == token
    end

    test "it returns nil if date difference is greater than config", %{token: token} do
      AccessToken.store(token, MockNaiveDateTime)
      assert AccessToken.get() == nil
    end

    test "it returns nil if there is no access token" do
      assert AccessToken.get() == nil
    end
  end
end
