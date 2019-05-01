defmodule PxUAuth0.UserHelpersTest do
  use ExUnit.Case
  alias PxUAuth0.UserHelpers

  describe "current_user/1" do
    test "returns nil if not logged in" do
      assert UserHelpers.current_user(%{assigns: %{}}) == nil
    end

    test "returns current user if logged in" do
      user = %{foo: :bar}
      assert UserHelpers.current_user(%{assigns: %{current_user: user}}) == user
    end
  end

  describe "logged_in?/1" do
    test "returns false if not logged in" do
      refute UserHelpers.logged_in?(%{assigns: %{}})
    end

    test "returns true if logged in" do
      assert UserHelpers.logged_in?(%{assigns: %{current_user: %{foo: :bar}}})
    end
  end

  describe "in_group?/2" do
    setup do
      conn = %{assigns: %{current_user: %{groups: []}}}
      [conn: conn]
    end

    test "returns false with out any groups", %{conn: conn} do
      refute UserHelpers.in_group?(conn, "test")
    end

    test "returns false if user does not belong to group", %{conn: conn} do
      conn = put_in(conn[:assigns][:current_user][:groups], ["foo", "bar"])
      refute UserHelpers.in_group?(conn, "test")
    end

    test "returns true if user belongs to group", %{conn: conn} do
      conn = put_in(conn[:assigns][:current_user][:groups], ["test", "bar"])
      assert UserHelpers.in_group?(conn, "test")
    end

    test "returns false if user does not belong to any group passed in", %{conn: conn} do
      conn = put_in(conn[:assigns][:current_user][:groups], ["test", "bar"])
      refute UserHelpers.in_group?(conn, ["foo", "baz"])
    end

    test "returns true if user belongs to any group passed in", %{conn: conn} do
      conn = put_in(conn[:assigns][:current_user][:groups], ["test", "bar"])
      assert UserHelpers.in_group?(conn, ["test", "foo"])
    end
  end
end
