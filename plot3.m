function h=plot3(f,nrnc,limits,m,clim,colorbarflag)
% function h=plot3(f,nrnc,limits,m,clim,colorbarflag)

%
% $Id: plot3.m,v 1.11 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('m','var') | (exist('m','var') & isempty(m)),
	m=mean(f.var(:));
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
T=f.dims{1};
i3d=[3,2,4];

[Y,X,Z]=meshgrid(f.dims{i3d});

for i=1:size(f.var,1),

	subplot(nr,nc,i+jstart), 

	if exist('limits') & ~isempty(limits),	
		[Y,X,Z,F] = subvolume(f.dims{i3d},squeeze(V(j,:,:,:)),limits);
	else
		F=squeeze(V(j,:,:,:));
	end
	p=patch(isosurface(Y,X,Z,F,m), 'FaceColor','red','EdgeColor','none');
	%isonormals(Y,X,Z,F, m);
	%set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
	p2=patch(isocaps(Y,X,Z,F,m), 'FaceColor','interp','EdgeColor','none');
	view(3); 
	axis ij
	axis vis3d tight;  
	daspect([1 1 1])
	colormap(jet)
	camlight
	lighting gouraud

	if exist('clim','var') & ~isempty(clim),
		set(gca,'clim',clim)
	end
	if colorbarflag,
		colorbar('h');
	end

	set(gca,'xlim',[min(Y(:)) max(Y(:))]);
	set(gca,'ylim',[min(X(:)) max(X(:))]);
	set(gca,'zlim',[min(Z(:)) max(Z(:))]);

	xlabel(f.dimsname{sort(i3d(1))})
	ylabel(f.dimsname{sort(i3d(2))})
	zlabel(f.dimsname{sort(i3d(3))})
	title(sprintf('%s(%s,%s,%s,%s=%s)', ...
		f.varname, f.dimsname{sort(i3d)}, f.dimsname{1}, dim2str(T(j),4)))

	j=j+1;
	drawnow
end

