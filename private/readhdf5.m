function field = readhdf5(field,filename,fieldname,subdim)
% function field = readhdf5(field,filename,fieldname,subdim)

%
% $Id: readhdf5.m,v 1.1 2012/11/08 14:20:47 patrick Exp $
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

fid = H5F.open(filename,'H5F_ACC_RDONLY','H5P_DEFAULT');

dset_id = H5D.open(fid,['/' fieldname]);

space_id = H5D.get_space(dset_id);
[rank,dimsizes] = H5S.get_simple_extent_dims(space_id);

name = fieldname;
if field.verbose, 
  fprintf(1,'Variable `%s'' has %d dimensions\n', name, rank); 
end;


if ~exist('subdim') | isempty(subdim),
	start  = zeros(size(dimsizes));
	stride = ones(size(dimsizes));
	edge   = dimsizes;
else
	for i=1:length(subdim),
		if isempty(subdim{i})
			start(i)    = 0;
			stride(i)   = 1;
			edge(i)     = dimsizes(i);
		else
			start(i)    = subdim{i}(1)-1;
			if length(subdim{i})>1,
				stride(i) = subdim{i}(2)-subdim{i}(1);
			else
				stride(i) = 1;
			end
			edge(i) = length(subdim{i});
		end
	end
end

%fprintf(1,'start=%d stride=%d edge=%d\n',[start;stride;edge])

mem_id = H5S.create_simple(rank,edge,[]);
%H5S.select_hyperslab(space_id,'H5S_SELECT_SET',start,[],[],edge);
H5S.select_hyperslab(space_id,'H5S_SELECT_SET',start,[],edge,[]);
var = H5D.read(dset_id,'H5ML_DEFAULT',mem_id,space_id,'H5P_DEFAULT');

if 0 & status~=0,
	error(['sd: problem reading variable "' fieldname '"']);
end

if rank>1,
	field.var = double(permute(var,rank:-1:1));
else
	field.var = double(var);
end
field.varname = name2label(name);

attr_id = H5A.open(dset_id,'dims_ref','H5P_DEFAULT');
dims_ref = H5A.read(attr_id);

for dim=1:rank,
  deref_dset_id = H5R.dereference(dset_id,'H5R_OBJECT',dims_ref(:,dim));  
	deref_space_id = H5D.get_space(deref_dset_id);
  vardim = H5D.read(deref_dset_id)'; % transpose for compatibility with hdf4
	field.dims{dim} = double(vardim);
	if exist('subdim') & ~isempty(subdim) & ~isempty(subdim{dim}),
	  field.dims{dim} = field.dims{dim}(subdim{dim});
	end
	[~,count] = H5S.get_simple_extent_dims(deref_space_id);
  name = H5R.get_name(dset_id,'H5R_OBJECT',dims_ref(:,dim));
	name = name(7:end);
	if field.verbose,
	  fprintf(1,'--> %4.d elements in dimension `%s''\n', count,name);
	end
	field.dimsname{dim} = name2label(name);
end

H5A.close(attr_id);
H5S.close(mem_id);
H5S.close(space_id);
H5D.close(dset_id);
H5F.close(fid);

end % function
