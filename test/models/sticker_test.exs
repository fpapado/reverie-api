defmodule Reverie.StickerTest do
  use Reverie.ModelCase

  alias Reverie.Sticker

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Sticker.changeset(%Sticker{receiver_id: 1, sender_id: 2}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with same sender and receive" do
    changeset = Sticker.changeset(%Sticker{receiver_id: 1, sender_id: 1}, @valid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sticker.changeset(%Sticker{}, @invalid_attrs)
    refute changeset.valid?
  end
end
