defmodule Bec.Encrypted.Binary do
  @moduledoc false
  use Cloak.Ecto.Binary, vault: Bec.Vault
end
