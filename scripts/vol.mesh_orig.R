# original function https://github.com/AProfico/Arothron to calculate 3D mesh volumes

vol.mesh <- function(mesh) {
    ver = t(mesh$vb)[, -4]
    tri = t(mesh$it)[, -4]
    vol = NULL
    for (j in 1:dim(tri)[1]) {
        vol[j] = abs(-(ver[tri[j, ], 1][3] * ver[tri[j, ], 2][2] * 
            ver[tri[j, ], 3][1]) + (ver[tri[j, ], 1][2] * ver[tri[j, 
            ], 2][3] * ver[tri[j, ], 3][1]) + (ver[tri[j, ], 
            1][3] * ver[tri[j, ], 2][1] * ver[tri[j, ], 3][2]) - 
            (ver[tri[j, ], 1][1] * ver[tri[j, ], 2][3] * ver[tri[j, 
                ], 3][2]) - (ver[tri[j, ], 1][2] * ver[tri[j, 
            ], 2][1] * ver[tri[j, ], 3][3]) + (ver[tri[j, ], 
            1][1] * ver[tri[j, ], 2][2] * ver[tri[j, ], 3][3]))/6
    }
    vol_mesh = sum(vol)
    return(vol_mesh)
}