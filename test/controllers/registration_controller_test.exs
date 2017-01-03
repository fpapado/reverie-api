defmodule Reverie.RegistrationControllerTest do
  use Reverie.ConnCase

  alias Reverie.User

  @valid_attrs %{
    email: "fp@example.com",
    password: "abcde12345",
    "password-confirmation": "abcde12345"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), %{data: %{type: "users",
      attributes: @valid_attrs
      }}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{email: @valid_attrs[:email]})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    assert_error_sent 400, fn ->
      conn = post conn, registration_path(conn, :create),  %{data: %{type: "user",
        attributes: @invalid_attrs
      }}
    end
  end

end
