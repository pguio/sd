function b = subsref(a,s)
% function b = subsref(a,s)

%
% $Id: subsref.m,v 1.5 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2006-2011 Patrick Guio <patrick.guio@gmail.com>
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

if ~strcmp(s.type,'()')
	error(sprintf('%s not supported.',s.type))
end

if length(s.subs)~=length(a.dims)
	error('Dimensions do not agree.')
end

b=a;

b.var = a.var(s.subs{:});
for i=1:length(a.dims)
	b.dims{i} = a.dims{i}(s.subs{i});
end

