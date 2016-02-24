defmodule Vaulter.Client do
  import Poison, only: [decode!: 1]

  def sendRequest({:ok, request}) when is_map(request) do
    opts = []
    :hackney.request(request.method,
                    request.url,
                    request.headers,
                    request.payload,
                    opts)
    |> handleResponseCode
  end

  def sendRequest({:err, bad_request}) do
    bad_request
  end

  defp handleResponseCode({:ok, responseCode, _, clientRef}) do
    case {responseCode} do 
      {200} ->
        {:ok, respBody} = :hackney.body(clientRef)
        {:ok, decode!(respBody)}
      {204} ->
        {:ok, :done}
      {400} ->
        {:err, "Invalid request, missing or invalid data."}
      {403} ->
        {:err, "Forbidden, your authentication details are either incorrect or you don't have access to this feature."}
      {404} ->
        {:err, "Invalid path."}
      {405} ->
        {:err, "Wrong HTTP method"}
      {429} ->
        {:err, "Rate limit exceeded. Try again after waiting some period of time."}
      {500} -> 
        {:err, "Internal server error. An internal error has occurred, try again later. If the error persists, report a bug."}
      {503} ->
        {:err, "Vault is down for maintenance or is currently sealed. Try again later."}
    end
  end

end
