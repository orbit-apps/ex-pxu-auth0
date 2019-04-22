defmodule PxUAuth0.ClientTest do
  use ExUnit.Case
  alias PxUAuth0.Client

  defmodule MockNaiveDateTime do
    def utc_now do
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(23 * 60 * 60 * 1000 + 10_000, :millisecond)
    end
  end

  setup do
    Client.start_link()
    :ok
  end

  describe "get/0" do
    setup do
      Client.empty()
      %{token: %{"access_token" => %{"foo" => "bar"}}}
    end

    test "it looks up an access token if one exists", %{token: token} do
      Client.store(token)
      %{"access_token" => access_token} = token
      assert Client.get() == {:ok, access_token}
    end

    test "it returns nil if date difference is greater than config", %{token: token} do
      Client.store(token, MockNaiveDateTime)
      assert Client.get() == nil
    end

    test "it returns nil if there is no access token" do
      assert Client.get() == nil
    end
  end
end
