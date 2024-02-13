%
% CONSTRUCTOR FOR sd (scientific data) OBJECT
%
% The sd class is based on a structure with six fields
%
%   var      - a n-dimensional array
%   varname  - string for the name of 'var'
%   dims     - a n-cells containing axes for each dimension of var
%   dimsname - a n-cells containing name for each dimension of var
%   verbose  - verbosity level
%   ver      - version of the class/object
% 
% Calling Syntax:
%
%   v = sd               % returns object with empty fields
%
%   v = sd(sdOj)         % copy constructor
%
%   load SD variable fieldname from HDF filename
%   with optional specification of slice subdim
%   and average field from multiple files with different seeds,
%   and the optional different reduction function rfun,
%   and the optional format specification hdfver, amongst 
%   the following values:
%
%      -hdf4 
%      -hdf5
%      -hdfsd (obsolete hdf4 matlab function)
%      -netcdf
%      -cmat2netcdf
%
%   v = sd(filename,fieldname,[subdim],[seeds],[verbose],[rfun],[hdfver])
%     
%   v = sd(sdStruct)     % sdStruct is a structure with six described fields 

%
% $Id: sd.m,v 1.28 2015/11/12 16:36:06 patrick Exp $
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

classdef sd

  properties
    var;
    varname;
    dims;
    dimsname;
    verbose;
    ver;
  end

  methods

function field = sd(filename,fieldname,subdim,seeds,verbose,rfun,hdfver)

field.var = [];
field.varname = [];
field.dims = [];
field.dimsname = [];
field.verbose = false;
field.ver = {'$Revision: 1.28 $', '$Date: 2015/11/12 16:36:06 $'};

%field = class(field, 'sd');

if nargin == 0, % trivial constructor
	return
end

if nargin == 1, % copy constructor
	if isfield(filename, 'var'),
		field.var = filename.var;
	end
	if isfield(filename, 'varname'),
		field.varname = filename.varname;
	end
	if isfield(filename, 'dims'),
		field.dims = filename.dims;
	end
	if isfield(filename, 'dimsname'),
		field.dimsname = filename.dimsname;
	end
	if isfield(filename, 'verbose'),
		field.verbose = filename.verbose;
	end
	return
end

% more input arguments
if ~exist('subdim','var') || isempty(subdim),
	subdim = [];
end

if ~exist('verbose','var') || isempty(verbose),
	field.verbose = false;
elseif verbose,
  field.verbose = verbose;
end

% try to guess the file type
if exist('seeds','var') && ~isempty(seeds),
  fname = [filename num2str(seeds(1))];
else
  fname = filename;
end
if ~exist('hdfver','var') || isempty(hdfver),
  if ~isempty(findstr(fname,'.h5')) || exist([fname '.h5'],'file'),
    hdfver = '-hdf5';
  elseif ~isempty(findstr(fname,'.hdf')) || exist([fname '.hdf'],'file'),
    hdfver = '-hdf4';
  elseif ~isempty(findstr(fname,'.nc')) || exist([fname '.nc'],'file'),
	  hdfver = '-netcdf';
	else
    error(['Cannot determine file type or file not found. ' ...
		       'Recognised extensions:' char(10) ...
					 '  HDF5  : .h5' char(10) ...
					 '  HDF4  : .hdf' char(10) ...
					 '  NetCDF: .nc']);
  end
else
	if ~strcmp(hdfver,'-hdfsd') && ~strcmp(hdfver,'-hdf4') && ...
     ~strcmp(hdfver,'-hdf5') && ~strcmp(hdfver,'-netcdf') && ...
     ~strcmp(hdfver,'-cmat2netcdf'),
		 error(['hdfver should either be ' ...
            '-hdfsd, -hdf4, -hdf5, -netcdf or -cmat2netcdf']);
	end
end

if ~exist('seeds','var') || isempty(seeds),
	field=readone(field,filename,fieldname,subdim,hdfver);
else
	file = [filename num2str(seeds(1))];
	field = readone(field,file,fieldname,subdim,hdfver);

	if ~exist('rfun','var') || isempty(rfun),
	  % estimate basic average by default
    buf = zeros(size(field.var));	
		for i=1:length(seeds),
		  % build filename by concatenating seed number
			file = [filename num2str(seeds(i))];
			if field.verbose, fprintf(1,'Loading %s\n',file); end;
			f = readone(field,file,fieldname,subdim,hdfver);
			buf = buf + f.var;
	  end
	  field.var = buf/length(seeds);
	elseif isa(rfun, 'function_handle'),
		buf = zeros([length(seeds) size(field.var)]);
		for i=1:length(seeds),
		  file = [filename num2str(seeds(i))];
			if field.verbose, fprintf(1,'Loading %s\n',file); end;
				f = readone(field,file,fieldname,subdim,hdfver);
				buf(i,:) = f.var(:).';
		end
		% perform reduce function rfun
		[rfun, msg] = fcnchk(rfun);
		if ~isempty(msg) error(msg); end
		redbuf = rfun(buf);
		if numel(redbuf) ~= numel(field.var),
		  error(['function "' func2str(rfun) '" does not reduce correctly'])
		end
		field.var = reshape(redbuf, size(field.var));
	else
		error(['argument #6 (rfun) is not a function handle'])
	end

end 


function field = readone(field,filename,fieldname,subdim,hdfver)

switch hdfver,
  case '-hdf5',
	  if isempty(findstr(filename,'.hdf')) && isempty(findstr(filename,'.h5'))
		  filename=[filename '.h5'];
		end
    field = readhdf5(field,filename,fieldname,subdim);
  case '-hdf4',
	  if isempty(findstr(filename,'.hdf')),
		  filename=[filename '.hdf'];
		end
    field = readhdf4(field,filename,fieldname,subdim);
	case '-hdfsd',
	  if isempty(findstr(filename,'.hdf')),
		  filename=[filename '.hdf'];
		end
    field = readhdf4_hdfsd(field,filename,fieldname,subdim);
	case '-netcdf',
	  if isempty(findstr(filename,'.nc')),
		  filename=[filename '.nc'];
		end
    field = readnetcdf(field,filename,fieldname,subdim);
	case '-cmat2netcdf',
	  if isempty(findstr(filename,'.nc')),
		  filename=[filename '.nc'];
		end
    field = readcmat2netcdf(field,filename,fieldname,subdim);
end

end % function

end % sd constructor

end % methods

end % classdef
