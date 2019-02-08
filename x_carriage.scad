// External constraints
// Configured for my Tronxy p802e.
RAIL_DIAM = 8;
RAIL_SPACING = 44;
// Note that these are oriented as printed, not as used
CAR_Z_SIZE = 55;
CAR_X_SIZE = 70;
CAR_Y_SIZE = 25;
HOT_SCREW_SPACING = 22.8;
HOT_SCREW_DIAM = 3;
BELT_TOOTH_INTERVAL = 2;
BELT_TOOTH_SIZE = 1.2;
BELT_TOOTH_DEPTH = 1.36; // The distance from the back of the belt to the top of the tooth.  How thick the belt is over a tooth.
BELT_THICKNESS = 0.63; // How thick the belt is in a valley.
//BELT_WIDTH = 5.79; // Could probably round up.
BELT_WIDTH = 6;
BELT_X_OFFSET = 14;
SWITCH_LEDGE_X_SIZE = 20;
SWITCH_SCREW_DIAM = 2.5;
SWITCH_SCREW_SEPARATION = 9.5;

// Internal params
RAIL_Y_OFFSET = 2;
RAIL_EXTRA_SPACE = 0;
RAIL_GAP_SLOT_DIAM_MULTIPLIER = 1.5;
RAIL_GAP_SLOT_THICKNESS_MULTIPLIER = 0.2;
BELT_SPACE_Y_SIZE = 1.5*BELT_WIDTH;
BELT_SPACE_X_SIZE = 12;
BELT_SPACE_X_OFFSET = -2;
BACK_VOID_X_SIZE = 22.5;
BACK_VOID_Y_SIZE = (CAR_Y_SIZE/2) - (BELT_WIDTH/2);
SWITCH_SCREW_Z_OFFSET = 4;
SWITCH_LEDGE_Z_SIZE = 10;
SWITCH_LEDGE_Y_SIZE = 6;
//SWITCH_SCREW_HOLE_SIZE = SWITCH_SCREW_DIAM;
SWITCH_SCREW_HOLE_SIZE = 2; // I have smaller screws
SWITCH_LEDGE_X_OFFSET = 0; // 0 -> bottom aligned center of top rail

// Tweaks
BELT_Y_SLOP = 0;

module xCarriage() {
  module railHole() {
    module gapSlot() {
      translate([-0.5*RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER, -0.5*RAIL_DIAM*RAIL_GAP_SLOT_THICKNESS_MULTIPLIER, 0])
        cube([RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER, RAIL_DIAM*RAIL_GAP_SLOT_THICKNESS_MULTIPLIER, CAR_Z_SIZE]);
    };
    cylinder(d=RAIL_DIAM+RAIL_EXTRA_SPACE,h=CAR_Z_SIZE,$fn=50);
    rotate([0, 0, 360/16]) {
      for (i=[0:3]) {
        rotate([0, 0, i*360/8])
          gapSlot();
      };
    };
    cylinder(d1=RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER, d2=0, h=0.5*RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER);
    translate([0,0,CAR_Z_SIZE])
      rotate([180,0,0])
        cylinder(d1=RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER, d2=0, h=0.5*RAIL_DIAM*RAIL_GAP_SLOT_DIAM_MULTIPLIER);
  };
  module hotScrewHole() {
    rotate([-90, 0, 0])
      cylinder(d=HOT_SCREW_DIAM, h=CAR_Y_SIZE, $fn=50);
  };
  translate([CAR_X_SIZE, 0, CAR_Z_SIZE]) {
    rotate([0, 180, 0]) {
      difference() {
        cube([CAR_X_SIZE,CAR_Y_SIZE,CAR_Z_SIZE]);
        { // Rails
          translate([-RAIL_SPACING/2, RAIL_Y_OFFSET, 0])
            translate([CAR_X_SIZE/2,CAR_Y_SIZE/2,0])
            railHole();
          translate([+RAIL_SPACING/2, RAIL_Y_OFFSET, 0])
            translate([CAR_X_SIZE/2,CAR_Y_SIZE/2,0])
            railHole();
        };
        { // Screws
          for (ix=[-1,1]) {
            for (iz=[-1,1]) {
              translate([(CAR_X_SIZE/2)+(ix*HOT_SCREW_SPACING/2), 0, (CAR_Z_SIZE/2)+(iz*HOT_SCREW_SPACING/2)])
                hotScrewHole();
            };
          };
        };
        { // Belt
          translate([-BELT_THICKNESS+((CAR_X_SIZE/2)+(RAIL_SPACING/2))-BELT_X_OFFSET, RAIL_Y_OFFSET + (-BELT_WIDTH+CAR_Y_SIZE)/2, 0]) {
            cube([BELT_THICKNESS, BELT_WIDTH+BELT_Y_SLOP, CAR_Z_SIZE]);
            for (i=[-2:((CAR_Z_SIZE/BELT_TOOTH_INTERVAL)+2)]) {
              translate([-(BELT_TOOTH_DEPTH-BELT_THICKNESS), 0, i*BELT_TOOTH_INTERVAL])
                cube([BELT_TOOTH_DEPTH, BELT_WIDTH+BELT_Y_SLOP, BELT_TOOTH_SIZE]);
            };
          };
          translate([BELT_SPACE_X_OFFSET+(CAR_X_SIZE/2)-(BELT_SPACE_X_SIZE/2), RAIL_Y_OFFSET + (-BELT_SPACE_Y_SIZE+CAR_Y_SIZE)/2, 0]) {
            cube([BELT_SPACE_X_SIZE, BELT_SPACE_Y_SIZE+BELT_Y_SLOP, CAR_Z_SIZE]);
          };
          translate([(CAR_X_SIZE/2)-(BACK_VOID_X_SIZE/2), -BACK_VOID_Y_SIZE+CAR_Y_SIZE, 0]) {
            cube([BACK_VOID_X_SIZE, BACK_VOID_Y_SIZE, CAR_Z_SIZE]);
          };
        };
      };
      { // Switch ledge
        translate([-SWITCH_LEDGE_X_OFFSET, 0, -SWITCH_LEDGE_Y_SIZE]) {
          difference() {
            cube([SWITCH_LEDGE_X_SIZE, SWITCH_LEDGE_Y_SIZE, SWITCH_LEDGE_Z_SIZE]);
            for (ix=[-1,1]) {
              translate([(ix*SWITCH_SCREW_SEPARATION/2) + (SWITCH_LEDGE_X_SIZE/2), 0, SWITCH_SCREW_Z_OFFSET])
                rotate([-90,0,0])
                  cylinder(d=SWITCH_SCREW_HOLE_SIZE, h=SWITCH_LEDGE_Y_SIZE, $fn=50);
            }
          }
        };
      };
    };
  };
};

xCarriage();