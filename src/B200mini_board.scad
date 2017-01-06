//
// B200mini Case Model
// 

// center: upper left corner on top of the PCB

include <misc_parts.scad>;

$fn = 48;

// PCB of the usrp
pcbWid = 50.8 + 1; // mm + safetymargin / clearance
pcbLen = 73.8 + 1; // mm
pcbHgt = 1.6 + 0.0; // mm
pcbX = +pcbWid / 2;
pcbY = +pcbLen / 2;
pcbZ = -pcbHgt / 2;

// SMA connectors
smaDia = 6.3; // mm
smaLen = 14.5; // mm
smaInset = 5.5; // mm
smaX1 = pcbX - 14; 
smaX2 = pcbX;
smaX3 = pcbX + 14;
smaY  = smaInset - smaLen / 2;
smaZ  = 0.1;

// header, both evaluated together
hdrLen = 20.4; // mm
hdrWid = 5; // mm
hdrHgt = 8.5; // mm, datasheet
hdrInset = 5.2; // mm
hdrX = hdrWid/2;
hdrY = 65.6 - hdrLen/2;
hdrZ = pcbZ;

// usb connector
usbWid = 13; // mm
usbLen = 5.6; // mm
usbHgt = 2.9; // mm
usbInset = 4.0; // mm
usbX = pcbX;
usbY = pcbLen - usbInset + usbLen/2;
usbZ = usbHgt / 2 - 0.1;

// screw - holes for assembly
holeDia = 3.2; // mm
holeX1  = pcbX - 43.2/2;
holeX2  = pcbX + 43.2/2;
holeY1  = pcbY - 66.0/2;
holeY2  = pcbY + 66.0/2;

// reset component
rstWid = 6.5; // mm
rstLen = 3.5; // mm
rstHgt = 4.3; // mm
rstX    = 12.6;
rstY    = pcbLen - rstLen/2;
rstZ    = -0.2;

// Reset - Button itself
rstBWid = 4.0; 
rstBHgt = 2.5;

// milling tabs, case should offer a little space for it
mtbLen = 5.0;
mtbWid = 0.6;
mtbX1A = 0;
mtbX1B = pcbWid;
mtbY1A = pcbY - 14;
mtbY1B = pcbY + 14;

mtbX2A = pcbX - 17.4;
mtbX2B = pcbX + 17.4;
mtbY2  = pcbLen;

mtbX3A = pcbX - 7;
mtbX3B = pcbX + 7;
mtbY3  = 0;

// ICs - for cooling with heatPad and metalCase
heatPadHgt = 0.8;

fpgaHgt = 1.6;
fpgaWid = 19+1;
fpgaX   = (35+16)/2; // upper border to beginning and ending of IC
fpgaY   = (52 + 33)/2;

adcHgt  = 1.4;
adcWid  = 10+1;
adcX    = (31 + 21) /2; 
adcY    = (16 + 26)/2;


module B200mini() {
  
