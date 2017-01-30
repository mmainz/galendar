defmodule Galendar.PageControllerTest do
  use Galendar.ConnCase

  defp token do
    %{token_type: "Bearer", access_token: "token"}
    |> Poison.encode!
    |> Base.encode64
  end

  test "unauthorized user is redirected to authorization", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302)
  end

  test "authorized user sees the page", %{conn: conn} do
    conn = conn
    |> put_req_cookie("auth_token", token())
    |> get("/")
    assert html_response(conn, 200)
  end
end
