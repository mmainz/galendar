defmodule GithubTest do
  use ExUnit.Case

  import Mock

  test "returns a preconfigured client" do
    assert "http://localhost:4000/auth/callback" == Github.new.redirect_uri
  end

  test "construcst a correct authorization URL" do
    assert "https://github.com/login/oauth/authorize?" <>
      "client_id=client_id&" <>
      "redirect_uri=http%3A%2F%2Flocalhost%3A4000%2Fauth%2Fcallback&" <>
      "response_type=code&" <>
      "scope=user%2Cread%3Aorg%2Crepo" == Github.authorize_url!
  end

  test "gets an auth token" do
    with_mock OAuth2.Client, [get_token!: fn _, _, _, _ -> :token end,
                              new: fn _ -> :client end] do
      assert :token == Github.get_token!(code: "code")
    end
  end
end
