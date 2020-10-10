##
bioAnim(
        "data/2D/LiBiofilmV6-THR4000_DD1_D101_R9_S1-4_S2-4.csv",## path to csv fiel with data
        "%s_%d_%d_%d", ## column name pattern;  %s - name of column, $d - x_y_z
        {"AI2_Out", "Biofilm"}, ## Name of color sets
        [101 101], ## Dimiension; [n] - 1D, [n m] 2D, where n&m number of columns for each dimension
        [], ## Data range; [] - whole range with step 1, [1:10:1000] from 1 to 1000 with step 10
        [], ## max color scale; [] - default set to max value in data set, [1000 2000] - max clolor scale for colorset1 & colorset2
        strScale="lin", ## Scale; lin - linear; log - logarithmic
        bSave=true,## If true then save to the file otherwise show only animation
        strDir="anim/2D" ## Destination folder for save
       );

