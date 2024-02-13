function y=yule_kendall(varargin)
% Yule-Kendall Index: compares the distance between the median and
% each of the two quartiles.
% function y=yule_kendall(x)
% function y=yule_kendall(x,dim)
% function y=yule_kendall(x1,x2,...)

%
% $Id: yule_kendall.m,v 1.10 2011/03/26 15:09:33 patrick Exp $
%
% Copyright (c) 2001-2011 Patrick Guio <patrick.guio@gmail.com>
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

if nargin==1,
	x = varargin{1};
elseif nargin==2 & isnumeric(varargin{2}),
	x = varargin{1};
	dim = varargin{2};
else

	y = varargin{1};
	s = size(y.var);
	tmp = zeros([nargin, s)]);
	for i=1:nargin,
		tmp(i, :) = varargin{i}.var(:);
	end
	y.var = reshape(YuleKendall(tmp, 1), s));
	return
end

if ~exist('dim'), % assume over all dimensions
	y = YuleKendall(find(isfinite(x.var(:))),1);
	return;
end;

y=sd;
y.var = YuleKendall(x.var,dim);
% trick to squeeze only the reduced dimension
dims = size(x.var);
dims(dim) = [];
if length(dims)>1,
	y.var = reshape(y.var,dims);
end
y.varname = x.varname;
j=1;
for i=1:length(x.dims)
	if i~=dim,
		y.dims{j} = x.dims{i};
		y.dimsname{j} = x.dimsname{i};
		j = j+1;
	end
end

function y = YuleKendall(x,d)

y = quantile(x,0.25,d)-2*quantile(x,0.5,d)+quantile(x,0.75,d))./iqr(x,d);


