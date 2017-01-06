include <B200mini_board.scad>;
include <misc_parts.scad>;

// Latest Changes: 
// - make screw larger, real size -> measured 
// - 3mm lightpipeCheck -> 2.8 
// - header height not right -> fixed 
// - sink pcb half in both case-parts? Yes
// - thin support for bridge between sma
// - 2x2 Lightpipes next to SMA and header -> nur SMA 
// - header-position seems to be off -> fixed und hole closed
// - outer line of cage added, thicker material
// - usb hole is badly positioned
// - offer a bit more material around the cutout

// TODO: 
// - add logo, USRP on Top?
// - make case asymmetrical? usb hole could be closed from below

// visualisation - config
explosion_distance = 16; // mm, for explosion-view
cutAtY = 1000; // ie. adcY, hdrY, fpgaY
renderTop  = 1;
renderBot  = 0;
renderUSRP = 0;
renderScrw = 0;
hqMode = 1;

if (hqMode) 
{
    $fn = 60;
}

// case main body
WallThi = 2.0;
caseLen = pcbLen+2*WallThi;
caseWid = pcbWid+2*WallThi;
caseHgt = 12.5;
caseX = pcbX;
caseY = pcbY;
caseZ = smaZ-0.7; // starting point

// inner body-holy
iHoleHgt = caseHgt - 2*WallThi;

// separation Cages 
csThi = 1.5; 
csHgt = iHoleHgt / 2 + 0.5;
csZ1 = caseZ + csHgt/2;
csZ2 = caseZ - csHgt/2;

csAWid = pcbWid+2; // biggest separation line from top to bottom
csAX = pcbX;
csAY = 29.5;

csBLen = csAY+1; // line between SMA
csBX = pcbX - 8.5;
csBY = csAY/2-0.5;

csCWid = 12.0 + csThi;    // Line Next to fpga
csCX   = pcbWid-csCWid/2+0.1;
csCY   = 47;

csDLen = 17.5 + csThi; // Line Next to fpga
csDX   = pcbWid - csCWid;
csDY   = (csAY + csCY) / 2;

// extra support for the Short Standoffs between the SMA-Connectors
csSLen = 5; 
csSX1 = csBX;
csSX2 = pcbX + 5.0;
csSY  = csSLen/2-1;

// screw-definition
screwLen = 10;

M3_screw_dia = 3.0; // mm, 2.9 measured
M3_head_dia   = 5.5;
M3_head_Hgt = 3.0;
M3_nut_dia   = 5.5;
M3_nut_Hgt = 2;

screwZ = caseZ - caseHgt/2 + M3_nut_Hgt - 0.5;

// screw Standoffs on top and bottom
ssoR   = 1;
ssoWid = 7.0 + ssoR; // == Len
ssoHgt = caseHgt - 1;

ssoX1 = 0 + ssoWid/2 - ssoR;
ssoX2 = pcbWid - ssoWid/2 + ssoR;
ssoY1 = 0 + ssoWid/2 - ssoR;
ssoY2 = pcbLen - ssoWid/2 + ssoR;


// screw hole fixture -> offer a bit more material around the cutout for screwhead and nut because the main standoffs must be small for not damaging components on the board
shfDia = 9.0;
shfHgt = 3.0;
shfZ1 = caseZ + caseHgt/2 - WallThi - shfHgt/2 + 0.2;
shfZ2 = caseZ - caseHgt/2 + WallThi + shfHgt/2 - 0.2;

// LED- hole for the lightpipe, 
// https://www.conrad.de/de/lichtleiter-zur-frontplatten-montage-mentor-12822000-planar-183506.html
ledDia = 2.8; 
ledX1 = pcbWid - 15.5;
ledY1 = pcbLen - 2;
ledZ = caseZ + caseHgt/2;

ledX2A = pcbX - 4.5;
ledX2B = pcbX + 9.5;
ledY2  = 2;


// text
textFont = "Liberation Sans:style=Bold"; 
textX1 = smaX1+1;
textX2 = smaX2;
textX3 = smaX3-1;
textY  = 4.7;
textZ1  = caseZ + caseHgt/2;
textZ2  = caseZ - caseHgt/2;


