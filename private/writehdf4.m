function writehdf4(filename,varargin) 
% function writehdf4(filename,varargin) 

%
% $Id: writehdf4.m,v 1.4 2017/03/16 15:53:48 patrick Exp $
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

import matlab.io.hdf4.*

%if ~exist(filename,'file'), % create fails if file exists
  sd_id = sd.start(filename,'create');
%else
%  sd_id = sd.start(filename,'write');
%end
s = varargin{1};
sd.setAttr(sd_id,'Version',s.ver{1});
for i=1:length(varargin)
	s = varargin{i};
%	type='double';
	type='float';
	rank = ndims(s.var);
	dimsizes = fliplr(size(s.var));
	sds_id = sd.create(sd_id,s.varname,type,dimsizes);
	for j=1:rank,
% MATLAB uses Fortran-style indexing while the HDF library uses C-style
% indexing. The order of the dimension identifiers retrieved with sd.getDimID
% will be reversed from what would be retrieved via the C API.
		dim_id = sd.getDimID(sds_id,rank-j);
		sd.setDimName(dim_id,s.dimsname{j});
		sd.setDimScale(dim_id,s.dims{j});
	end
	start = zeros(1,rank);
	stride = [];
	sd.writeData(sds_id, start, permute(single(s.var),[rank:-1:1]));
	sd.endAccess(sds_id);
end
sd.close(sd_id);


