%% Hotchpotch
%% Copyright (C) 2010  Jan Klötzke <jan DOT kloetzke AT freenet DOT de>
%%
%% This program is free software: you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

-module (fuse).
-behaviour(supervisor).

-export([get_supervisor_spec/2, start_link/1]).
-export([init/1]).


get_supervisor_spec(Id, Options) ->
	{
		Id,
		{fuse, start_link, [Options]},
		permanent,
		infinity,
		supervisor,
		[fuse]
	}.


start_link(Options) ->
	supervisor:start_link({local, fuse}, ?MODULE, Options).


init(Options) ->
	RestartStrategy    = one_for_all,
	MaxRestarts        = 1,
	MaxTimeBetRestarts = 60,
	ChildSpecs = [
		{
			fuse_store,
			{fuse_store, start_link, []},
			permanent,
			10000,
			worker,
			[fuse_store]
		},
		{
			fuse_client,
			{fuse_client, start_link, Options},
			permanent,
			10000,
			worker,
			[fuse_client]
		}
	],
	{ok, {{RestartStrategy, MaxRestarts, MaxTimeBetRestarts}, ChildSpecs}}.

