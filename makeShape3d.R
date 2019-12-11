
# you would need to test several steps for organoid outlines from your own images
###
# step 1 replicate and scale the outlines at some custom steps
# steps for elevation and demotion or lowering (cast down vs cast up)
steps2updown<-rev(c(.98,.90,.75,.55,.30)) # custom best/default steps
# make a function to generate the 3d shape(s), the output would be a matrix.
# some form of extrusion with scaling each outline using steps2updown vector
# the amount of distance for elevation and demotion (amount_dist4elevation_numeric):
# will be the average dist. of pairwise point distances (distance matrix or euclidean distance matrix) / by a value you define
makeShape3d<-function(curve_outline3d_matrix,steps2updown_vector,amount_dist4elevation_numeric){
  final_matrix_3dshape<-NULL
  # scaling
  scaled_listUp<-list()
  for (i in seq(length(steps2updown_vector))){
    scaled_listUp[[i]]<-curve_outline3d_matrix*steps2updown_vector[[i]]
  }
  # a list for lowering/cast down
  scaled_listDown<-scaled_listUp
  # eg. use half of the average euclidean distace as maximum for elevation
  FM<-function(M){as.matrix(dist(M))} # from helper functions https://gist.github.com/benmarwick/7651452 Morphometrics with R Claude J.2008
  distMatEucld<-FM(curve_outline3d_matrix)
  #mean(colMeans(distMatEucld)) # average max. value for elevation
  #mean(colMeans(distMatEucld))/amount_dist4elevation_numeric
  # steps for cast down
  elevateSteps<-seq(mean(colMeans(distMatEucld))/amount_dist4elevation_numeric,
                    c(mean(colMeans(distMatEucld))/amount_dist4elevation_numeric)/length(steps2updown_vector),
                    length.out = length(steps2updown_vector))
  # cast up
  for (i in seq(length(steps2updown_vector))){
    scaled_listUp[[i]][,3]<-elevateSteps[i]
  }
  # lowering of the curves or demotion/cast down
  for (i in seq(length(steps2updown_vector))){
    scaled_listDown[[i]][,3]<--elevateSteps[i]
  }
  # final 3d shape as matrix
  final_matrix_3dshape<-rbind(deformetrics::list2matrix(scaled_listUp),
                              curve_outline3d_matrix,
                              deformetrics::list2matrix(scaled_listDown))
  return(final_matrix_3dshape)
}

# same function is within .Rmd script