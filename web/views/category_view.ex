defmodule Reverie.CategoryView do
  use Reverie.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :imgurl]

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Reverie.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Reverie.CategoryView, "category.json")}
  end

  # Render single category in JSONAPI format
  # TODO: check whether JaSerializer has this functionality
  def render("category.json", %{category: category}) do
    %{
      "type": "category",
      "id": category.id,
      "attributes": %{
        "title": category.title,
        "imgurl": category.imgurl
      }
    }
  end
end
