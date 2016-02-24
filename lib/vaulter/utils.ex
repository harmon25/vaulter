defmodule Vaulter.Util do
	import Application, only: [get_env: 2]
	import Poison, only: [encode!: 1]
	alias Vaulter.Token

	@wrongParams {:err, "Vaulter: Wrong params"}

	defp buildURL(endpoint) when is_bitstring(endpoint) do
		proto = case get_env(:vaulter, :vault_ssl)  do
			true -> "https://"
			false -> "http://"
		end
	
		{:ok, proto <>
			get_env(:vaulter, :vault_host) <>
			":" <> 
			get_env(:vaulter, :vault_port) <> 
			"/" <> 
			get_env(:vaulter, :vault_api) <>
			"/" <>
			endpoint}
	end
	defp buildURL(_), do: @wrongParams

  def genAuthRequest(method, path, params) when is_atom(method) and is_bitstring(path) and is_map(params) do
	    {:ok, url} = buildURL(path)
	    {:ok, %{method: method,
	      url: url,
	      payload: encode!(params),
	      headers: [{"Content-Type", 'application/json'}]
	     }}
  end
  def genAuthRequest(_, _, _), do: @wrongParams
  
  def genRequest(method, path, params) when is_atom(method) and is_bitstring(path) and is_map(params) do
  	token = System.get_env("VAULTER_TOKEN")
  	if is_bitstring(token) do
	    {:ok, url} = buildURL(path)
	    {:ok, %{method: method,
	      url: url,
	      payload: encode!(params),
	      headers: [{"Content-Type", 'application/json'}, {"X-Vault-Token", token}]
	     }}
	 else
	 	{:err, "no token"}
	end
  end
  def genRequest(_, _, _), do: @wrongParams


   def genRequest(method, path) when is_atom(method) and is_bitstring(path) do
   	token = System.get_env("VAULTER_TOKEN")
   	if is_bitstring(token) do
	    {:ok, url} = buildURL(path)
	    {:ok, %{method: method,
		        url: url,
		        payload: "",
		        headers: [{"Content-Type", 'application/json'}, {"X-Vault-Token", token}]
	     		}
	    }
	 else
	 	{:err, "no token"}
	 end
  end

  def genRequest(_, _), do: @wrongParams

end