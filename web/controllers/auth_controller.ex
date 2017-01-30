defmodule Galendar.AuthController do
  use Galendar.Web, :controller

  def callback(conn, %{"code" => code}) do
    case get_token(code) do
      %{token: %{access_token: at} = token} when not is_nil(at) ->
        conn
        |> put_resp_cookie("auth_token", encode(token))
        |> redirect(to: page_path(conn, :index))

      {:error, _} ->
        conn
        |> redirect(external: Github.authorize_url!)

      _ ->
        conn
        |> redirect(external: Github.authorize_url!)
    end
  end

  defp get_token(code) do
    try do
      Github.get_token!(code: code)
    catch
      error -> {:error, error}
    end
  end

  defp encode(token), do: token |> Poison.encode! |> Base.encode64
end
