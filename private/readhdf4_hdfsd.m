function field = readhdf4_hdfsd(field,filename,fieldname,subdim)
% function field = readhdf4_hdfsd(field,filename,fieldname,subdim)

%
% $Id: readhdf4_hdfsd.m,v 1.2 2014/06/09 12:18:54 patrick Exp $
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


sd_id = hdfsd('start',filename,'rdonly');
if sd_id == -1,
  error(['sd: problem to open file "' filename '"']);
end

idx = hdfsd('nametoindex',sd_id',fieldname);
sds_id = hdfsd('select',sd_id,idx);

[name,rank,dimsizes,data_type,nattrs,status] = hdfsd('getinfo',sds_id);
if status ~= 0,
	error(['sd: problem to get info on variable "' fieldname '"']);
end
if field.verbose, 
  fprintf(1,'Variable `%s'' has %d dimensions\n', name, rank); 
end;

if ~exist('subdim') | isempty(subdim),
	start=zeros(size(dimsizes));
	stride=ones(size(dimsizes));
	edge=dimsizes;
else
	for i=1:length(subdim),
		if isempty(subdim{i})
			start(i)=0;
			stride(i)=1;
			edge(i)=dimsizes(i);
		else
			start(i)=subdim{i}(1)-1;
			if length(subdim{i})>1,
				stride(i)=subdim{i}(2)-subdim{i}(1);
			else
				stride(i)=1;
			end
			edge(i)=length(subdim{i});
		end
	end
end

%fprintf(1,'start=%d stride=%d edge=%d\n',[start;stride;edge])

[var,status]=hdfsd('readdata',sds_id,start,stride,edge);
if status ~= 0,
	error(['sd: problem to read variable "' fieldname '"']);
end
if rank>1,
	field.var=double(permute(var,rank:-1:1));
else
	field.var=double(var);
end
field.varname = name2label(name);

for dim_number=0:rank-1,
	dim_id = hdfsd('getdimid',sds_id,dim_number);
	[vardim,status]=hdfsd('getdimscale',dim_id);
	field.dims{dim_number+1}=double(vardim);
	if exist('subdim') & ~isempty(subdim) & ~isempty(subdim{dim_number+1}),
		field.dims{dim_number+1}=field.dims{dim_number+1}(subdim{dim_number+1});
	end

	[name,count,data_type,nattrs,status] = hdfsd('diminfo',dim_id);
	if field.verbose, 
	  fprintf(1,'--> %4.d elements in dimension `%s''\n', count,name); 
	end
	field.dimsname{dim_number+1} = name2label(name);
end

hdfsd('endaccess',sds_id);
hdfsd('end',sd_id);

end % function
