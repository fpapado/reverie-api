defmodule Reverie.Router do
  use Reverie.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Reverie do
    pipe_through :api

    # Registration
    post "/register", RegistrationController, :create

    # Login; JWT token provision
    post "/token", SessionController, :create, as: :login

    # Route session to SessionController
    resources "/session", SessionController, only: [:index]
  end
end
