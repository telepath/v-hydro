/*
Project:			3D printed hydroponics system
Repositiry:		https://github.com/telepath/v-hydro
File name:		nozzle.scad
Author:			Benjamin Richter
Email:			3dp@itrichter.de
License:			GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt
Version:			1.0
Release:			2014-10-14

Modules:
 nozzle(l=length,do=outerDiameter,di=innerDiameter,mw=minWallThickness,n1=bottomNozzleThinning,n2=topNozzleThinning)

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

length = 15;					//length of nozzle
outerDiameter = 6;			//outer diameter of nozzle wihtout ridges
innerDiameter = 4;			//inner diameter of nozzle
minWallThickness = 0.8;		//minimum thickness of nozzle end
bottomNozzleThinning = 1;	//amount to taper bottom nozzle inwards
topNozzleThinning = 1;		//amount to taper top nozzle inwards
hoseThickness = 2;

/* $fn=12; */

/* nozzle(l=16,do=8,di=5,n1=0.75,n2=-1);
nozzle_cap(); */

module nozzle(l=length,do=outerDiameter,di=innerDiameter,mw=minWallThickness,n1=bottomNozzleThinning,n2=topNozzleThinning){

wr = do/10;
//rw=0.5;
nr=floor((l*0.6)/(wr*4));
//nr = 0;	//set 0 for no ribs


	//bottom nozzle
	nozzleEnd(l=l,do=do,di=di,mw=mw,n1=n1);

	difference(){
		union(){
			//shaft
			translate([0,0,l/5])
				cylinder(h=l*0.6,r=do/2);

			//ribs
			if (nr > 0) for (i = [0:nr-1]){
				translate([0,0,l/5+i*wr*4])
					rib(l=wr*3,do=do,di=di,wr=wr);
			}
		}
		translate([0,0,-1])
			cylinder(h=l*2,r=di/2);
	}

	//top nozzle
	translate([0,0,l])
		rotate(180,[1,0,0])
			nozzleEnd(l=l,do=do,di=di,mw=mw,n1=n2);
}

module nozzleEnd(l=length,do=outerDiameter,di=innerDiameter,mw=minWallThickness,n1=bottomNozzleThinning){
//d1=min(di/2,do/2-n1-mw);
d1=di/2;

	difference(){
		cylinder(h=l/5,r2=do/2,r1=do/2-n1);
		translate([0,0,-0.01])
			cylinder(h=l/5+0.02,r2=di/2,r1=d1);
	}
}

module rib(l=length/5,do=outerDiameter,di=innerDiameter,wr=0){
	hull(){
		//lower part
		cylinder(h=l/2,r=do/2);

		//upper part
		translate([0,0,l-wr])
			torus(ra=do/2,rb=wr);
	}
}

module torus(ra,rb,){
	/* echo(ra,rb); */
	rotate_extrude(convexity = 10)
		translate([ra, 0, 0])
			circle(r=rb,$fn=8);
}

module nozzle_cap(di=outerDiameter*1.2+hoseThickness*2,do=-innerDiameter+outerDiameter*2.2+hoseThickness*2,l=length) {
	echo(str("di=", di),str("do=", do),str("l=",l));
	difference()
	{
		cylinder(d=do, h=l);
		translate([0, 0, -1]) {
			cylinder(d=di, h=l+2);
		}
		for (i=[0:1]) {
			translate([0, 0, l]) {
				rotate(90*i) {
					cube(size=[do-di, do, l], center=true);
				}
			}
		}
	}
}

//nozzle();
