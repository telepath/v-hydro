/*
Project:			3D printed hydroponics system
Repositiry:		https://github.com/telepath/v-hydro
File name:		connector.scad
Requirements:	nozzle.scad
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.0
Release:			2014-10-14

Modules:
 connector(l=length)
 airLiftNozzle(l=length)
 tConnector(l=length)
 xConnector(l=length)

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

length=12;					//length of the nozzle - connector will have double length
outerDiameter = 5.5;		//outer diameter of the connector/nozzle (plus nozzle ridges)
innerDiameter = 3.5;		//innter diameter of the connector/nozzle
minWallThickness = 0.8;	//thickness of the end of the nozzle
nozzleThinning = 0.5;	//how much the outer wall of the nozzle will pull inwards
numberOfOutlets = 3; //number of outlets for nConnector

module connector(l=length){
	//bottom
	nozzle(l=l,n1=nozzleThinning,n2=0);

	//top
	translate([0,0,l*2])
		rotate(180,[1,0,0])
			nozzle(l=l,n1=nozzleThinning,n2=0);
}

module airLiftNozzle(l=length){
	difference(){
		union(){
			//bottom nozzle
			nozzle(l=l,n1=nozzleThinning,n2=0);
			//top nozzle
			translate([0,0,l*2])
				rotate(180,[1,0,0])
					nozzle(l=l,n1=nozzleThinning,n2=0);

			//connection support
			translate([0,0,l*0.9])
				sphere(d=outerDiameter*1.5);
		}

		//side nozzle hole
		translate([0,-l*0.1,l*0.8])
			rotate(45,[1,0,0])
				translate([0,0,l*1.3])
					rotate(180,[1,0,0])
						nozzle(l=l*1.3,di=0,nr=0,n1=nozzleThinning,n2=1);

		//clear inner path
		translate([0,0,l/2])
			cylinder(r=innerDiameter/2,h=l);
	}

	//side nozzle
	translate([0,-l*0.1,l*0.8])
		rotate(45,[1,0,0])
			translate([0,0,l*1.3])
				rotate(180,[1,0,0])
					nozzle(l=l*1.3,n1=nozzleThinning,n2=1);

}

module tConnector(l=length){
	difference() {
		union() {
			difference(){
				union(){
					//bottom nozzle
					nozzle(l=l,n1=nozzleThinning,n2=0);
					//top nozzle
					translate([0,0,l*2])
						rotate(180,[1,0,0])
							nozzle(l=l,n1=nozzleThinning,n2=0);

					//connection support
					translate([0,0,l])
						sphere(d=outerDiameter*1.25);
				}

				//side nozzle hole
				translate([0,-1,l])
					rotate(90,[1,0,0])
						translate([0,0,l])
							rotate(180,[1,0,0])
								nozzle(l=l,di=0,nr=0,n1=nozzleThinning,n2=1);
			}

			//side nozzle
			translate([0,0,l])
				rotate(90,[1,0,0])
					translate([0,0,l])
						rotate(180,[1,0,0])
							nozzle(l=l,n1=nozzleThinning,n2=0);
		}

		//clear inner path
		translate([0,0,l/2])
			cylinder(r=innerDiameter/2,h=l);
	}
}

module nConnector(di=innerDiameter, do=outerDiameter, l=length, n=numberOfOutlets, n1=nozzleThinning){
	difference() {
		union() {
			rotate([0, 90, 0]) {
				sphere(d=do*1.25);
			}
			for (i=[1:n]) {
				rotate([360/n*i,0,0]) {
					translate([0, 0, -l]) {
						nozzle(l=l,do=do,di=di,n1=n1,n2=0);
					}
				}
			}
		}
		for (i=[1:n]) {
			rotate([360/n*i,180,0]) {
				cylinder(d=di, h=length);
			}
		}
	}
}

module xConnector(l=length){
	nConnector(l=l,n=4);
}

module printable(do=outerDiameter){
	difference(){
		translate([0,0,do/2])
			rotate(90,[0,1,0])
				children();
		translate([-length*5,-length*5,-do*2])
			cube([length*10,length*10,do*2]);
	}
}

/* airlift nozzle */
translate([0,-length*2,0])
printable()
	airLiftNozzle(length);

/* connector */
translate([length*3,0,0])
printable()
	connector();

/* x-connector */
translate([0,length*2,0])
printable()
	xConnector();

/* t-connector */
printable()
	tConnector();

/* nConnector(l=length,n=7); */
