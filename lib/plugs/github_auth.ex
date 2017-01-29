defmodule Plugs.GithubAuth do
  @moduledoc false

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> Plug.Conn.fetch_cookies
    |> redirect_unless_authorized
  end

  defp redirect_unless_authorized(conn) do
    if conn.cookies["auth_token"] do
      conn
    else
      redirect_to_authorization(conn)
    end
  end

  defp redirect_to_authorization(conn) do
    conn
    |> Phoenix.Controller.redirect(external: Github.authorize_url!)
    |> Plug.Conn.halt
  end
end
