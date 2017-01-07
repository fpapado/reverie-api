defmodule Reverie.Sticker do
  use Reverie.Web, :model

  schema "stickers" do
    field :title, :string
    belongs_to :sender, Reverie.Sender
    belongs_to :receiver, Reverie.Receiver

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 4)
  end
end
