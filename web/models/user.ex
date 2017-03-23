defmodule Reverie.User do
  use Reverie.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    # Virtual fields for password confirmation
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    # One side of the relationship
    has_many :stickers_sent, Reverie.Sticker, foreign_key: :sender_id
    has_many :stickers_received, Reverie.Sticker, foreign_key: :receiver_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  Passes changeset through a pipeline of validations
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset) do
    changeset
  end

  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end
end
