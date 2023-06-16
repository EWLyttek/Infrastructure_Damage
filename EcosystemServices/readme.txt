InVEST version 3.11.0 was used for the calculations presented.

There are two types of files present in this repository: Spatial files as either tifs or shape files and csv files for landcover depenedent variables. we cover each file in detail below and the reader should otherwise refer to the InVEST user guide for running the model.

First, the spatial tif files. The tif files that are important for running the model are denoted MP13 for multi-point version 13 referencing the point file they were projected from. 

The first is the DEM, MP13_DEM_4, or digital elevation model, which is needed for most InVEST applications. 
The second is MP13_EROITY_4, which is the erosivity factor of the land. 
The third is MP13_EVAP_4, which is the evapotranspiration/evaporation of the study area. 
The fourth is MP13_LULCB_4, which is the base LULC sourced from the 2015 LULC for New Jersey.
The fifth is MP13_LULCUP_4, which is the updated LULC based on forest loss.
The sixth is MP13_PAWC_4, which is the plant available water content.
The seventh is MP13_PRECIP_4, which is the precipitaion.
The eigth is MP13_RESTRICT_4, which is the root restricting layer.
The ninth is MP13_R_4, which is the r factor for seasonality.
The tenth is MP13_ZFACTOR, which is input in as a single number into InVEST, which we take as the avaerage for the study area from this tif.
Eleventh we have FOREST_MINUS_FRAINUS_RAT, which is what we used to determine the transitions for different patches and records the potential forest loss from Fraxinus mortality for the study area. This was used to create the boundary conditions for the MP13_LULCUP_4 tif.

Next, we have the .shp files of which there are two. These are the watersheds for the region and are denoted as SubWatersheds_2 and Watersheds_2. These are important for determining runoff direction and quantities.

Finally, we have the csv input files the first three of which define the LULC dependent factors for each of the models. These include the BARREN_TRANSITION_UPDATE table as well as the backup of the SHRUBBY_TRANSITION tables. Which both include all baseline values and the exxperimental values for either a barren or shrubby understory condition.
