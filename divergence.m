function div=divergence(u,v,w)
% function div=divergence(u,v,w)

%
% $Id: divergence.m,v 1.4 2011/03/26 15:09:33 patrick Exp $
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

if nargin==2,
	
	if ndims(u.var) ~= 2 | ndims(v.var) ~= 2, 
		error('U,V must be 2D arrays');
	end

	[y,x]=meshgrid(u.dims{2},u.dims{1});

	div=u;

	div.varname = ['\nabla\cdot(' u.varname ',' v.varname ')'];

	div = divergence(y, x, u.var, v.var);

elseif nargin==3

	if ndims(u.var) ~= 3 | ndims(v.var) ~= 3 | ndims(w.var) ~= 3, 
		error('U,V and W must be 3D arrays');
	end

	[y,x,z]=meshgrid(u.dims{2},u.dims{1},u.dims{3});

	div=u;

	div.varname = ['\nabla\cdot(' u.varname ',' v.varname ',' w.varname ')'];

	div.var = divergence(y, x, z, u.var, v.var, w.var);

end 

