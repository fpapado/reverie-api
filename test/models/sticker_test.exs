defmodule Reverie.StickerTest do
  use Reverie.ModelCase

  alias Reverie.Sticker

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    # Crerate users (bypassing validation)
    user = Repo.insert! %Reverie.User{}
    other_user = Repo.insert! %Reverie.User{}

    # Create test category
    test_category = Repo.insert!(%Reverie.Category{title: "You're cool", imgurl: "https://s3.eu-central-1.amazonaws.com/reveriestatic/cool.png"})

    {:ok, %{user: user, other_user: other_user, category: test_category}}
  end

  test "changeset with valid attributes", %{user: user, other_user: other_user, category: category} do
    changeset = Sticker.changeset(%Sticker{receiver_id: user.id, sender_id: other_user.id, category_id: category.id}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with same sender and receiver", %{user: user, category: category} do
    changeset = Sticker.changeset(%Sticker{receiver_id: user.id, sender_id: user.id, category_id: category.id}, @valid_attrs)

    refute changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sticker.changeset(%Sticker{}, @invalid_attrs)
    refute changeset.valid?
  end
end
