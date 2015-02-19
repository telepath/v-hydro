/*
Project:			3D printed hydroponics system
File name:		hook.scad
Requirements:	none
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.0
Release:			2015-2-18

*Changelog*
1.0 Initial Release

Modules:
 pot()
	creates one pot with drip nozzle and top and bottom hooks with predifines parameters

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

include <lib/nozzle.scad>
include <lib/hook.scad>

$fn=32;

/* Pot */
r1 = 55/2;
r2 = 42/2;
r3 = 5/2;
h1 = 50;
h2 = 15;
wallThickness = 2;

// Nozzle
nozzleLength=7.5;							//length of nozzle
nozzleInnerDiameter = 5;		//inner diameter of nozzle
nozzleOuterDiameter = 7;		//outer diameter of nozzle wihtout ridges
minWallThickness = 0.8;			//minimum thickness of nozzle end
nozzleThinning = 0.5;			//amount to taper top nozzle inwards
bNozzleThinning = -1;	//amount to taper nozzle bottom inwards (outwards, in this case)

// Hook
hookInnerDiameter=7.5;

rotate(180,[1,0,0])	//printable
pot();

%translate([0,0,h1+h2+50]) pot(); //second pot for demo

module pot(){
	translate([0,0,h1-wallThickness])
		cleanHHooks(d=r1*2+wallThickness*2, d2=r1*2, t=wallThickness, hi=hookInnerDiameter);

	potHull(r1=r2,r2=r1,t=wallThickness,h=h1);

	translate([0,0,-h2])
		potHull(r1=r3,r2=r2,t=wallThickness,h=h2);

	rotate(180, [1,0,0])
		cleanVHooks(d=r2*2, t=wallThickness, hi=hookInnerDiameter);

	translate([0,0,-h2-nozzleLength]) 
//		rotate(180,[1,0,0])
			nozzle(l=nozzleLength,do=nozzleOuterDiameter,di=nozzleInnerDiameter,mw=minWallThickness,n1=nozzleThinning,n2=bNozzleThinning);
}

module potHull(r1=r1,r2=r2,t=wallThickness){
	difference(){
		cylinder(r1=r1+t,r2=r2+t,h=h);
		cylinder(r1=r1,r2=r2,h=h);
	}
}
