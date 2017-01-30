defmodule Plugs.GithubAuthTest do
  use Galendar.ConnCase

  test "redirects unauthorized requests", %{conn: conn} do
    conn = conn
    |> Plugs.GithubAuth.call(nil)

    assert "https://github.com" <>
      "/login/oauth/authorize?" <>
      "client_id=client_id&" <>
      "redirect_uri=http%3A%2F%2Flocalhost%3A4000%2Fauth%2Fcallback&" <>
      "response_type=code&" <>
      "scope=user%2Cread%3Aorg%2Crepo" == redirected_to(conn)
  end

  test "does nothing to authorized requests", %{conn: conn} do
    conn = conn
    |> put_req_cookie("auth_token", "token")
    |> Plugs.GithubAuth.call(nil)

    assert 302 != conn.status
  end
end
