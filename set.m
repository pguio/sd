function f = set(f, varargin)
% function f = set(f, 'fieldname1', 'value1', 'fieldname2', 'value2', ...)

%
% $Id: set.m,v 1.12 2011/11/08 08:34:51 patrick Exp $
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
if mod(length(varargin),2),
	error('wrong number of arguments');
end
n=fix(length(varargin)/2);
for i=1:n
  fieldname = varargin{2*i-1};
	val = varargin{2*i};
	if isfield(f, fieldname),
		f = setfield(f, fieldname, val);
	elseif regexp(fieldname,'{.*}'),
		ii = regexp(fieldname,'{.*}');
		name = fieldname([1:ii-1]);
		index = str2num(fieldname([ii+1:end-1]));
		f = setfield(f, name, {index}, {val});
	end
end
f = sd(f);

