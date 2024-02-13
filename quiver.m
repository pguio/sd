function h=quiver(fx,fy,nrnc,s,linewidth)
% function h=quiver(fx,fy,nrnc,s,linewidth)

%
% $Id: quiver.m,v 1.11 2011/03/26 15:09:33 patrick Exp $
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

if ~exist('s','var') | isempty(s),
  s = 0;
end

if ~exist('linewidth','var') | isempty(linewidth),
  linewidth = 1.5;
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
if length(fx.dims)>2, nj=size(fx.var,1);
else, nj=1; end

for j=1:nj,
	subplot(nr,nc,j+jstart), 
	switch length(fx.dims),
		case 2, 
		  [X,Y]=meshgrid(fx.dims{1:2});
			U=fx.var';
			V=fy.var';
		  hh{j}=quiver(X,Y,U,V,s);
		case 3, 
			[X,Y]=meshgrid(fx.dims{2:3});
			U=squeeze(fx.var(j,:,:))';
			V=squeeze(fy.var(j,:,:))';
		  hh{j}=quiver(X,Y,U,V,s);
		case 4, idims=[];
			for i=2:4, 
				if length(fx.dims{i})~=1, idims=[idims, i]; end
			end
			[X,Y]=meshgrid(fx.dims{idims});
			U=squeeze(fx.var(j,:,:,:))';
			V=squeeze(fy.var(j,:,:,:))';
			hh{j}=quiver(X,Y,U,V,s);
	end
	set(hh{j},'LineWidth',linewidth)

	title(maketitle(fx,3,4,j))

	if floor((j+jstart-1)/nc)==nr-1, 
		switch length(fx.dims),
			case 2, xlabel(fx.dimsname{1});
			case 3, xlabel(fx.dimsname{2});
			case 4, xlabel(fx.dimsname{idims(1)});
		end
	else
		set(gca,'XTickLabel',[]);
	end
	if mod(j+jstart-1,nc)==0,
		switch length(fx.dims),
			case 2, ylabel(fx.dimsname{2});
			case 3, ylabel(fx.dimsname{3});
			case 4, ylabel(fx.dimsname{idims(2)});
		end
	else
		set(gca,'YTickLabel',[]);
	end
	axis xy
	axis tight
	drawnow
	j=j+1;
end

if nargout>0,
	h = hh;
end

