-- FEMM 4.2 Script for Galvanic HBC - Simplified Human Body Model
-- Based on: Modak et al. 2022 Figure 8 & 9 (Cylindrical Body Structure)
-- Creates a 2D representation of arm with layered tissue structure

showconsole()
print("========================================")
print("Galvanic HBC - Cylindrical Arm Model")
print("Based on Modak et al. IEEE TBME 2022")
print("Figure 8 & 9 Configuration")
print("========================================")

-- 1. Create New Electrostatic Problem
newdocument(1)

-- 2. Define Problem - AXISYMMETRIC to simulate cylinder
ei_probdef("centimeters", "axi", 1e-8, 0, 30)

-- 3. Simulation frequency
local frequency = 400 -- kHz

print("Frequency: " .. frequency .. " kHz")
print("Mode: Axisymmetric (simulates 3D cylinder)")

-- 4. Define Materials (from paper)
-- Skin: dielectric (high impedance RC network)
ei_addmaterial("Skin", 1200, 1200, 0, 0, 0.0002, 0, 0, 0, 0, 0, 0)
-- Muscle: conductive (low impedance)
ei_addmaterial("Muscle", 7000, 7000, 0, 0, 0.5, 0, 0, 0, 0, 0, 0)
-- Air
ei_addmaterial("Air", 1, 1, 0, 0, 1e-12, 0, 0, 0, 0, 0, 0)
-- Copper (electrodes)
ei_addmaterial("Copper", 1, 1, 0, 0, 5.96e7, 0, 0, 0, 0, 0, 0)

print("Materials defined")

-- 5. Arm Geometry (Cylindrical Cross-Section)
-- Paper: Figure 8 shows arm with 14 cm body radius, 6 cm arm radius
-- We'll model the arm portion with layered structure

local arm_length = 70    -- cm (total arm length)
local skin_thickness = 0.4   -- cm (4 mm as per paper)

-- Arm radius (from centerline)
local muscle_radius = 6.0 - skin_thickness  -- Inner radius
local skin_outer_radius = 6.0               -- Outer radius (total arm radius)

-- Air boundary
local air_outer_radius = 20  -- cm

print("Arm geometry:")
print("  Length: " .. arm_length .. " cm")
print("  Muscle radius: " .. muscle_radius .. " cm")
print("  Skin outer radius: " .. skin_outer_radius .. " cm")
print("  Skin thickness: " .. skin_thickness .. " cm")

-- 6. Draw Muscle Layer (Inner cylinder)
-- In axisymmetric: r=0 is centerline, z is along arm
-- Draw as rectangle: (r_start, z_start) to (r_end, z_end)

ei_addnode(0, 0)
ei_addnode(muscle_radius, 0)
ei_addnode(muscle_radius, arm_length)
ei_addnode(0, arm_length)

ei_addsegment(0, 0, muscle_radius, 0)
ei_addsegment(muscle_radius, 0, muscle_radius, arm_length)
ei_addsegment(muscle_radius, arm_length, 0, arm_length)
ei_addsegment(0, arm_length, 0, 0)

-- Label muscle
ei_addblocklabel(muscle_radius/2, arm_length/2)
ei_selectlabel(muscle_radius/2, arm_length/2)
ei_setblockprop("Muscle", 1, 0, 0)
ei_clearselected()

print("Muscle layer created")

-- 7. Draw Skin Layer (Outer cylinder shell)
ei_addnode(muscle_radius, 0)
ei_addnode(skin_outer_radius, 0)
ei_addnode(skin_outer_radius, arm_length)
ei_addnode(muscle_radius, arm_length)

ei_addsegment(muscle_radius, 0, skin_outer_radius, 0)
ei_addsegment(skin_outer_radius, 0, skin_outer_radius, arm_length)
ei_addsegment(skin_outer_radius, arm_length, muscle_radius, arm_length)
ei_addsegment(muscle_radius, arm_length, muscle_radius, 0)

-- Label skin
ei_addblocklabel((muscle_radius + skin_outer_radius)/2, arm_length/2)
ei_selectlabel((muscle_radius + skin_outer_radius)/2, arm_length/2)
ei_setblockprop("Skin", 1, 0, 0)
ei_clearselected()

print("Skin layer created")

-- 8. Transmitter Electrodes (Ring electrodes on skin surface)
-- Paper: 10 cm separation center-to-center
local tx_position = 20  -- cm from arm start
local electrode_width = 2  -- cm (axial width)
local electrode_gap = 10   -- cm (center-to-center separation)

local tx_pos_z = tx_position - electrode_gap/2
local tx_neg_z = tx_position + electrode_gap/2

print("Adding transmitter electrodes...")

-- Tx-Positive electrode (ring)
ei_addnode(skin_outer_radius, tx_pos_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, tx_pos_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, tx_pos_z + electrode_width/2)
ei_addnode(skin_outer_radius, tx_pos_z + electrode_width/2)

