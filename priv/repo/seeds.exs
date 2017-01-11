# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Reverie.Repo.insert!(%Reverie.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Reverie.Repo
alias Reverie.Category


for %{title: title, imgurl: url} <- [ %{title: "You're cool", imgurl: "https://s3.eu-central-1.amazonaws.com/reveriestatic/cool.png"}, %{title: "You're funny", imgurl: "https://s3.eu-central-1.amazonaws.com/reveriestatic/funny.png"}, %{title: "Nice meeting you", imgurl: "https://s3.eu-central-1.amazonaws.com/reveriestatic/nicetomeet.png"}] do
  Repo.get_by(Category, title: title) ||
    Repo.insert!(%Category{title: title, imgurl: url})
end
