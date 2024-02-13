function y=fft(x,n,dim)
% function y=fft(x,n,dim)

%
% $Id: fft.m,v 1.10 2015/04/20 14:48:48 patrick Exp $
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

if ~exist('n','var'),
  n = [];
end
if ~exist('dim','var'), % find the first non-singleton dimension
  dim = find(size(x) ~= 1);
	dim = dim(1);
end
y=x;
%if length(x.dims)>1,
%for j=1:length(x.dims{2}),
%	y.var(:,j) = fftshift(fft(x.var(:,j)));
%end
%else
% y.var = fftshift(fft(x.var));
%end
y.var = fft(x.var,n,dim);
[y.dims{dim}, y.dimsname{dim}] = convert(x.dims{dim}, x.dimsname{dim});

y.varname = ['fft ' x.varname];

%ii=find(y.dims{1}==0)
%y.var(ii-1:ii+1)
  
function [x,tt]=convert(x,tt)

switch(tt)
	case {'probes', 'k', 'x', 'y', 'z'}
		tt = 'k-wave';
		mn = min(x);
		mx = max(x);
		n = length(x);
%		x = 2*pi*[-n/2:n/2-1] / (mx-mn);
		N=2*floor(n/2);
		x = 2*pi*[floor(-(n-1)/2):floor((n-1)/2)] / (mx-mn) *((n-1)/N);
	case {'time', '\tau', 'time-vector'}
		tt = 'frq';
		mn = min(x);
		mx = max(x);
		n = length(x);
		N=2*floor(n/2);
%		[1/2/(x(2)-x(1)) 1/(x(2)-x(1))/N (mx-mn)/(n-1)]
		x = [floor(-(n-1)/2):floor((n-1)/2)] / (mx-mn) * ((n-1)/N);
%		floor(-(n-1)/2):floor((n-1)/2)
%		[min(x), max(x)]
end


