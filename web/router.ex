defmodule Reverie.Router do
  use Reverie.Web, :router

  # Unauthenticated requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticate requests
  # We first ensure that the token is signed by this server
  # We also extract the user from the JWT
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  # Unauthenticated scope
  scope "/api", Reverie do
    pipe_through :api

    # Registration
    post "/register", RegistrationController, :create
    # Login; JWT token provision
    post "/token", SessionController, :create, as: :login
  end

  # Authenticated scope
  scope "/api", Reverie do
      pipe_through :api_auth
      get "/user/current", UserController, :current
  end
end
