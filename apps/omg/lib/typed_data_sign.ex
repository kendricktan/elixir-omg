# Copyright 2018 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule OMG.TypedDataSign do
  @moduledoc """
  Verifies typed structured data signatures (see: http://eips.ethereum.org/EIPS/eip-712)
  """

  alias OMG.Crypto
  alias OMG.Signature
  alias OMG.State.Transaction

  @type_hash_v1 Crypto.hash(
                  "Transaction(" <>
                    "Input input0,Input input1,Input input2,Input input3," <>
                    "Output output0,Output output1,Output output2,Output output3," <>
                    "bytes32 metadata)" <>
                    "Input(uint256 blknum,uint32 txindex,uint8 oindex)" <>
                    "Output(address owner,address currency,uint256 amount)"
                )

  # TODO: compute this
  @domain_separator_v1 <<0::256>>

  @doc """
  Verifies if signature was created by private key corresponding to `address` and structured data
  used to sign was derived from `domain_separator` and `raw_tx`
  """
  @spec verify(Transaction.t(), binary(), Crypto.address_t(), Crypto.hash_t()) :: {:ok, boolean()}
  def verify(raw_tx, signature, address, domain_separator \\ @domain_separator_v1) do
    {:ok, false}
  end

  @doc """
  Computes Domain Separator `hashStruct(eip712Domain)`,
  @see: http://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator
  """
  @spec domain_separator(binary(), binary(), pos_integer(), Crypto.address_t(), binary()) :: binary()
  def domain_separator(name, version, chainId, verifyingContract, salt) do
    type =
      Crypto.hash("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")

    data = [
      Crypto.hash(name),
      Crypto.hash(version),
      ABI.TypeEncoder.encode_raw([chainId], [{:uint, 256}]),
      ABI.TypeEncoder.encode_raw([verifyingContract], [:address]),
      ABI.TypeEncoder.encode_raw([salt], [{:bytes, 32}])
    ]

    [type | data]
    |> Enum.reduce(&Kernel.<>/2)
    |> Crypto.hash()
  end
end
