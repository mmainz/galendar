defmodule Galendar.PageControllerTest do
  use Galendar.ConnCase

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
