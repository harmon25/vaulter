defmodule Vaulter do
	alias Vaulter.Util
	alias Vaulter.Client
	
	def auth(username, password) do
		Util.genAuthRequest(:post,"auth/userpass/login/" <> username, %{password: password})
		|> Client.sendRequest
		|> saveToken
	end

	defp saveToken({:ok, respBody}) do
		if Map.has_key?(respBody, "auth") do
			authInfo = Map.get(respBody, "auth")
			if Map.has_key?(authInfo, "client_token") do
				token = Map.get(authInfo, "client_token")
				System.put_env("VAULTER_TOKEN", token)
				{:ok, token	}
			end
		end
	end

	defp saveToken({:err, _}) do
		{:err, "Login Failed..."}
	end

	def get(path, params) do
		Util.genRequest(:get, path, params)
		|> Client.sendRequest
	end

	def get(path) do
		Util.genRequest(:get, path)
		|> Client.sendRequest
	end

	def put(path, params) do
		Util.genRequest(:put, path, params)
		|> Client.sendRequest
	end

	def put(path) do
		Util.genRequest(:put, path)
		|> Client.sendRequest
	end

	def post(path, params) do
		Util.genRequest(:post, path, params)
		|> Client.sendRequest
	end

	def post(path) do
		Util.genRequest(:post, path)
		|> Client.sendRequest
	end

	def del(path, params) do
		Util.genRequest(:del, path, params)
		|> Client.sendRequest
	end

	def del(path) do
		Util.genRequest(:del, path)
		|> Client.sendRequest
	end

end