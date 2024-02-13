function val = get(f, fieldname)
% function val = get(f, 'fieldname')
% function val = get(f, { 'fieldname1', 'fieldname2', ... })

%
% $Id: get.m,v 1.10 2011/11/08 08:38:35 patrick Exp $
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

warning('off','MATLAB:structOnObject');
f = struct(f);
warning('on','MATLAB:structOnObject');
if iscell(fieldname),
	val = cell(1,length(fieldname));
	for i=1:length(fieldname),
		val{i} = getfield(f, fieldname{i});
	end
elseif regexp(fieldname,'{.*}')
	ii = regexp(fieldname,'{.*}');
	name = fieldname([1:ii-1]);
	index = str2num(fieldname([ii+1:end-1]));
	val = getfield(f, name, {index});
	if length(val)==1,
		val = val{:};
	end
else
	val = getfield(f, fieldname);
end

