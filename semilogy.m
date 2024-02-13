function h=semilogy(f,nrnc,ylim)
% function h=semilogy(f,nrnc,ylim)

%
% $Id: semilogy.m,v 1.9 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('nrnc','var'),	
	nrnc=[1 1];
end

if ~exist('ylim','var') | isempty(ylim),
  ylim=[min(f.var(isfinite(f.var(:)))) max(f.var(isfinite(f.var(:))))];
end


j=1;
nr=nrnc(1);
nc=nrnc(2);
if length(nrnc)>2, 
  jstart=nrnc(3)-1;
else
  jstart=0;
end;

if nargin>1
  subplot(nr,nc,j+jstart), 
end
hh=semilogy(f.dims{1}, f.var);
set(gca,'ylim',ylim);

title(maketitle(f,2));


if floor((j+jstart-1)/nc)==nr-1, 
	xlabel(f.dimsname{1});
else
	set(gca,'XTickLabel',[]);
end
if mod(j+jstart-1,nc)~=0,
	set(gca,'YTickLabel',[]);
end
axis xy
drawnow

if nargout > 0,
	h=hh;
end

