defmodule Reverie.StickerControllerTest do
  use Reverie.ConnCase

  alias Reverie.Sticker
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  defp create_test_stickers(user) do
    other_user = Repo.insert! %Reverie.User{}

    # Three stickers with the logged-in user as receiver, other as sender
    Enum.each ["first", "second", "third"], fn title ->
      Repo.insert! %Reverie.Sticker{receiver_id: user.id, sender_id: other_user.id, title: title}
    end

    # Two stickers with other as receiver, logged-in user as sender
    Enum.each ["fourth", "fifth"], fn title ->
      Repo.insert! %Reverie.Sticker{receiver_id: other_user.id, sender_id: user.id, title: title}
    end
  end

  setup %{conn: conn} do
    # Crerate a user (bypassing validation)
    user = Repo.insert! %Reverie.User{}
    # Encode JWT for the user
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "lists owned entries on index (receiver_id == user id)", %{conn: conn, user: user} do
    # Build test stickers
    create_test_stickers user

    # List of stickers owned by user
    conn = get conn, sticker_path(conn, :index, user_id: user.id)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  test "does not list stickers owned by another user on index, and returns not found", %{conn: conn, user: user} do
    # Build test stickers
    create_test_stickers user
    other_user = Repo.insert! %Reverie.User{}

    # Test sticker with other user as receiver
    # TODO: pass other_user to functions instead?
    Repo.insert! %Reverie.Sticker{receiver_id: other_user.id, sender_id: user.id, title: "One more sticker"}

    conn = get conn, sticker_path(conn, :index, user_id: other_user.id)
    assert (json_response(conn, 404))
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    other_user = Repo.insert! %Reverie.User{}
    sticker = Repo.insert! %Sticker{receiver_id: user.id, sender_id: other_user.id}

    conn = get conn, sticker_path(conn, :show, sticker)

    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(sticker.id),
      "type" => "sticker",
      "attributes" => %{
        "title" => sticker.title
      },
      "relationships" => %{
        "receiver" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/users/#{user.id}"
          }
        },
        "sender" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/users/#{other_user.id}"
          }
        }
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, user: _user} do
    assert_error_sent 404, fn ->
      get conn, sticker_path(conn, :show, -1)
    end
  end

  test "shows chosen resource, with an included array of related data, when specified", %{conn: conn, user: user} do
    # Build test stickers
    create_test_stickers user

    # List of stickers owned by user is 3,
    # but only one user included since all stickers are from them
    # see http://jsonapi.org/format/#document-compound-documents
    conn = get conn, sticker_path(conn, :index, user_id: user.id, include: "sender")
    assert Enum.count(json_response(conn, 200)["data"]) == 3
    assert Enum.count(json_response(conn, 200)["included"]) == 1
  end

  test "creates and renders resource when data is valid, using id", %{conn: conn, user: user} do
    other_user = Repo.insert! %Reverie.User{}
    conn = post conn, sticker_path(conn, :create), data: %{type: "stickers", attributes: @valid_attrs, relationships: %{"receiver": %{"data": %{"type": "users", "id": other_user.id}}, "sender": %{"data": %{"type": "users", "id": user.id}}}}

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Sticker, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    other_user = Repo.insert! %Reverie.User{}
    conn = post conn, sticker_path(conn, :create), data: %{type: "stickers", attributes: @invalid_attrs, relationships: %{"receiver": %{"data": %{"type": "users", "id": other_user.id}}, "sender": %{"data": %{"type": "users", "id": user.id}}}}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and renders errors when user sends themselves a sticker", %{conn: conn, user: user} do
    conn = post conn, sticker_path(conn, :create), data: %{type: "stickers", attributes: @invalid_attrs, relationships: %{"receiver": %{"data": %{"type": "users", "id": user.id}}, "sender": %{}}}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    other_user = Repo.insert! %Reverie.User{}
    sticker = Repo.insert! %Sticker{receiver_id: user.id, sender_id: other_user.id}
    conn = delete conn, sticker_path(conn, :delete, sticker)
    assert response(conn, 204)
    refute Repo.get(Sticker, sticker.id)
  end
end
