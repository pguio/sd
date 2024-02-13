function y=transpose(x)
% function y=transpose(x)

%
% $Id: transpose.m,v 1.5 2011/03/26 15:09:33 patrick Exp $
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

y=x;

y.var = transpose(x.var);
for i=1:length(x.dims),
	y.dims{i}=x.dims{length(x.dims)+1-i};
	y.dimsname{i}=x.dimsname{length(x.dims)+1-i};
end

