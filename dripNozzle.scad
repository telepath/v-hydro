/*
Project:			3D printed hydroponics system
Repositiry:		https://github.com/telepath/v-hydro
File name:		dripNozzle.scad
Requirements:	nozzle.scad, loop.scad, https://github.com/syvwlch/Thingiverse-Projects/tree/master/Threaded%20Library
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.2
Release:			2014-10-14
Update:			2015-02-18

*Changelog*
1.2
- exported hooks to new library

1.1
- added grip ridges

Modules:
 dripNozzle()
	creates the full drip nozzle with thread, hooks, and nozzle, parameters must be defined beforehand

 hookCap()
	creates an open screw cap with hooks, but without the nozzle part (for attaching a bottle as water tank below the planting bottles)

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

include <threaded-library/Thread_Library.scad>
include <lib/nozzle.scad>
include <lib/loop.scad>

$fn=32;
$fs=0.75;$fa=5;

// Lid

LidHeight=9;
WallThickness=3;
GripRidges = 8;
GripRidgesWidth = 4;

// Nozzle
length=7.5;							//length of nozzle
NozzleOuterDiameter = 6;		//outer diameter of nozzle wihtout ridges
NozzleInnerDiameter = 5;		//inner diameter of nozzle
minWallThickness = 0.8;			//minimum thickness of nozzle end
nozzleThinning = 0.5;			//amount to taper top nozzle inwards
bottomNozzleThinning = -0.5;	//amount to taper nozzle bottom inwards (outwards, in this case)


// Thread parameters - for standard plastic bottles

TotalHeight = 12;
ThreadOuterDiameter=27.5;
ThreadPitch=2.7;
ToothHeight=1.5;
ProfileRatio=0.4;
ThreadAngle=20;

// Slope
SlopeHeight=ThreadOuterDiameter/2;

// Hook
HookInnerDiameter=7.5;

module dripNozzle(){
	union(){
		cone_cap();
		translate([0,0,LidHeight-0.01])
			cleanVHooks(d=ThreadOuterDiameter,t=WallThickness,hi=HookInnerDiameter);
	}
}

module gripRidges(){
r=ThreadOuterDiameter/2+WallThickness;
alpha=360/GripRidges;
if(GripRidges!=0)
	for (i=[1:GripRidges]){
		translate([sin(alpha*i)*r,cos(alpha*i)*r,0])
			cylinder(h=LidHeight,r=GripRidgesWidth/2);
	}
}

module openScrewCap(){
	//Cap
	difference(){
		union(){
			cylinder(r=ThreadOuterDiameter/2+WallThickness,h=LidHeight);
			gripRidges();
		}
	translate([0,0,-ThreadPitch]) thread();
	cylinder(r=ThreadOuterDiameter/2, h=LidHeight+1);
	}
}

module hookCap(){
	openScrewCap();
	translate([0,0,LidHeight])
		cleanVHooks(d=ThreadOuterDiameter,t=WallThickness,hi=HookInnerDiameter);
}

module cone_cap(){

	openScrewCap();

	//slope
	translate([0,0,LidHeight]) difference(){
		cylinder(r1=ThreadOuterDiameter/2+WallThickness,r2=NozzleOuterDiameter/2-bottomNozzleThinning,h=SlopeHeight);
		cylinder(r1=ThreadOuterDiameter/2,r2=NozzleInnerDiameter/2,h=SlopeHeight);
	}

	//Nozzle
	translate([0,0,LidHeight+SlopeHeight+length])
		rotate(180,[1,0,0])
			nozzle(l=length,do=NozzleOuterDiameter,di=NozzleInnerDiameter,mw=minWallThickness,n1=nozzleThinning,n2=bottomNozzleThinning);
}

module thread(){

	translate([0,0,ThreadPitch])
		//trapezoidThread
		trapezoidThreadNegativeSpace
		(
			length=TotalHeight,
			pitch=ThreadPitch,
			pitchRadius=ThreadOuterDiameter/2,
			threadHeightToPitch=ToothHeight/ThreadPitch,
			profileRatio=ProfileRatio,
			threadAngle=ThreadAngle,
			clearance=0.1,
			backlash=0.1
		);
}

dripNozzle();
//cleanhooks();
//hookCap();
//gripRidges();
