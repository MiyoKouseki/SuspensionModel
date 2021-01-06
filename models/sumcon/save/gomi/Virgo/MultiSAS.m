save$bdn = {{True, "g"}, {False, "F0"}, {False, "PL"}}
 
save$bodypos = {{xg, yg, zg, pitchg, yawg, rollg}, {xF0, 0.45 + yg, zF0, 
      pitchg, yawF0, rollg}, {xPL, yPL, zPL, pitchPL, yawPL, rollPL}}
 
save$damp = {}
 
save$FileName = "MultiSAS"
 
save$HL = {}
 
save$initpos = {{0, 0, 0}, {0, 0.5, 0}, {0, -1.75, 0}}
 
save$IP = {{1, 2, {{0.6, 0.}, {-0.3, -0.51962}, {-0.3, 0.51962}}, 
      {170, 200, 240}, {20, 20, 20}, "IP", 0.45, -100, True, 1050, True}}
 
save$mass = {{0, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}, 
     {300, {{30, 0, 0}, {0, 50, 0}, {0, 0, 30}}}, 
     {400, {{40, 0, 0}, {0, 50, 0}, {0, 0, 40}}}}
 
save$mat = {{"Maraging Steel", 8., 195, 0.3, 1., -3, "Virgo Data"}, 
     {"C-70 Steel", 7.8, 200, 0.3, 3., -4, "LIGO-G050087-00"}, 
     {"Tungsten", 19.3, 411, 0.28, 1., -4, "Wikipedia"}, 
     {"Copper Beryllium", 8.4, 134, 0.3, 5., -6, "www.alb-copperalloys.com"}, 
     {"Sapphire", 3.98, 345, 0.3, 2., -7, "www.crystalsystems.com"}, 
     {"Bolfur", 7.6, 157, 0.3, 1., -3, "www.alb-copperalloys.com"}}
 
save$shape = {{"Doughnut[y]", {1.5, 1, 0.2, 0.2, 0.2}}, 
     {"Cylinder[y]", {1.4, 0.2, 0.2, 0.2, 0.2}}, 
     {"Cylinder[y]", {0.8, 0.1, 0.2, 0.2, 0.2}}}
 
save$vspr = {{1, 1, 500, 3139.2000000000003, True, -60, {0.01, 1, 0.01}, 
      "GAS0", 20.}}
 
save$wire = {{2, {0, 0.02, 0}, 3, {0, -0.007, 0}, 1, 0.9992462557783484, 
      0.006200000000000001, 0.02, 0.003, 3924., {0, -1, 0}, {0, 1, 0}, 
      "F0-PL-1", 5.206010059223329*^6, 6.439015067025694}}