module textline(textline)
{
    translate([0,0,-0.5]) 
        rotate([0,0,00]) 
            linear_extrude(height = 1) 
                text(textline, font = textFont, size = 3.3, direction = "ltr", spacing = 1, halign = "center");
}

module screw_M3(length) 
{
    rotate([0,0,30]) translate([0,0,-M3_nut_Hgt/2])
    {
    translate([0,0,length+M3_head_Hgt/2]) cylinder(d=M3_head_dia, h=M3_head_Hgt, center=true);
    cylinder(d=M3_screw_dia, h=length+0.1);
    cylinder(d=M3_nut_dia*1/cos(180/6), h=M3_nut_Hgt, center=true, $fn=6);
    }
}

module screw_M3_neg(length) 
{
    mgn = 0.4;
    rotate([0,0,30]) translate([0,0,-M3_nut_Hgt/2])
    {
    translate([0,0,length+M3_head_Hgt/2]) cylinder(d=M3_head_dia+mgn, h=M3_head_Hgt, center=true);
    cylinder(d=M3_screw_dia+mgn, h=length+0.1);
    cylinder(d=M3_nut_dia*1/cos(180/6)+mgn, h=M3_nut_Hgt+mgn, center=true, $fn=6);
    }
}

module halfDome(dia, hgt)
{
    translate([0,0,-shfHgt/2]) 
      scale([shfDia,shfDia,2*shfHgt]) 
        difference()
    {
        sphere(d=1,center=true);
        translate([0,0,-1]) cube([2,2,2],center=true);
    }
}


