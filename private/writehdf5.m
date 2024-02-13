function writehdf5(filename,varargin) 
% function writehdf5(filename,varargin) 

%
% $Id: writehdf5.m,v 1.3 2014/06/09 12:30:08 patrick Exp $
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

% create fails if file exists
fcpl = H5P.create('H5P_FILE_CREATE');
fapl = H5P.create('H5P_FILE_ACCESS');
fid  = H5F.create(filename,'H5F_ACC_TRUNC',fcpl,fapl);

% pick up 1st SD variable
s = varargin{1};

% create global attribute version
space_id = H5S.create('H5S_SCALAR');
type_id  = H5T.copy('H5T_C_S1');
H5T.set_size(type_id,length(s.ver{1}));
acpl_id = H5P.create('H5P_ATTRIBUTE_CREATE');
attr_id = H5A.create(fid,'Version',type_id,space_id,acpl_id);
H5A.write(attr_id,type_id,s.ver{1});
H5A.close(attr_id);
H5S.close(space_id);

% create group for dimensions
plist = 'H5P_DEFAULT';
gid = H5G.create(fid,'/dims',plist,plist,plist);

for i=1:length(varargin), % for all variables
	s = varargin{i};
%	vartype = 'H5T_NATIVE_DOUBLE';
	vartype = 'H5T_NATIVE_FLOAT';
	rank = ndims(s.var);
	dims = size(s.var);
  % init variable
  space_id = H5S.create_simple(rank,dims,dims);
  type_id = H5T.copy(vartype);
  varset = H5D.create(fid,s.varname,type_id,space_id,plist);
	s.var = permute(s.var,[rank:-1:1]);
	H5D.write(varset,type_id,'H5S_ALL','H5S_ALL',plist,single(s.var));
	ref = zeros(8,rank);
  for j=1:rank, % for each dimension
    dimsize = length(s.dims{j});
    space_id = H5S.create_simple(1,dimsize, dimsize);
		dimtype = 'H5T_NATIVE_DOUBLE'; % dimensions are double
    type_id = H5T.copy(dimtype); 
		idim = j; % starting from first one
    if ~H5L.exists(gid,s.dimsname{idim},plist),
      % dimension does not exists, create it
      dimset = H5D.create(gid,s.dimsname{idim},type_id,space_id,plist);

      H5D.write(dimset,type_id,'H5S_ALL','H5S_ALL',plist,s.dims{j});
      H5D.close(dimset);
    end 
    % keep reference of dimensions for variable
    ref(:,j) = H5R.create(gid,s.dimsname{j},'H5R_OBJECT',-1);
  end

  % save references to dimensions in variable attribute dims_ref
  space_id = H5S.create('H5S_SIMPLE');
  H5S.set_extent_simple(space_id,1,rank,rank);
  type_id = H5T.copy('H5T_STD_REF_OBJ');
  attr_id = H5A.create(varset,'dims_ref',type_id,space_id,plist,plist);
  H5A.write(attr_id,type_id,uint8(ref));

  H5A.close(attr_id);
  H5T.close(type_id);
  H5D.close(varset);
  H5S.close(space_id);
end

H5G.close(gid);
H5F.close(fid);