ei_addsegment(skin_outer_radius, tx_pos_z - electrode_width/2, skin_outer_radius + 0.1, tx_pos_z - electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, tx_pos_z - electrode_width/2, skin_outer_radius + 0.1, tx_pos_z + electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, tx_pos_z + electrode_width/2, skin_outer_radius, tx_pos_z + electrode_width/2)
ei_addsegment(skin_outer_radius, tx_pos_z + electrode_width/2, skin_outer_radius, tx_pos_z - electrode_width/2)

ei_addblocklabel(skin_outer_radius + 0.05, tx_pos_z)
ei_selectlabel(skin_outer_radius + 0.05, tx_pos_z)
ei_setblockprop("Copper", 1, 0, 0)
ei_clearselected()

-- Tx-Negative electrode (ring)
ei_addnode(skin_outer_radius, tx_neg_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, tx_neg_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, tx_neg_z + electrode_width/2)
ei_addnode(skin_outer_radius, tx_neg_z + electrode_width/2)

ei_addsegment(skin_outer_radius, tx_neg_z - electrode_width/2, skin_outer_radius + 0.1, tx_neg_z - electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, tx_neg_z - electrode_width/2, skin_outer_radius + 0.1, tx_neg_z + electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, tx_neg_z + electrode_width/2, skin_outer_radius, tx_neg_z + electrode_width/2)
ei_addsegment(skin_outer_radius, tx_neg_z + electrode_width/2, skin_outer_radius, tx_neg_z - electrode_width/2)

ei_addblocklabel(skin_outer_radius + 0.05, tx_neg_z)
ei_selectlabel(skin_outer_radius + 0.05, tx_neg_z)
ei_setblockprop("Copper", 1, 0, 0)
ei_clearselected()

print("Tx electrodes at z = " .. tx_pos_z .. " cm and " .. tx_neg_z .. " cm")

-- 9. Receiver Electrodes
local rx_position = 55  -- cm from arm start (35 cm channel length)
local rx_pos_z = rx_position - electrode_gap/2
local rx_neg_z = rx_position + electrode_gap/2
local channel_length = rx_position - tx_position

print("Adding receiver electrodes...")

-- Rx-Positive electrode (ring)
ei_addnode(skin_outer_radius, rx_pos_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, rx_pos_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, rx_pos_z + electrode_width/2)
ei_addnode(skin_outer_radius, rx_pos_z + electrode_width/2)

ei_addsegment(skin_outer_radius, rx_pos_z - electrode_width/2, skin_outer_radius + 0.1, rx_pos_z - electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, rx_pos_z - electrode_width/2, skin_outer_radius + 0.1, rx_pos_z + electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, rx_pos_z + electrode_width/2, skin_outer_radius, rx_pos_z + electrode_width/2)
ei_addsegment(skin_outer_radius, rx_pos_z + electrode_width/2, skin_outer_radius, rx_pos_z - electrode_width/2)

ei_addblocklabel(skin_outer_radius + 0.05, rx_pos_z)
ei_selectlabel(skin_outer_radius + 0.05, rx_pos_z)
ei_setblockprop("Copper", 1, 0, 0)
ei_clearselected()

-- Rx-Negative electrode (ring)
ei_addnode(skin_outer_radius, rx_neg_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, rx_neg_z - electrode_width/2)
ei_addnode(skin_outer_radius + 0.1, rx_neg_z + electrode_width/2)
ei_addnode(skin_outer_radius, rx_neg_z + electrode_width/2)

ei_addsegment(skin_outer_radius, rx_neg_z - electrode_width/2, skin_outer_radius + 0.1, rx_neg_z - electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, rx_neg_z - electrode_width/2, skin_outer_radius + 0.1, rx_neg_z + electrode_width/2)
ei_addsegment(skin_outer_radius + 0.1, rx_neg_z + electrode_width/2, skin_outer_radius, rx_neg_z + electrode_width/2)
ei_addsegment(skin_outer_radius, rx_neg_z + electrode_width/2, skin_outer_radius, rx_neg_z - electrode_width/2)

ei_addblocklabel(skin_outer_radius + 0.05, rx_neg_z)
ei_selectlabel(skin_outer_radius + 0.05, rx_neg_z)
ei_setblockprop("Copper", 1, 0, 0)
ei_clearselected()

print("Rx electrodes at z = " .. rx_pos_z .. " cm and " .. rx_neg_z .. " cm")
print("Channel length: " .. channel_length .. " cm")

-- 10. Air Region
ei_addnode(skin_outer_radius, 0)
ei_addnode(air_outer_radius, 0)
ei_addnode(air_outer_radius, arm_length)
ei_addnode(skin_outer_radius, arm_length)

ei_addsegment(skin_outer_radius, 0, air_outer_radius, 0)
ei_addsegment(air_outer_radius, 0, air_outer_radius, arm_length)
ei_addsegment(air_outer_radius, arm_length, skin_outer_radius, arm_length)
ei_addsegment(skin_outer_radius, arm_length, skin_outer_radius, 0)

-- Label air
ei_addblocklabel((skin_outer_radius + air_outer_radius)/2, arm_length/2)
ei_selectlabel((skin_outer_radius + air_outer_radius)/2, arm_length/2)
ei_setblockprop("Air", 1, 0, 0)
ei_clearselected()

