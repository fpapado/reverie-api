defmodule Reverie.CategoryControllerTest do
  use Reverie.ConnCase

  alias Reverie.Category
  @valid_attrs %{imgurl: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %Reverie.User{}

    # Encode JWT for the user
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "shows chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{title: "test", imgurl: "some url"}
    conn = get conn, category_path(conn, :show, category)
    assert json_response(conn, 200)["data"] ==
      %{
        "type" => "category",
        "id" => to_string(category.id),
        "attributes" => %{
          "title" => category.title,
          "imgurl" => category.imgurl
        }
      }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, category_path(conn, :show, -1)
    end
  end
end
