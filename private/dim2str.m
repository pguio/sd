function str=dim2str(v,n)
% function str=dim2str(v,n)

%
% $Id: dim2str.m,v 1.3 2011/03/26 15:10:50 patrick Exp $
%
% Copyright (c) 2000-2011 Patrick Guio <patrick.guio@gmail.com>
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

if nargin<2,
	n = 4;
end

if length(v)>1,
	str = [num2str(v(1),n) ':' num2str(v(2)-v(1),n) ':' num2str(v(end),n) ];
else
	str = num2str(v,n);
end
