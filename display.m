function display(X)
% function display(X)

%
% $Id: display.m,v 1.3 2011/03/26 15:09:33 patrick Exp $
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

if isequal(get(0,'FormatSpacing'),'compact')
	disp([inputname(1) ' =']);
	disp([' variable  ' X.varname '(' num2str(size(X.var)) ')'])
	for i=1:length(X.dims)
		disp([' dimension ' X.dimsname{i} '(' num2str(length(X.dims{i})) ')'])
	end
else
	disp(' ')
	disp([inputname(1) ' =']);
	disp(' ')
	disp([' variable  ' X.varname '(' num2str(size(X.var)) ')'])
	for i=1:length(X.dims)
		disp([' dimension ' X.dimsname{i} '(' num2str(length(X.dims{i})) ')'])
	end
	disp(' ')
end
