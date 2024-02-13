function h=imagesc(f,nrnc,clim,colorbarflag)
% function h=imagesc(f,nrnc,clim,colorbarflag)

%
% $Id: imagesc.m,v 1.11 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('nrnc','var') | isempty(nrnc),
  nrnc=[1 1];
end

if ~exist('clim','var') | isempty(clim),
  ii = isfinite(f(:));
	clim=[min(f.var(ii)) max(f.var(ii))];
end

if ~exist('colorbarflag','var') | isempty(colorbarflag),
  colorbarflag = 1;
end

j=1;
nr=nrnc(1);
nc=nrnc(2);
if length(nrnc)>2, 
  jstart=nrnc(3)-1;
else
  jstart=0;
end;

% time is always first dimension
if length(f.dims)>2, nj=size(f.var,1);
else, nj=1; end

for j=1:nj,
	if nargin > 1,
		subplot(nr,nc,j+jstart), 
	end

	switch length(f.dims),
		case 2, hh(j)=imagesc(f.dims{1:2}, f.var', clim);
		case 3, hh(j)=imagesc(f.dims{2:3}, squeeze(f.var(j,:,:))', clim);
		case 4, idims=[];
			for i=2:4, 
				if length(f.dims{i})~=1, idims=[idims, i]; end
			end
			hh(j)=imagesc(f.dims{idims}, squeeze(f.var(j,:,:,:))', clim);
	end

	title(maketitle(f,3,4,j))

	if floor((j+jstart-1)/nc)==nr-1, 
		switch length(f.dims),
			case 2, xlabel(f.dimsname{1});
			case 3, xlabel(f.dimsname{2});
			case 4, xlabel(f.dimsname{idims(1)});
		end
	else
		set(gca,'XTickLabel',[]);
	end
	if mod(j+jstart-1,nc)==0,
		switch length(f.dims),
			case 2, ylabel(f.dimsname{2});
			case 3, ylabel(f.dimsname{3});
			case 4, ylabel(f.dimsname{idims(2)});
		end
	else
		set(gca,'YTickLabel',[]);
	end
	axis xy
	if colorbarflag,
		hc=colorbar;
		if mod(j+jstart-1,nc)~=nc-1 & size(f.var,3)>1,
			set(hc,'YTickLabel',[]);
		end
	end
	drawnow
	j=j+1;
end

if nargout>0,
	h = hh;
end

