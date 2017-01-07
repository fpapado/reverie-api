defmodule Reverie.StickerView do
  use Reverie.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title]
  has_one :sender, link: :sender_link
  has_one :receiver, link: :receiver_link

  def sender_link(room, conn) do
    user_url(conn, :show, room.sender_id)
  end

  def receiver_link(room, conn) do
    user_url(conn, :show, room.receiver_id)
  end

  def render("index.json", %{data: stickers}) do
    %{data: render_many(stickers, Reverie.StickerView, "sticker.json")}
  end

  def render("show.json", %{data: sticker}) do
    %{data: render_one(sticker, Reverie.StickerView, "sticker.json")}
  end

  def render("sticker.json", %{data: sticker}) do
    %{id: sticker.id,
      title: sticker.title,
      sender_id: sticker.sender_id,
      receiver_id: sticker.receiver_id}
  end
end
