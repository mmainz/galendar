defmodule Github do
  @moduledoc false
  @scope "user,read:org,repo"

  use OAuth2.Strategy

  def new do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: Application.get_env(:galendar, :oauth_client_id),
      client_secret: Application.get_env(:galendar, :oauth_client_secret),
      redirect_uri: "http://localhost:4000/auth/callback",
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token")
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(new, scope: @scope)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(new, params, headers, opts)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
