save$bdn = {{True, "g"}, {False, "F0"}, {False, "MD"}, {False, "F1"}, 
     {False, "F2"}, {False, "F3"}, {False, "PF"}, {False, "IR"}, 
     {False, "IM"}, {False, "RM"}, {False, "TM"}, {True, "IS1"}, 
     {True, "IS2"}}
 
save$bodypos = {{xg, yg, zg, pitchg, yawg, rollg}, {xF0, 0.5 + yg, zF0, 
      pitchg, yawF0, rollg}, {xMD, yMD, zMD, pitchMD, yawMD, rollMD}, 
     {xF1, yF1, zF1, pitchF1, yawF1, rollF1}, {xF2, yF2, zF2, pitchF2, yawF2, 
      rollF2}, {xF3, yF3, zF3, pitchF3, yawF3, rollF3}, 
     {xPF, yPF, zPF, pitchPF, yawPF, rollPF}, {xIR, yIR, zIR, pitchIR, yawIR, 
      rollIR}, {xIM, yIM, zIM, pitchIM, yawIM, rollIM}, 
     {xRM, yRM, zRM, pitchRM, yawRM, rollRM}, {xTM, yTM, zTM, pitchTM, yawTM, 
      rollTM}, {xIS1, yIS1, zIS1, pitchIS1, yawIS1, rollIS1}, 
     {xIS2, yIS2, zIS2, pitchIS2, yawIS2, rollIS2}}
 
save$damp = {{"MDeddy", 3, 4, {0., -0.02, 0.}, {0., 0.1, 0.001}, 
      {{36, 0, 0, 0, 0, 0}, {0, 90, 0, 0, 0, 0}, {0, 0, 36, 0, 0, 0}, 
       {0, 0, 0, 5, 0, 0}, {0, 0, 0, 0, 4, 0}, {0, 0, 0, 0, 0, 5}}}}
 
save$FileName = "TypeA\\130305_TypeA"
 
save$HL = {{12, 8, {0., 0., 0.}, {0.2, 0., 0.}, {-0.8, 0.2, 0.}, 4, 100., 
      {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}}, 
      {{"k1x", "", "", "", "", ""}, {"", "k1y", "", "", "", ""}, 
       {"", "", "k1z", "", "", ""}, {"", "", "", "", "", ""}, 
       {"", "", "", "", "", ""}, {"", "", "", "", "", ""}}, "HL1"}, 
     {13, 8, {0., 0., 0.}, {-0.2, 0., 0.}, {0.8, 0.2, 0.}, 1, 100., 
      {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}}, 
      {{"k1x", "", "", "", "", ""}, {"", "k1y", "", "", "", ""}, 
       {"", "", "k1z", "", "", ""}, {"", "", "", "", "", ""}, 
       {"", "", "", "", "", ""}, {"", "", "", "", "", ""}}, "HL2"}}
 
save$initpos = {{0, 0, 0}, {0, 0.5, 0}, {0, -2.4, 0}, {0, -2.6, 0}, 
     {0, -5.6000000000000005, 0}, {0, -8.6, 0}, {0, -11.6, 0}, {0, -12.1, 0}, 
     {0, -12.1, 0}, {0, -12.4, 0}, {0, -12.4, 0}, {1., -12.104000000000001, 
      0}, {-1., -12.104000000000001, 0}}
 
save$IP = {{1, 2, {{0.6, 0}, {-0.3, -0.5196}, {-0.3, 0.5196}}, 
      {13., 13., 13., 200}, {3, 3, 3, 1000}, "IP", 0.5, -80, True, 1085., 
      True}}
 
save$mass = {{0, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}, 
     {474., {{60., 0, 0}, {0, 120., 0}, {0, 0, 60.}}}, 
     {30., {{1.3, 0, 0}, {0, 2.5, 0}, {0, 0, 1.3}}}, 
     {104., {{4.4, 0, 0}, {0, 7.3, 0}, {0, 0, 4.4}}}, 
     {90., {{4., 0, 0}, {0, 6.4, 0}, {0, 0, 4.}}}, 
     {87., {{4., 0, 0}, {0, 6.4, 0}, {0, 0, 4.}}}, 
     {120., {{5., 0, 0}, {0, 8., 0}, {0, 0, 5.}}}, 
     {60., {{1.2, 0, 0}, {0, 2., 0}, {0, 0, 1.2}}}, 
     {60., {{0.4, 0, 0}, {0, 0.7, 0}, {0, 0, 0.4}}}, 
     {37., {{0.45, 0, 0}, {0, 0.45, 0}, {0, 0, 0.66}}}, 
     {23, {{0.11, 0, 0}, {0, 0.11, 0}, {0, 0, 0.14}}}, 
     {0, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}, 
     {0, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}}
 
