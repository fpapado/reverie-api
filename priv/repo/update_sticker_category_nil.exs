alias Reverie.Repo
alias Reverie.Sticker
import Ecto.Query

from(s in Sticker, where: is_nil(s.category_id))
|> Repo.update_all!(set: [category_id: 1])
