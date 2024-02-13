function y=sqeeze(x)
% function y=sqeeze(x)

%
% $Id: squeeze.m,v 1.8 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('dim'), dim=1; end;
y=sd;
y.var = squeeze(x.var);
y.varname = x.varname;
j=1;
for i=1:length(x.dims)
	if length(x.dims{i})>1,
		y.dims{j}=x.dims{i};
		y.dimsname{j}=x.dimsname{i};
		j=j+1;
	else
		y.varname = strcat(y.varname, ...
			'[',x.dimsname{i},'=',num2str(x.dims{i},4),']');
	end
end

