function varargout=curl(u,v,w)
% function [curlx,curly,..]=curl(u,v,w)

%
% $Id: curl.m,v 1.6 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2001-2011 Patrick Guio <patrick.guio@gmail.com>
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

	cz=u;
	ca=u;

	cz.varname = ['\nabla_z\times(' u.varname ',' v.varname ')'];
%	    nrm = sqrt(u.^2 + v.^2 + w.^2);
%	    cav = .5 * (curlx.*u + curly.*v + curlz.*w) ./nrm;
	ca.varname = ['\nabla\times(' u.varname ',' v.varname ')'];

	[cz.var, ca.var] = curl(y, x, u.var, v.var);

	varargout(1) = {cz};
	varargout(2) = {ca};

elseif nargin==3

	if ndims(u.var) ~= 3 | ndims(v.var) ~= 3 | ndims(w.var) ~= 3, 
		error('U,V and W must be 3D arrays');
	end

	[y,x,z]=meshgrid(u.dims{2},u.dims{1},u.dims{3});

	cx=u;
	cy=u;
	cz=u;
	ca=u;

	cx.varname = ['\nabla_x\times(' u.varname ',' v.varname ',' w.varname ')'];
	cy.varname = ['\nabla_y\times(' u.varname ',' v.varname ',' w.varname ')'];
	cz.varname = ['\nabla_z\times(' u.varname ',' v.varname ',' w.varname ')'];
	ca.varname = ['\nabla\times (' u.varname ',' v.varname ',' w.varname ')'];

	[cx.var, cy.var, cz.var, ca.var] = curl(y, x, z, u.var, v.var, w.var);

	varargout(1) = {cx};
	varargout(2) = {cy};
	varargout(3) = {cz};
	varargout(4) = {ca};

end 

