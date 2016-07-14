LevelHeight = 20;
HexSize = 32;

//hexagon blatantly borrowed from
//http://svn.clifford.at/openscad/trunk/libraries/shapes.scad
// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}

//Make a single hex tile. 
module hex_tile(level)
{
    translate([0,0,(level*LevelHeight-1)/2])
    {    
        difference()
        {
            union()
            {
                hexagon(HexSize, (level*LevelHeight-1) );
                translate([0,0,1])
                    hexagon(HexSize-2, (level*LevelHeight));
            }
            translate([0,0,-2])
                hexagon(HexSize-1, ((level*LevelHeight)-3));
        }
    }
}

//create a 2 tile hex set similar to used in heroscape. 
module dual_hex_tile(level1,level2=0)
{
    translate([0,-HexSize/2,0])
    {
        hex_tile(level1);
        if(level2==0)
            translate([0,HexSize,0])hex_tile(level1);
        else
            translate([0,HexSize,0])hex_tile(level2);
    }
}

//create a 3 tile hex set similar to used in heroscape. 
module tri_hex_tile(level1,level2=0,level3=0)
{
    translate([-2*HexSize/sqrt(3)*.25,0,0])
    {
        if(level2==0)
            dual_hex_tile(level1);
        else
            dual_hex_tile(level1,level2);
        if(level3==0)
            translate([(2*HexSize/sqrt(3))*.75,0,0])hex_tile(level1);
        else
            translate([(2*HexSize/sqrt(3))*.75,0,0])hex_tile(level3);
    }
}

//create a 8 tile hex set similar to used in heroscape. 
module oct_hex_tile(level1,level2=0,level3=0,level4=0,level5=0,level6=0,level7=0,level8=0)
{
   hex_tile(level1);
   if(level2==0)
       translate([0,HexSize,0])hex_tile(level1);
   else
       translate([0,HexSize,0])hex_tile(level2);
   if(level3==0)
       translate([0,-HexSize,0])hex_tile(level1);
   else
       translate([0,-HexSize,0])hex_tile(level3);
   if(level4==0)
       translate([0,HexSize,0])hex_tile(level1);
   else
       translate([0,HexSize,0])hex_tile(level4);
   if(level5==0)
       translate([(2*HexSize/sqrt(3))*.75,HexSize/2,0])hex_tile(level1);
   else
       translate([(2*HexSize/sqrt(3))*.75,HexSize/2,0])hex_tile(level5);
   if(level6==0)
       translate([(2*HexSize/sqrt(3))*.75,-HexSize/2,0])hex_tile(level1);
   else
       translate([(2*HexSize/sqrt(3))*.75,-HexSize/2,0])hex_tile(level6);   
   if(level7==0)
       translate([-(2*HexSize/sqrt(3))*.75,HexSize/2,0])hex_tile(level1);
   else
       translate([-(2*HexSize/sqrt(3))*.75,HexSize/2,0])hex_tile(level7);
   if(level8==0)
       translate([-(2*HexSize/sqrt(3))*.75,-HexSize/2,0])hex_tile(level1);
   else
       translate([-(2*HexSize/sqrt(3))*.75,-HexSize/2,0])hex_tile(level8); 
 
}

oct_hex_tile(1);


