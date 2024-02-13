function field = readhdf4(field,filename,fieldname,subdim)
% function field = readhdf4(field,filename,fieldname,subdim)

%
% $Id: readhdf4.m,v 1.3 2015/06/04 14:58:43 patrick Exp $
%
% Copyright (c) 2012 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

import matlab.io.hdf4.*

try

sd_id = sd.start(filename,'read');
idx = sd.nameToIndex(sd_id,fieldname);
sds_id = sd.select(sd_id,idx);
[name,dimsizes,data_type,nattrs] = sd.getInfo(sds_id);
rank = length(dimsizes);
if field.verbose,
  fprintf(1,'Variable `%s'' has %d dimensions\n', name, rank); 
end;

if ~exist('subdim') | isempty(subdim),
	start  = zeros(size(dimsizes));
	stride = ones(size(dimsizes));
	edge   = dimsizes;
else
% MATLAB uses Fortran-style indexing while the HDF library uses C-style
% indexing. The order of the dimension identifiers will be reversed from
% what provided by subdim => need to reverse subdim
  subdim = fliplr(subdim);
	for i=1:length(subdim),
		if isempty(subdim{i})
			start(i)  = 0;
			stride(i) = 1;
			edge(i)   = dimsizes(i);
		else
			start(i) = subdim{i}(1)-1;
			if length(subdim{i})>1,
				stride(i) = subdim{i}(2)-subdim{i}(1);
			else
				stride(i) = 1;
			end
			edge(i) = length(subdim{i});
		end
	end
% need to reset subdim 
	subdim = fliplr(subdim);
end

if field.verbose > 1,
  fprintf(1,'start = %4d, stride = %4d, edge = %4d\n',[start;stride;edge])
end

var = sd.readData(sds_id,start,edge,stride);
if rank>1,
	field.var = double(permute(var,rank:-1:1));
else
	field.var = double(var);
end
field.varname = name2label(name);

for dim_number=0:rank-1, 
% MATLAB uses Fortran-style indexing while the HDF library uses C-style
% indexing. The order of the dimension identifiers retrieved with sd.getDimID
% will be reversed from what would be retrieved via the C API.
	dim_id = sd.getDimID(sds_id,rank-1-dim_number);
	vardim = sd.getDimScale(dim_id);
	field.dims{dim_number+1} = double(vardim);
	if exist('subdim') & ~isempty(subdim) & ~isempty(subdim{dim_number+1}),
		field.dims{dim_number+1} = field.dims{dim_number+1}(subdim{dim_number+1});
	end

	[name,count,data_type,nattrs] = sd.dimInfo(dim_id);
	if field.verbose, 
	  fprintf(1,'--> %4.d elements in dimension `%s''\n',count,name); 
	end
	field.dimsname{dim_number+1} = name2label(name);
end

sd.endAccess(sds_id);
sd.close(sd_id);

catch me

  rethrow(me)

end

end % function
