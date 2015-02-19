/*
Project:			3D printed hydroponics system
File name:		hook.scad
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.1
Release:			2014-10-14
Update:			2014-11-15

Changelog:
1.1
- drip nose added

Modules:
 assembly(l=length)
	creates the complete assembly with two hook connected by a shaft. Parameters must be defined beforehand.

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

length = 100;			//lenght from one hook center to other
wallThickness = 4;	//thickness of the hook
innerRadius = 5;		//inner radius of the hook

r = 1.5;					//rounding of edges

/********************/

hyp=innerRadius+r;
a=45;
ak=cos(a)*hyp;
gk=sin(a)*hyp;


module hook(){
	minkowski()
	{
		sphere(r,$fn=6);
		union() { difference(){
			translate([0,0,r])
				cylinder(r=innerRadius+wallThickness-r,h=wallThickness-r*2);
			translate([0,0,r])
				cylinder(r=innerRadius+r,h=wallThickness-r*2);
			rotate(-45)
				translate([-r,0,0])
					cube([innerRadius+wallThickness*2,innerRadius+wallThickness*2,wallThickness*2]);
		}
		translate([-ak-wallThickness+r,-gk,r])
			cylinder(h=wallThickness-r*2,r=wallThickness/2-r,$fn=6);	}
	}
}

module shaft(l=length){
	slength=l-ak*2;
	sthickness=wallThickness-r*2;

	minkowski()
	{
		sphere(r);
		translate([slength/2+ak,-(gk),r+sthickness/2])
			cube([slength,sthickness,sthickness],center=true);
	}
}

module assembly(l=length){
	hook(l);
	shaft(l);
	translate([l,-gk*2,0])
		rotate(180,[0,0,1])
			hook(l);
}

assembly(l=length);