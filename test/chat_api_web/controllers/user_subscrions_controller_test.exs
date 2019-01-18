defmodule ChatApiWeb.UserSubscrionsControllerTest do
  use ChatApiWeb.ConnCase

  alias ChatApi.API
  alias ChatApi.API.UserSubscrions

  @create_attrs %{source: "some source", subscription: "some subscription"}
  @update_attrs %{source: "some updated source", subscription: "some updated subscription"}
  @invalid_attrs %{source: nil, subscription: nil}

  def fixture(:user_subscrions) do
    {:ok, user_subscrions} = API.create_user_subscrions(@create_attrs)
    user_subscrions
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_subscription", %{conn: conn} do
      conn = get conn, user_subscrions_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_subscrions" do
    test "renders user_subscrions when data is valid", %{conn: conn} do
      conn = post conn, user_subscrions_path(conn, :create), user_subscrions: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_subscrions_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "source" => "some source",
        "subscription" => "some subscription"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_subscrions_path(conn, :create), user_subscrions: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_subscrions" do
    setup [:create_user_subscrions]

    test "renders user_subscrions when data is valid", %{conn: conn, user_subscrions: %UserSubscrions{id: id} = user_subscrions} do
      conn = put conn, user_subscrions_path(conn, :update, user_subscrions), user_subscrions: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_subscrions_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "source" => "some updated source",
        "subscription" => "some updated subscription"}
    end

    test "renders errors when data is invalid", %{conn: conn, user_subscrions: user_subscrions} do
      conn = put conn, user_subscrions_path(conn, :update, user_subscrions), user_subscrions: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_subscrions" do
    setup [:create_user_subscrions]

    test "deletes chosen user_subscrions", %{conn: conn, user_subscrions: user_subscrions} do
      conn = delete conn, user_subscrions_path(conn, :delete, user_subscrions)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_subscrions_path(conn, :show, user_subscrions)
      end
    end
  end

  defp create_user_subscrions(_) do
    user_subscrions = fixture(:user_subscrions)
    {:ok, user_subscrions: user_subscrions}
  end
end
