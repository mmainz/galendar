defmodule Galendar.AuthTest do
  use Galendar.ConnCase, async: false

  import Mock

  defp authorize_url_mock, do: "http://www.example.com/authorize"
  defp get_token_mock(code: "fail"), do: throw OAuth2.Error
  defp get_token_mock(_), do: %{token: %{access_token: "token"}}
  defp expected_token, do: %{"access_token" => "token"}

  test "puts token in a cookie if it can be obtained", %{conn: conn} do
    with_mock Github, [get_token!: &get_token_mock/1] do
      conn = get conn, "/auth/callback", %{code: "12345"}
      assert redirected_to(conn, 302)
      assert expected_token() == Poison.decode!(conn.cookies["auth_token"])
    end
  end

  test "redirects to auth if no token can be obtained", %{conn: conn} do
    with_mock Github, [get_token!: &get_token_mock/1,
                       authorize_url!: &authorize_url_mock/0] do
      conn = get conn, "/auth/callback", %{code: "fail"}
      assert redirected_to(conn, 302) == "http://www.example.com/authorize"
      assert nil == conn.cookies["auth_token"]
    end
  end

  test "unauthorized user is redirected to authorization", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302)
  end

  test "authorized user sees the page", %{conn: conn} do
    conn = conn
    |> put_req_cookie("auth_token", "code")
    |> get("/")
    assert html_response(conn, 200)
  end
end
