function out = cat(dim,varargin)
% function cat(dim,a1,a2,a3,...)

%
% $Id: cat.m,v 1.5 2011/03/26 15:09:32 patrick Exp $
%
% Copyright (c) 2007-2011 Patrick Guio <patrick.guio@gmail.com>
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

out = sd;

out.var = varargin{1}.var;
out.varname = varargin{1}.varname;
out.dims = varargin{1}.dims;
out.dimsname = varargin{1}.dimsname;

for i=2:length(varargin),

	if strcmp(out.varname, varargin{i}.varname),
		out.var = cat(dim, out.var, varargin{i}.var);
	else
		error('SD variables have different name');
	end

	for d=1:length(out.dims),
		if d==dim,
			out.dims{d} = cat(2, out.dims{d}, varargin{i}.dims{d});
			diffs = diff(out.dims{d});
			if ~isempty(find(abs(diffs-diffs(1))> eps(single(1)))),
			  varargin{i-1}.dims{d}(end-1:end), varargin{i}.dims{d}(1:2)
				error('Dimension to concatenate is not a regular grid');
			end
		else
			if length(out.dims{d}) ~= length(varargin{i}.dims{d})
				error('SD dimension have different length');
			end
			if ~strcmp(out.dimsname{d}, varargin{i}.dimsname{d}),
				error('SD dimension have different name');
			end
		end
  end

end
