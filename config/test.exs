use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :galendar, Galendar.Endpoint,
  http: [port: 4001],
  server: false

config :galendar,
  oauth_client_id: "client_id",
  oauth_client_secret: "client_secret"

# Print only warnings and errors during test
config :logger, level: :warn
