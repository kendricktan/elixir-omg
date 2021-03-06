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
defmodule OMG.RootChainCoordinator.Service do
  @moduledoc """
  Represents a state of a service that is coordinated by `RootChainCoordinator.Core`
  """

  defstruct synced_height: nil, pid: nil

  @type t() :: %__MODULE__{
          synced_height: pos_integer(),
          pid: pid()
        }
end
