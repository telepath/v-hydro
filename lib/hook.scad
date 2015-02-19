/*
Project:			3D printed hydroponics system
Repositiry:		https://github.com/telepath/v-hydro
File name:		hook.scad
Requirements:	none
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.1
Release:			2015-2-18

*Changelog*
1.1 Initial Release
- added horizontal hooks

1.0 Initial Release

Modules:
 vHook(hi=hookInnerDiameter,t=wallThickness)
	creates one vertical loop of the specified size to be attached to another model

 cleanVHooks(d=innerDiameter, t=wallThickness, hi=hookInnerDiameter)
	creates three vertical loops in circular arrangement to be attached to a pot or nozzle

 hHook(hi=hookInnerDiameter,t=wallThickness)
	creates one horizontal loop of the specified size to be attached to another model

 cleanHHooks(d=innerDiameter, t=wallThickness, hi=hookInnerDiameter)
	creates three horizontal loops in circular arrangement to be attached to a pot or nozzle

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

innerDiameter = 20;
cleanDiameter = innerDiameter;

hookInnerDiameter = 7.5;
wallThickness = 1.5;
borderThickness = wallThickness*2;

module cleanVHooks(d=innerDiameter, t=wallThickness, hi=hookInnerDiameter){
	h=hi+t*3;
	intersection(){
		difference(){
			vHooks(d=d, t=t,hi=hi);
			cylinder(r=d/2,h=h);
		}
		cylinder(r=d/2+t,h=h);
	}
}

module vHooks(d=innerDiameter, t=wallThickness,hi=hookInnerDiameter){
	translate([0,-d/2-t,0]) vHook(hi=hi,t=t);	
	rotate(120) translate([0,-d/2-t,0]) vHook(hi=hi,t=t);	
	rotate(240) translate([0,-d/2-t,0]) vHook(hi=hi,t=t);	
}

module vHook(hi=hookInnerDiameter,t=wallThickness){
	translate([0,0,(hi/2+t)]) rotate([-90,0,0])
		basehook(hi=hi,t=t*3,b=t*2);
}

module cleanHHooks(d=innerDiameter, d2=cleanDiameter, t=wallThickness, hi=hookInnerDiameter){
	h=t*2;
	difference(){
		hHooks(d=d, t=t,hi=hi);
		cylinder(r=d2/2,h=h);
	}
}

module hHooks(d=innerDiameter, t=wallThickness,hi=hookInnerDiameter){
	translate([0,d/2-t*2,0]) hHook(hi=hi,t=t);	
	rotate(120) translate([0,d/2-t*2,0]) hHook(hi=hi,t=t);	
	rotate(240) translate([0,d/2-t*2,0]) hHook(hi=hi,t=t);	
}

module hHook(hi=hookInnerDiameter,t=wallThickness){
	translate([0,hi/2+t*2,t])
		rotate(180,[1,0,0])
			basehook(hi=hi,t=t,b=t*2);
}

module basehook(hi=hookInnerDiameter,t=wallThickness,b=borderThickness){
	difference(){
		hull(){
			cylinder(r=(hi/2+b),h=t);
			translate([-(hi/2+b),0,0]) cube([hi+b*2,(hi/2+b),t]);
		}
		cylinder(r=hi/2,h=t);
	}
}
