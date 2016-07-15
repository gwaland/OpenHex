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
//make a row of hex tiles of <length> set to a specific height increasing by height to make a hill. 
module road_hex_tile(length,level1, hill=0)
{ 
   for(y = [0:length-1])
   {
       translate([0,HexSize*y,0])hex_tile((y*hill)+level1);
   }
}

module 24_hex_tile(level1,hill=0)
{
    road_hex_tile(6,level1,hill);
    translate([(2*HexSize/sqrt(3))*.75,HexSize/2,0])road_hex_tile(5,level1,hill);
    translate([2*(2*HexSize/sqrt(3))*.75,HexSize,0])road_hex_tile(5,level1,hill);
    translate([3*(2*HexSize/sqrt(3))*.75,2*HexSize+HexSize/2,0])road_hex_tile(3,level1+hill,hill);
    translate([4*(2*HexSize/sqrt(3))*.75,3*HexSize,0])road_hex_tile(3,level1+hill,hill);
    translate([5*(2*HexSize/sqrt(3))*.75,3*HexSize+HexSize/2,0])road_hex_tile(2,level1+hill,hill);
}
module map(x,y)
{
        for(map_x=[0:1:x])
        {
            if(map_x%2==0)
                translate([map_x*(2*HexSize/sqrt(3))*.75,HexSize/2,0])road_hex_tile(y);
            else
                translate([map_x*(2*HexSize/sqrt(3))*.75,0,0])road_hex_tile(y);
            
        }
}

map(15,17);