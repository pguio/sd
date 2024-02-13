function y = fft2(x)
% function y = fft2(x)

%
% $Id: fft2.m,v 1.5 2012/11/08 14:18:41 patrick Exp $
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

y = x;
y.var = fftshift(fftshift(fft2(x.var),1),2);
[y.dims{1}, y.dimsname{1}] = convert(x.dims{1}, x.dimsname{1});
[y.dims{2}, y.dimsname{2}] = convert(x.dims{2}, x.dimsname{2});

y.varname = ['fft2 ' x.varname];

  
function [x,tt] = convert(x,tt)

switch(tt)
	case {'probes', 'k', 'x', 'y', 'z'}
		tt = 'k';
		mn = min(x);
		mx = max(x);
		n = length(x);
		x = 2*pi*[-n/2:n/2-1] / (mx-mn);
	case {'time', '\tau', 'time-vector'}
		tt = 'frq';
		mn = min(x);
		mx = max(x);
		n = length(x);
		x = [-n/2:n/2-1] / (mx-mn);
end


