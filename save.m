function save(filename,varargin) 
% function save filename s1 s2 ... sn [hfdver]
%
%   save SD variables s1, s2, ... , sn  in filename.
%
%   The format of filename can be changed using the optional
%   format specification hdfver, amongst the following values:
%
%      -hdf4 
%      -hdf5
%      -hdfsd (obsolete hdf4 matlab function)
%      -netcdf
%      -cmat2netcdf

%
% example:
%
% v1 = sd;
% v1 = set(v1,'var',rand(20,20),'varname','rnd1','dims',{1:20;1:20},'dimsname',{'x','y'});
% v2 = sd;
% v2 = set(v2,'var',rand(20,20),'varname','rnd2','dims',{1:20;1:20},'dimsname',{'x','y'});
% save('v.hdf',v1,v2);
%
% clear all
% v1=sd('v.hdf','rnd1');
% v2=sd('v.hdf','rnd2');
% imagesc(sqrt(v1.*v2));
%

%
% $Id: save.m,v 1.11 2015/04/20 14:43:58 patrick Exp $
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

hdfver = '-hdf5';

if ischar(varargin{end}),
  if strcmp(varargin{end},'-hdfsd') | strcmp(varargin{end},'-hdf4') | ...
     strcmp(varargin{end},'-hdf5') | strcmp(varargin{end},'-netcdf'),
	  hdfver = varargin{end};
		varargin = { varargin{1:end-1} };
  end
end

switch hdfver,
  case '-hdf5',
    if ~findstr(filename,'.h5') | ~findstr(filename,'.hdf'),
      filename = [filename '.h5'];
		end
    writehdf5(filename,varargin{:});
	case '-hdf4',
    if ~findstr(filename,'.hdf'),
      filename = [filename '.hdf'];
		end
	  writehdf4(filename,varargin{:});
	case '-hdfsd',
    if ~findstr(filename,'.hdf'),
      filename = [filename '.hdf'];
		end
	  writehdf4_hdfsd(filename,varargin{:});
	case '-netcdf',
    if ~findstr(filename,'.nc'),
      filename = [filename '.nc'];
		end
	  writenetcdf(filename,varargin{:});
end

return

% create fails if file exists
sd_id=hdfsd('start',filename,'create');
s = varargin{1};
status = hdfsd('setattr',sd_id,'Version',s.ver{1});
for i=1:length(varargin)
	s = varargin{i};
%	type='double';
	type='float';
	rank = ndims(s.var);
	dimsizes = fliplr(size(s.var));
	sds_id = hdfsd('create',sd_id,s.varname,type,rank,dimsizes);
	for j=1:rank,
		dim_id = hdfsd('getdimid',sds_id,j-1);
		status = hdfsd('setdimname',dim_id,s.dimsname{rank+1-j});
		status = hdfsd('setdimscale',dim_id,s.dims{rank+1-j});
	end
	start = zeros(1,rank);
	stride = [];
	edge = dimsizes;
	status = hdfsd('writedata',sds_id, start, stride, edge, single(s.var));
	hdfsd('endaccess',sds_id);
end
hdfsd('end',sd_id);


