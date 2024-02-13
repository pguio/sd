function flag = eq(v1,v2)
% function flag = eq(v1,v2)

%
% $Id: eq.m,v 1.2 2014/06/06 09:38:54 patrick Exp $
%
% Copyright (c) 2012 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

% test variable
flag = (ndims(v1.var) == ndims(v2.var));
if ~flag, return; end
flag = all(size(v1.var) == size(v2.var));
if ~flag, return; end
flag = all(v1.var(:) == v2.var(:));
if ~flag, return; end

% variable name
flag = flag & strcmp(v1.varname,v2.varname);
if ~flag, return; end

% dimensions
flag = (length(v1.dims) == length(v2.dims));
if ~flag, return; end
for i=1:length(v1.dims),
  flag = (length(v1.dims{i}) == length(v2.dims{i}));
  if ~flag, return; end
  flag = all(v1.dims{i} == v2.dims{i});
  if ~flag, return; end
  flag = strcmp(v1.dimsname{i},v2.dimsname{i});
  if ~flag, return; end
end

% don't test verbose level and version
return 
flag = all(v1.verbose == v2.verbose);
if ~flag, return; end
flag = strcmp(v1.ver{1},v2.ver{1});
if ~flag, return; end
flag = strcmp(v1.ver{2},v2.ver{2});
if ~flag, return; end


