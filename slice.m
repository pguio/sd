function h=slice(f,s,nrnc,clim,colorbarflag)
% function h=slice(f,s,nrnc,clim,colorbarflag)

%
% $Id: slice.m,v 1.12 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('clim','var') | isempty(clim),
  clim=[min(f.var(isfinite(f.var(:)))) max(f.var(isfinite(f.var(:))))];
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

V=f.var;
if length(f.dims) == 4,
T=f.dims{1};
i3d=[3,2,4];
nj=size(f.var,1);
else
T=[];
i3d=[2,1,3];
nj=1;
end

if ~exist('s','var') | (exist('s','var') & isempty(s)), 
	for i=1:3, 
		s{i}=mean(f.dims{i3d(i)}); 
	end; 
end

[Y,X,Z]=meshgrid(f.dims{i3d});


for i=1:nj,

	subplot(nr,nc,i+jstart), 
	switch length(f.dims)
	case 3
	 hh{i}=slice(Y,X,Z,squeeze(V(:,:,:)),s{:});
	title(sprintf('%s(%s,%s,%s)', f.varname, f.dimsname{sort(i3d)}))

	case 4
	hh{i}=slice(Y,X,Z,squeeze(V(j,:,:,:)),s{:});
	title(sprintf('%s(%s,%s,%s,%s=%s)', ...
		f.varname, f.dimsname{sort(i3d)}, f.dimsname{1}, dim2str(T(j),4)))
	end
	xlabel(f.dimsname{i3d(1)}); 
	ylabel(f.dimsname{i3d(2)}); 
	zlabel(f.dimsname{i3d(3)}); 

	axis ij;
	shading flat;
	set(gca,'clim',clim)

	if colorbarflag
		hc=colorbar;
	end
	j=j+1;
	drawnow
end

if nargout > 0,
	h=hh;
end

