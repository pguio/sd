function label = name2label(name)
% function label = name2label(name)

%
% $Id: name2label.m,v 1.2 2012/11/08 17:31:56 patrick Exp $
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

if strncmp(name,'x-',2) | strncmp(name,'y-',2) | strncmp(name,'z-',2)
	name = name(1);
end

if strncmp(name,'vx-',3) | strncmp(name,'vy-',3) | strncmp(name,'vz-',3)
	name = name(1:2);
end

if strncmp(name,'k-',2) | strncmp(name,'t-',2) | strncmp(name,'f-',2)
	name = name(1);
end

switch lower(name)
	case 'potential', 
		label = '\phi';
	case 'density', 
		label = '\rho';
	case 'ex-field', 
		label = 'E_x';
	case 'ey-field', 
		label = 'E_y';
	case 'x-velocity', 
		label = 'u_x'; 
	case 'y-velocity', 
		label = 'u_y'; 
	case 'z-velocity', 
		label = 'u_z'; 
	case 'x-temperature', 
		label = 'T_x'; 
	case 'y-temperature', 
		label = 'T_y'; 
	case 'z-temperature', 
		label = 'T_z'; 
	case 'x-vx', 
		label = 'Phase space x-v_x'; 
	case 'x-vy', 
		label = 'Phase space x-v_y'; 
	case 'x-vz', 
		label = 'Phase space x-v_z'; 
	case 'y-vx', 
		label = 'Phase space y-v_x'; 
	case 'y-vy', 
		label = 'Phase space y-v_y'; 
	case 'y-vz', 
		label = 'Phase space y-v_z'; 
	case {'time', 'time-field', 'time-spectra'}, 
		label = '\tau';
	case 'xj', 
		label = 'x';
	case 'k',
		label = 'k';
	case 'ese', 
		label = 'ESE';
	case 'ke', 
		label = 'KE';
	case 'kee', 
		label = 'KEE';
	case 'kei', 
		label = 'KEI';
	case 'ej', 
		label = '|E|';
	case 'nj', 
		label = 'real(n)';
	case 'ek', 
		label = '|E|';
	case 'nk', 
		label = '|n|';
	case 'ek2', 
		label = '|E|^2';
	case 'nk2', 
		label = '|n|^2';
	case 'avEk2', 
		label = '<|E(k)|^2>';
	case 'avnk2', 
		label = '<|n(k)|^2>';
	case 'plasma', 
		label = 'k^2<|E(k,f)|^2>';
	case 'ion', 
		label = '<|n(k,f)|^2>';
	case 'frequency', 
		label = 'frq';
	case 'avskw2', 
		label = '<|N_e|^2>';
	otherwise, 
		label = name; %error('unknown field name');
end

end % function 
