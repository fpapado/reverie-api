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

  test "shows chosen category", %{conn: conn} do
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

  test "lists all categories", %{conn: conn} do
    category1 = Repo.insert! %Category{title: "test", imgurl: "some url"}
    category2 = Repo.insert! %Category{title: "another test", imgurl: "some url"}

    conn = get conn, category_path(conn, :index)

    assert json_response(conn, 200)["data"] ==
      [
        %{
          "type" => "category",
          "id" => to_string(category1.id),
          "attributes" => %{
            "title" => category1.title,
            "imgurl" => category1.imgurl
          }
        },
        %{
          "type" => "category",
          "id" => to_string(category2.id),
          "attributes" => %{
            "title" => category2.title,
            "imgurl" => category2.imgurl
          }
        }
    ]
  end


  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, category_path(conn, :show, -1)
    end
  end
end
