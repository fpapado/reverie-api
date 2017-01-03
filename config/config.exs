# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :reverie,
  ecto_repos: [Reverie.Repo]

# Configures the endpoint
config :reverie, Reverie.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QYjJ8mGjz/THz0frJK5gO7S35vnBugU3ASWNBeIeXHbCCvqEdKtElXTBpIwH1T6k",
  render_errors: [view: Reverie.ErrorView, accepts: ~w(json)],
  pubsub: [name: Reverie.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure Guardian
# Tries to get GUARDIAN_SECRET from env (e.g. prod) else uses fallback
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Reverie",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET") || "lwYUio/QosefTMQGbBAFbdfZJxt89u3RSPztc930hyEgMbHepMG+G1JmoRM45QGo",
  serializer: Reverie.GuardianSerializer

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# JSON-API handling
config :phoenix, :format_encoders,
    "json-api": Poison

config :mime, :types, %{
    "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
