defmodule Reverie.Category do
  use Reverie.Web, :model

  schema "categories" do
    field :title, :string
    field :imgurl, :string
    field :admin_only, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :imgurl])
    |> validate_required([:title, :imgurl])
    |> unique_constraint(:title)
  end
end
