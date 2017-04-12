defmodule Reverie.CheckAdmin do
  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    if current_user.is_admin do
      conn
    else
      conn
      |> Reverie.AuthErrorHandler.unauthorized([])
    end
  end
end