  difference() {
    union() {
      // PCB 
      translate([pcbX,pcbY,pcbZ])  cube([pcbWid,pcbLen,pcbHgt], center=true);
        
      // SMA-Connectors
      translate([smaX1,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia,h=smaLen,center=true);
      translate([smaX2,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia,h=smaLen,center=true);
      translate([smaX3,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia,h=smaLen,center=true);
      
      // Header
      translate([hdrX,hdrY,hdrZ])  cube([hdrWid,hdrLen,hdrHgt],center=true);
      
      // USB3 Connector  
      translate([usbX,usbY,usbZ])  rotate([90,0,0]) round_cuboid(usbWid,usbHgt,usbLen,0.5);
      
      // reset-button
      translate([rstX,rstY,rstZ])  cube([rstWid, rstLen, rstHgt], center=true);
      
        
      // ICs
      translate([fpgaX,fpgaY,fpgaHgt/2])  cube([fpgaWid,fpgaWid,fpgaHgt],center=true);
      translate([adcX,adcY,adcHgt/2])     cube([adcWid,adcWid,adcHgt],center=true);  
    }
    
    // Mounting-Holes
    translate([holeX1,holeY1,0]) cylinder(d=holeDia,h=10,center=true);
    translate([holeX1,holeY2,0]) cylinder(d=holeDia,h=10,center=true);
    translate([holeX2,holeY1,0]) cylinder(d=holeDia,h=10,center=true);
    translate([holeX2,holeY2,0]) cylinder(d=holeDia,h=10,center=true);
  }
}

// its a mockup with a little bit more clearance for substracting it from the case
module B200mini_neg() 
{
    // PCB 
    translate([pcbX,pcbY,pcbZ])  round_cuboid(pcbWid,pcbLen,pcbHgt,1);
       
    // SMA-Connectors
    translate([smaX1,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia+0.6,h=smaLen,center=true);
    translate([smaX2,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia+0.6,h=smaLen,center=true);
    translate([smaX3,smaY,smaZ]) rotate([90,0,0]) cylinder(d=smaDia+0.6,h=smaLen,center=true);
    
    // Header
    translate([hdrX,hdrY,hdrZ])  round_cuboid(hdrWid+1,hdrLen+2,hdrHgt+1.0,0.5);
    
    // USB3 Connector  
    translate([usbX,usbY,usbZ-0.4])  rotate([90,0,0]) round_cuboid(usbWid+0.3,usbHgt+0.6,usbLen+3,0.4);
    
    // reset-component
    translate([rstX,rstY,rstZ])  cube([rstWid, rstLen, rstHgt], center=true);

    // Reset cutout
    translate([rstX,rstY,rstZ]) rotate([90,0,0]) round_cuboid(rstBWid,rstBHgt,10,1);   

    // milling tabs
    translate([mtbX1A,mtbY1A,pcbZ]) round_cuboid(mtbWid,mtbLen,pcbHgt,mtbWid/2); 
    translate([mtbX1A,mtbY1B,pcbZ]) round_cuboid(mtbWid,mtbLen,pcbHgt,mtbWid/2); 
    translate([mtbX1B,mtbY1A,pcbZ]) round_cuboid(mtbWid,mtbLen,pcbHgt,mtbWid/2); 
    translate([mtbX1B,mtbY1B,pcbZ]) round_cuboid(mtbWid,mtbLen,pcbHgt,mtbWid/2); 

    translate([mtbX2A,mtbY2 ,pcbZ]) round_cuboid(mtbLen,mtbWid,pcbHgt,mtbWid/2); 
    translate([mtbX2B,mtbY2 ,pcbZ]) round_cuboid(mtbLen,mtbWid,pcbHgt,mtbWid/2); 
    translate([mtbX3A,mtbY3 ,pcbZ]) round_cuboid(mtbLen,mtbWid,pcbHgt,mtbWid/2); 
    translate([mtbX3B,mtbY3 ,pcbZ]) round_cuboid(mtbLen,mtbWid,pcbHgt,mtbWid/2); 
        
    // ICs
    translate([fpgaX,fpgaY,(fpgaHgt+heatPadHgt)/2])  cube([fpgaWid+1.5,fpgaWid+1.5,fpgaHgt+heatPadHgt+0.1],center=true);
    translate([adcX,adcY,(adcHgt+heatPadHgt)/2])     cube([adcWid+1.5,adcWid+1.5,adcHgt+heatPadHgt+0.1],center=true);  
    
    // Mounting-Holes
    translate([holeX1,holeY1,0]) cylinder(d=holeDia+0.2,h=20,center=true);
    translate([holeX1,holeY2,0]) cylinder(d=holeDia+0.2,h=20,center=true);
    translate([holeX2,holeY1,0]) cylinder(d=holeDia+0.2,h=20,center=true);
    translate([holeX2,holeY2,0]) cylinder(d=holeDia+0.2,h=20,center=true);
}

//B200mini_neg();
//B200mini();