save$mat = {{"Maraging Steel", 8., 195, 0.3, 1., -3, "Virgo Data"}, 
     {"C-70 Steel", 7.8, 200, 0.3, 3., -4, "LIGO-G050087-00"}, 
     {"Tungsten", 19.3, 411, 0.28, 1., -4, "Wikipedia"}, 
     {"Copper Beryllium", 8.4, 134, 0.3, 5., -6, "www.alb-copperalloys.com"}, 
     {"Sapphire", 3.98, 345, 0.3, 2., -7, "www.crystalsystems.com"}, 
     {"Bolfur", 7.6, 157, 0.3, 1., -3, "www.alb-copperalloys.com"}}
 
save$shape = {{"Doughnut[y]", {1.5, 0.8, 0.2, 0.2, 0.2}}, 
     {"Cylinder[y]", {1.4, 0.2, 0.2, 0.2, 0.2}}, 
     {"Doughnut[y]", {1., 0.7, 0.2, 0.2, 0.2}}, {"TruncatedCone[y]", 
      {0.6, 0.8, 0.2, 0.2, 0.2}}, {"TruncatedCone[y]", 
      {0.6, 0.8, 0.2, 0.2, 0.2}}, {"TruncatedCone[y]", 
      {0.6, 0.8, 0.2, 0.2, 0.2}}, {"OpenCuboid[y]", {0.6, 0.2, 0.6, 0.2, 
       0.2}}, {"OpenCuboid[y]", {0.4, 0.2, 0.3, 0.2, 0.2}}, 
     {"Cuboid", {0.3, 0.15, 0.2, 0.2, 0.2}}, {"Cylinder[z]", 
      {0.3, 0.11, 0.2, 0.2, 0.2}}, {"Cylinder[z]", {0.22, 0.15, 0.2, 0.2, 
       0.2}}, {"Cuboid", {0.05, 0.05, 0.05, 0.2, 0.2}}, 
     {"Cuboid", {0.05, 0.05, 0.05, 0.2, 0.2}}}
 
save$vspr = {{4, 1, 917.4784251252665, 5699.61, True, -80, {0, 1, 0}, "GAS0", 
      20.}, {5, 1, 1694.8084677550644, 4679.37, True, -80, {0, 1, 0}, "GAS1", 
      10.}, {6, 1, 1375.0332851597693, 3796.4700000000003, True, -80, 
      {0, 1, 0}, "GAS2", 10.}, {7, 1, 1065.9172753176506, 2943., True, -80, 
      {0, 1, 0}, "GAS3", 10.}, {11, 1, 1184.352528130723, 1177.2, True, -60, 
      {0, 1, 0}, "GAS4", 100.}, {16, 1, 51075.202775637415, 
      56.407500000000006, False, -60, {0, 1, 0}, "TMSpr1", 100000.}, 
     {17, 1, 51075.202775637415, 56.407500000000006, False, -60, {0, 1, 0}, 
      "TMSpr2", 100000.}, {18, 1, 51075.202775637415, 56.407500000000006, 
      False, -60, {0, 1, 0}, "TMSpr3", 100000.}, {19, 1, 51075.202775637415, 
      56.407500000000006, False, -60, {0, 1, 0}, "TMSpr4", 100000.}}
 
