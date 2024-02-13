function varargout=gradient(f)
% function [fx,fy,..]=gradient(f)

%
% $Id: gradient.m,v 1.4 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2003-2011 Patrick Guio <patrick.guio@gmail.com>
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

dim=ndims(f.var);

for i=1:dim,
  varargout{i}=f;
	varargout{i}.varname = ['d(' f.varname ')/d(' f.dimsname{i} ')'];
	h{i} = f.dims{i}(2)-f.dims{i}(1);
	grad{i} = f.var;
end

[grad{:}] = gradient(f.var,h{:});

for i=1:dim,
	varargout{i}.var = grad{i};
end

