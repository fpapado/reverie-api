defmodule Reverie.CategoryView do
  use Reverie.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Reverie.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Reverie.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      title: category.title,
      imgurl: category.imgurl}
  end
end