save$wire = {{2, {-0.4, -0.05, -4.898587196589413*^-17}, 3, 
      {-0.4, 0., -4.898587196589413*^-17}, 2, 2.703230159875852, 0.0005, 0, 
      0.0005, 98.1, {0, -1, 0}, {0, 1, 0}, "F0-MD-1", 14490.741022093142, 
      0.00017416756036169642}, {2, {0.19999999999999973, -0.05, 
       0.3464101615137756}, 3, {0.19999999999999973, 0., 0.3464101615137756}, 
      2, 2.703230159875852, 0.0005, 0, 0.0005, 98.1, {0, -1, 0}, {0, 1, 0}, 
      "F0-MD-2", 14490.741022093142, 0.00017416756036169642}, 
     {2, {0.20000000000000023, -0.05, -0.34641016151377535}, 3, 
      {0.20000000000000023, 0., -0.34641016151377535}, 2, 2.703230159875852, 
      0.0005, 0, 0.0005, 98.1, {0, -1, 0}, {0, 1, 0}, "F0-MD-3", 
      14490.741022093142, 0.00017416756036169642}, {2, {0, -0.005, 0}, 4, 
      {0, 0.005, 0}, 1, 3.0332106533382075, 0.0038, 0.02, 0.001, 5699.61, 
      {0, -1, 0}, {0, 1, 0}, "F0-F1-1", 616435.5414467987, 
      0.13526295398544627}, {4, {0, -0.005, 0}, 5, {0, 0.005, 0}, 1, 
      3.040753923781515, 0.0038, 0.02, 0.001, 4679.37, {0, -1, 0}, {0, 1, 0}, 
      "F1-F2-1", 616435.5414467987, 0.13526295398544627}, 
     {5, {0, -0.005, 0}, 6, {0, 0.005, 0}, 1, 3.0446741575128002, 0.0038, 
      0.02, 0.0025, 3796.4700000000003, {0, -1, 0}, {0, 1, 0}, "F2-F3-1", 
      712839.3318286571, 0.4762834101860892}, {6, {0, -0.005, 0}, 7, 
      {0, 0.005, 0}, 1, 3.0458356121857655, 0.0038, 0.02, 0.0022, 2943., 
      {0, -1, 0}, {0, 1, 0}, "F3-PF-1", 706706.5151666149, 
      0.45611647296858576}, {7, {0.2, -0.05, 0.}, 8, {0.2, 0.05, 0.}, 3, 
      0.2975979846281054, 0.0004, 0, 0.0004, 196.2, {0, -1, 0}, {0, 1, 0}, 
      "PF-IR-1", 81681.40899333463, 0.0006283185307179587}, 
     {7, {-0.09999999999999996, -0.05, -0.17320508075688776}, 8, 
      {-0.09999999999999996, 0.05, -0.17320508075688776}, 3, 
      0.2975979846281054, 0.0004, 0, 0.0004, 196.2, {0, -1, 0}, {0, 1, 0}, 
      "PF-IR-2", 81681.40899333463, 0.0006283185307179587}, 
     {7, {-0.10000000000000009, -0.05, 0.17320508075688767}, 8, 
      {-0.10000000000000009, 0.05, 0.17320508075688767}, 3, 
      0.2975979846281054, 0.0004, 0, 0.0004, 196.2, {0, -1, 0}, {0, 1, 0}, 
      "PF-IR-3", 81681.40899333463, 0.0006283185307179587}, 
     {7, {0, -0.005, 0}, 9, {0, -0.005, 0}, 1, 0.39879899231405275, 0.0016, 
      0, 0.0016, 1177.2, {0, -1, 0}, {0, 1, 0}, "PF-IM-1", 980176.9079200155, 
      0.12063715789784805}, {9, {-0.145, 0, -0.015}, 10, {-0.145, 0, -0.015}, 
      4, 0.2994721126741328, 0.0007, 0, 0.0007, 90.7425, {0, -1, 0}, 
      {0, 1, 0}, "IM-RM-1", 171897.47802892156, 0.004049507895873632}, 
     {9, {-0.145, 0, 0.015}, 10, {-0.145, 0, 0.015}, 4, 0.2994721126741328, 
      0.0007, 0, 0.0007, 90.7425, {0, -1, 0}, {0, 1, 0}, "IM-RM-2", 
      171897.47802892156, 0.004049507895873632}, {9, {0.145, 0, 0.015}, 10, 
      {0.145, 0, 0.015}, 4, 0.2994721126741328, 0.0007, 0, 0.0007, 90.7425, 
      {0, -1, 0}, {0, 1, 0}, "IM-RM-3", 171897.47802892156, 
      0.004049507895873632}, {9, {0.145, 0, -0.015}, 10, {0.145, 0, -0.015}, 
      4, 0.2994721126741328, 0.0007, 0, 0.0007, 90.7425, {0, -1, 0}, 
      {0, 1, 0}, "IM-RM-4", 171897.47802892156, 0.004049507895873632}, 
     {9, {-0.11, 0, -0.0075}, 11, {-0.11, 0, -0.0075}, 5, 
      0.29997560453137917, 0.0016, 0, 0.0016, 56.407500000000006, {0, -1, 0}, 
      {0, 1, 0}, "IM-TM-1", 2.312212193042088*^6, 0.2845799622205647}, 
     {9, {-0.11, 0, 0.0075}, 11, {-0.11, 0, 0.0075}, 5, 0.29997560453137917, 
      0.0016, 0, 0.0016, 56.407500000000006, {0, -1, 0}, {0, 1, 0}, 
      "IM-TM-2", 2.312212193042088*^6, 0.2845799622205647}, 
     {9, {0.11, 0, 0.0075}, 11, {0.11, 0, 0.0075}, 5, 0.29997560453137917, 
      0.0016, 0, 0.0016, 56.407500000000006, {0, -1, 0}, {0, 1, 0}, 
      "IM-TM-3", 2.312212193042088*^6, 0.2845799622205647}, 
     {9, {0.11, 0, -0.0075}, 11, {0.11, 0, -0.0075}, 5, 0.29997560453137917, 
      0.0016, 0, 0.0016, 56.407500000000006, {0, -1, 0}, {0, 1, 0}, 
      "IM-TM-4", 2.312212193042088*^6, 0.2845799622205647}}
