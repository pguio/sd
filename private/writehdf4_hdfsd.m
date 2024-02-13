function writehdf4_hdfsd(filename,varargin) 
% function writehdf4_hdfsd(filename,varargin) 

%
% $Id: writehdf4_hdfsd.m,v 1.2 2014/06/09 12:28:25 patrick Exp $
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

if ~exist(filename,'file'), % create fails if file exists
  sd_id = hdfsd('start',filename,'create');
else
  sd_id = hdfsd('start',filename,'write');
end
if sd_id == -1,
  error(['sd: problem to open file "' filename '"']);
end
s = varargin{1};
status = hdfsd('setattr',sd_id,'Version',s.ver{1});
for i=1:length(varargin)
	s = varargin{i};
%	type='double';
	type='float';
	rank = ndims(s.var);
	dimsizes = size(s.var);
	sds_id = hdfsd('create',sd_id,s.varname,type,rank,dimsizes);
  if sds_id == -1,
    error(['sd: problem to create field "' s.varname '"']);
  end
  for j=1:rank,
    dim_id = hdfsd('getdimid',sds_id,j-1);
    status = hdfsd('setdimname',dim_id,s.dimsname{j});
    if status ~= 0,
      error(['sd: problem to set dimname "' s.dimsname{j} '"']);
    end
    status = hdfsd('setdimscale',dim_id,s.dims{j});
    if status ~= 0,
      error(['sd: problem to set dimscale']);
    end
  end
  start = zeros(1,rank);
  stride = [];
  edge = dimsizes;
  % dimension permutation needed for read/write compatibility 
  s.var = permute(s.var,[rank:-1:1]);
  status = hdfsd('writedata',sds_id, start, stride, edge, single(s.var));
  if status ~= 0,
    error(['sd: problem to write data "' s.varname '"to file "' filename '"']);
  end
	hdfsd('endaccess',sds_id);
end
hdfsd('end',sd_id);

