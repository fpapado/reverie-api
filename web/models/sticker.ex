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
    |> validate_required([:title, :receiver_id, :sender_id])
    |> validate_length(:title, min: 4)
    |> validate_different_user
  end

  defp validate_different_user(changeset) do
    receiver_id = get_field(changeset, :receiver_id)
    sender_id = get_field(changeset, :sender_id)

    case receiver_id == sender_id do
      true ->
        add_error(changeset, :receiver_id, "you cannot send stickers to yourself")
      false ->
        changeset
    end
  end
end
