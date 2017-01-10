defmodule Reverie.StickerView do
  use Reverie.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title]
  has_one :sender,
    serializer: Reverie.UserView,
    link: :sender_link,
    include: false,
    identifiers: :when_included

  has_one :receiver,
    serializer: Reverie.UserView,
    link: :receiver_link,
    include: false,
    identifiers: :when_included

  def sender_link(sticker, conn) do
    user_url(conn, :show, sticker.sender_id)
  end

  def receiver_link(sticker, conn) do
    user_url(conn, :show, sticker.receiver_id)
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
