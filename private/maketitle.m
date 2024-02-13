function str=maketitle(f,dim,n,it)
% function str=maketitle(f,dim,n,it)

%
% $Id: maketitle.m,v 1.6 2011/03/26 15:10:50 patrick Exp $
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

if nargin<3 | isempty('n'),
  n = 4;
end

switch (dim)

	case 2,

	switch length(f.dims)
		case 1,
			str=sprintf('%s(%s)', f.varname, f.dimsname{1});
		case 2,
			str=sprintf('%s(%s,%s=%s)', f.varname, f.dimsname{1:2}, dim2str(f.dims{2},n));
	end

	case 3,

	switch length(f.dims)
		case 2,
			str=sprintf('%s(%s,%s)', f.varname, f.dimsname{1:2});
		case 3,
			if exist('it','var');
				str=sprintf('%s(%s,%s,%s=%s)', f.varname, f.dimsname{[2 3 1]}, ...
					dim2str(f.dims{1}(it),n));	
			else
				str=sprintf('%s(%s,%s,%s)', f.varname, f.dimsname{[2 3 1]});
			end
		case 4,
			for i=2:4,
				if length(f.dims{i})~=1,
					s{i-1} = sprintf('%s,', f.dimsname{i});
				else
					s{i-1} = sprintf('%s=%s', f.dimsname{i}, dim2str(f.dims{1},n))
				end
			end
			str=sprintf('%s(%s,%s,%s=%s)', f.varname, s{:}, dim2str(f.dims{1}(it),n));
	end


end


