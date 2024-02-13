function field=subvolume(field,subdim)
% function field=subvolume(field,subdim)

%
% $Id: subvolume.m,v 1.6 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('subdim')
	return
end

if length(subdim)~=length(field.dims),
	error('Dimension mismatch between field and subdim')
end

for i=1:length(field.dims)
	indexes{i}=1:length(field.dims{i});
	siz(i)=length(indexes{i});
end

for i=1:length(field.dims)
	if ~isempty(subdim{i}),
		indexes{i}=subdim{i};
		siz(i)=length(subdim{i});
		field.dims{i}=field.dims{i}(subdim{i});
	end
end

field.var=field.var(indexes{:});

