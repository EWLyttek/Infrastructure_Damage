There were several steps to preprocess the FIA data used in this study.

The First step is through the csvParser.m files which are built to download and select data from input state files (Such as those contained in the CT_TREE.zip and the NJ_TREE.zip) and output a sample to train a model on (FIAcsvParser.m/samplejoin.csv and FIAcsvParser_HeightStats.m/samplejoinHT.csv were used to predict tree fall and height versus dbh, respectively.)

For FIAcsvParser.m, there is one additional step. Match.m is formatted to match trees from the state inventories to sample location control numbers (CN). This further allows individual trees to be tracked through time across multiple sample periods.
