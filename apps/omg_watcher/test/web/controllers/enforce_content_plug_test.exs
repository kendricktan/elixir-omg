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

defmodule OMG.Watcher.Web.Controller.EnforceContentPlugTest do
  use ExUnitFixtures
  use ExUnit.Case, async: false
  use OMG.API.Fixtures
  use Plug.Test

  @tag fixtures: [:phoenix_ecto_sandbox]
  test "Request missing expected content type header is rejected" do
    no_account = OMG.RPC.Web.Encoding.to_hex(<<0::160>>)

    response =
      conn(:post, "account.get_balance", %{"address" => no_account})
      |> OMG.Watcher.Web.Endpoint.call([])

    assert response.status == 200

    assert %{
             "data" => %{
               "code" => "bad_request:missing_json_content_type_header",
               "description" => nil,
               "object" => "error"
             },
             "success" => false,
             "version" => "1.0"
           } == Poison.decode!(response.resp_body)
  end
end