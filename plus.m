function c=plus(a,b)
% function c=plus(a,b)

%
% $Id: plus.m,v 1.5 2011/03/26 15:09:33 patrick Exp $
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

c=sd;

if isfloat(a),
  c = b;
  c.var = a + b.var;
	c.varname = [num2str(a) '+' b.varname];
  return;
end

if isfloat(b),
  c = a;
  c.var = a.var + b;
  c.varname = [a.varname '+' num2str(b)];
  return;
end

if length(a.dims)==length(b.dims),
	for i=1:length(a.dims)
		if any(size(a.dims{i})==size(b.dims{i})) & a.dims{i}==b.dims{i},
			c.dims{i}=a.dims{i};
			c.dimsname{i}=a.dimsname{i};
		else
			error(sprintf('dims{%d} not identical', i));
		end
	end
end

if any(size(a.var)==size(b.var)),
	c.var = a.var+b.var;
	c.varname = [a.varname '+' b.varname];
else
	error('var not same size');
end