module usrp_case()
{
    difference()
    {
        union() 
        {
            if (hqMode) 
            {
                translate([caseX,caseY,caseZ]) difference() 
                {
                    round_cuboid3(caseWid,caseLen,caseHgt,1);  // case HQ
                    round_cuboid(pcbWid,pcbLen,iHoleHgt,1);  // inner cutout
                }
            }
            else        
            {
                translate([caseX,caseY,caseZ]) difference() 
                {
                    cube([caseWid,caseLen,caseHgt],center=true);  // Case fast version
                    cube([pcbWid,pcbLen,iHoleHgt],center=true);  // inner cutout     
                }
            }
     
            // screw standoffs, both sides
            if (hqMode)
            {
                translate([ssoX1,ssoY1,caseZ]) round_cuboid(ssoWid,ssoWid,ssoHgt,ssoR);
                translate([ssoX2,ssoY1,caseZ]) round_cuboid(ssoWid,ssoWid,ssoHgt,ssoR);
                translate([ssoX1,ssoY2,caseZ]) round_cuboid(ssoWid,ssoWid,ssoHgt,ssoR);
                translate([ssoX2,ssoY2,caseZ]) round_cuboid(ssoWid,ssoWid,ssoHgt,ssoR);
            }
            else
            {
                translate([ssoX1,ssoY1,caseZ]) cube([ssoWid,ssoWid,ssoHgt],center=true);
                translate([ssoX2,ssoY1,caseZ]) cube([ssoWid,ssoWid,ssoHgt],center=true);
                translate([ssoX1,ssoY2,caseZ]) cube([ssoWid,ssoWid,ssoHgt],center=true);
                translate([ssoX2,ssoY2,caseZ]) cube([ssoWid,ssoWid,ssoHgt],center=true);  
            }
            
            // screw hole fixture
            translate([holeX1,holeY1,shfZ1]) rotate([180,0,0]) halfDome(shfDia,shfHgt);
            translate([holeX1,holeY2,shfZ1]) rotate([180,0,0]) halfDome(shfDia,shfHgt);
            translate([holeX2,holeY1,shfZ1]) rotate([180,0,0]) halfDome(shfDia,shfHgt);
            translate([holeX2,holeY2,shfZ1]) rotate([180,0,0]) halfDome(shfDia,shfHgt);
            translate([holeX1,holeY1,shfZ2]) halfDome(shfDia,shfHgt);
            translate([holeX1,holeY2,shfZ2]) halfDome(shfDia,shfHgt);
            translate([holeX2,holeY1,shfZ2]) halfDome(shfDia,shfHgt);
            translate([holeX2,holeY2,shfZ2]) halfDome(shfDia,shfHgt);
   
            // separation lines 1.5mm
            translate([csAX,csAY,csZ1]) cube([csAWid,csThi,csHgt],center=true);
            translate([csBX,csBY,csZ1]) cube([csThi,csBLen,csHgt],center=true);
            translate([csCX,csCY,csZ1]) cube([csCWid,csThi,csHgt],center=true);
            translate([csDX,csDY,csZ1]) round_cuboid(csThi,csDLen,csHgt,0.5);
            
            // cage outline 2.5mm
            csThi2 = 2.5;
            translate([pcbWid-csThi2/2,pcbY,csZ1]) cube([csThi2,pcbLen+1,csHgt],center=true); // long line
            translate([csThi2/2,csBY,csZ1])      cube([csThi2,csBLen+1,csHgt],center=true); // shorter one
            
            // extra support for the Short Standoffs between the SMA-Connectors
            translate([csSX2,csSY,csZ1]) round_cuboid(csThi,csSLen,csHgt,0.5);
            translate([csSX1,csSY,csZ2]) round_cuboid(csThi,csSLen,csHgt,0.5);
            translate([csSX2,csSY,csZ2]) round_cuboid(csThi,csSLen,csHgt,0.5);
            
            // FPGA + ADC Cooling Pads
            if (hqMode)
            {
                translate([fpgaX,fpgaY,csZ1])  round_cuboid(fpgaWid+1,fpgaWid+1,csHgt,1);
                translate([adcX,adcY,csZ1])    round_cuboid(adcWid+1,adcWid+1,csHgt,1);
            }
            else
            {
                translate([fpgaX,fpgaY,csZ1])  cube([fpgaWid+1,fpgaWid+1,csHgt],center=true);
                translate([adcX,adcY,csZ1])    cube([adcWid+1,adcWid+1,csHgt],center=true);
            } 
        }
             
        B200mini_neg(); 
        
        // space for screws and nuts
        translate([holeX1,holeY1,screwZ]) screw_M3_neg(screwLen);
        translate([holeX1,holeY2,screwZ]) screw_M3_neg(screwLen); 
        translate([holeX2,holeY1,screwZ]) screw_M3_neg(screwLen); 
        translate([holeX2,holeY2,screwZ]) screw_M3_neg(screwLen); 
        
        // LED cutout
        translate([ledX1,ledY1,ledZ]) cylinder(d=ledDia,h=5,center=true);

        translate([ledX2A,ledY2,ledZ]) cylinder(d=ledDia,h=5,center=true);
        translate([ledX2B,ledY2,ledZ]) cylinder(d=ledDia,h=5,center=true);

        // text for inputs
        if (hqMode)
        {
            translate([textX1,textY,textZ1]) rotate([0,0,00]) textline("REF");
            translate([textX2,textY,textZ1]) rotate([0,0,00]) textline("RX2");
            translate([textX3,textY,textZ1]) rotate([0,0,00]) textline("TRX");
        
            translate([textX2,0,textZ2]) rotate([0,180,0]) textline("USRP B205 MINI");
        }
    }
    
    if (renderScrw)
    {
        // render screws and nuts
        translate([holeX1,holeY1,screwZ]) screw_M3(screwLen);
        translate([holeX1,holeY2,screwZ]) screw_M3(screwLen); 
        translate([holeX2,holeY1,screwZ]) screw_M3(screwLen); 
        translate([holeX2,holeY2,screwZ]) screw_M3(screwLen); 
    }
}


module usrp_case_top()
{
    difference() {
        usrp_case(); 
        translate([caseX,caseY,caseZ-caseHgt/2]) cube([caseWid+2,caseLen+2,caseHgt],center=true);
    }
}

module usrp_case_bottom()
{
    difference() {
        usrp_case(); 
        translate([caseX,caseY,caseZ+caseHgt/2]) cube([caseWid+2,caseLen+2,caseHgt],center=true);
    }
}

// top level geometry
difference()
{
    union()
    {
        if (renderBot) translate([0,0,-explosion_distance]) usrp_case_bottom();
        if (renderUSRP) B200mini();
        if (renderTop) translate([0,0,+explosion_distance]) usrp_case_top();
    }
    translate([fpgaX,cutAtY+50,0]) cube([100,100,100],center=true);
}




