function L=del2(f)
% function L=del2(f)

%
% $Id: del2.m,v 1.4 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2005-2011 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2.  of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

L=f;

L.varname = ['\nabla^2' f.varname];

for i=1:ndims(f.var),
	h{i} = f.dims{i}(2)-f.dims{i}(1);
end

L.var = del2(f.var,h{:});


