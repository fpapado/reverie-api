defmodule Reverie.Sticker do
  use Reverie.Web, :model

  schema "stickers" do
    field :title, :string
    belongs_to :sender, Reverie.User
    belongs_to :receiver, Reverie.User
    belongs_to :category, Reverie.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :receiver_id, :sender_id])
    |> validate_required([:title, :receiver_id, :sender_id, :category_id])
    |> validate_length(:title, min: 4)
    |> assoc_constraint(:category)
    |> validate_different_user
  end

  defp validate_different_user(changeset) do
    receiver_id = get_field(changeset, :receiver_id)
    sender_id = get_field(changeset, :sender_id)

    case receiver_id == sender_id do
      true ->
        add_error(changeset, :receiver_id, "cannot be the same as sender", [validation: :same_user])
      false ->
        changeset
    end
  end
end