print("Air region added")

-- 11. Boundary Conditions
ei_addboundprop("Ground", 0, 0, 0, 0, 0, 0)
ei_addboundprop("A0", 0, 0, 0, 0, 0, 0)  -- For centerline (r=0)

-- Ground outer boundary
ei_selectsegment(air_outer_radius, arm_length/2)
ei_setsegmentprop("Ground", 0, 1, 0, 0, "<None>")
ei_clearselected()

ei_selectsegment((skin_outer_radius + air_outer_radius)/2, 0)
ei_setsegmentprop("Ground", 0, 1, 0, 0, "<None>")
ei_clearselected()

ei_selectsegment((skin_outer_radius + air_outer_radius)/2, arm_length)
ei_setsegmentprop("Ground", 0, 1, 0, 0, "<None>")
ei_clearselected()

-- Centerline (axis of symmetry)
ei_selectsegment(0, arm_length/2)
ei_setsegmentprop("A0", 0, 1, 0, 0, "<None>")
ei_clearselected()

-- 12. Define Conductors (Galvanic Differential)
ei_addconductorprop("Tx-Positive", 1, 0, 1)   -- 1V
ei_addconductorprop("Tx-Negative", 0, 0, 1)   -- 0V (ground)
ei_addconductorprop("Rx-Positive", 0, 0, 0)   -- Floating
ei_addconductorprop("Rx-Negative", 0, 0, 0)   -- Floating

-- Apply to electrode segments
ei_selectsegment(skin_outer_radius + 0.1, tx_pos_z)
ei_setsegmentprop("<None>", 0, 1, 0, 0, "Tx-Positive")
ei_clearselected()

ei_selectsegment(skin_outer_radius + 0.1, tx_neg_z)
ei_setsegmentprop("<None>", 0, 1, 0, 0, "Tx-Negative")
ei_clearselected()

ei_selectsegment(skin_outer_radius + 0.1, rx_pos_z)
ei_setsegmentprop("<None>", 0, 1, 0, 0, "Rx-Positive")
ei_clearselected()

ei_selectsegment(skin_outer_radius + 0.1, rx_neg_z)
ei_setsegmentprop("<None>", 0, 1, 0, 0, "Rx-Negative")
ei_clearselected()

print("Conductors assigned")

-- 13. Zoom to fit
ei_zoomnatural()

-- 14. Save
ei_saveas("Galvanic_HBC_Cylindrical_Arm.fee")

print("========================================")
print("CYLINDRICAL ARM MODEL COMPLETE")
print("========================================")
print("")
print("Model Type: Axisymmetric (represents 3D cylinder)")
print("What you see:")
print("  - Vertical axis (r=0) = center of arm")
print("  - Horizontal axis (z) = along arm length")
print("  - Inner layer = Muscle (conductive)")
print("  - Outer layer = Skin (dielectric)")
print("  - 4 ring electrodes on skin surface")
print("")
print("Configuration:")
print("  Arm radius: " .. skin_outer_radius .. " cm")
print("  Arm length: " .. arm_length .. " cm")
print("  Channel length: " .. channel_length .. " cm")
print("  Electrode separation: " .. electrode_gap .. " cm")
print("")
print("Physics (from paper Figure 8 & 9):")
print("  - Balanced galvanic (identical electrodes)")
print("  - Signal through body (Z0_muscle)")
print("  - Loss increases with distance")
print("  - Field concentrated near electrodes")
print("========================================")

-- Auto-solve
local response = messagebox("Cylindrical arm model created!\n\nThis represents Figure 8/9 from the paper.\nDo you want to solve?", "Solve", 4)
if response == 6 then
    print("")
    print("Meshing...")
    ei_createmesh()
    print("Solving...")
    ei_analyze(1)
    print("Loading solution...")
    ei_loadsolution()
    
    -- Get voltages
    local props_rx_pos = eo_getconductorproperties("Rx-Positive")
    local props_rx_neg = eo_getconductorproperties("Rx-Negative")
    
    if props_rx_pos and props_rx_neg then
        local v_rx_pos = props_rx_pos[1]
        local v_rx_neg = props_rx_neg[1]
        local v_diff = v_rx_pos - v_rx_neg
        local gain_db = 20 * math.log10(math.abs(v_diff))
        
        print("")
        print("========================================")
        print("SIMULATION RESULTS")
        print("========================================")
        print(string.format("V_Rx+ = %.6f V", v_rx_pos))
        print(string.format("V_Rx- = %.6f V", v_rx_neg))
        print(string.format("V_Rx (diff) = %.6f V", v_diff))
        print(string.format("Channel Gain = %.2f dB", gain_db))
        print("")
        print("Expected (from paper Figure 9a):")
        print("  ~-40 to -60 dB for balanced galvanic")
        print("  Loss increases with channel length")
        print("========================================")
    end
    
    print("")
    print("View E-field plot (like Figure 8):")
    print("  Plot → Voltage/E-Field Density")
end