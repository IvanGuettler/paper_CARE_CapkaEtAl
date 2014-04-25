
#-------------------------------------------------------------------------
#---------------------------------- RCM ----------------------------------
#-------------------------------------------------------------------------

                for MOD in {1..3}                  ; do
                echo "---------->" ${MOD}
                    for STAT in {1..7}             ; do
                    echo ${STAT}
                        for TYP in rgrid BiasCorr  ; do
                            for VAR in tas pr      ; do

#-----------------------> P0
cdo -r setcalendar,standard -ymonmean -seldate,1961-01-01,1990-12-31 ./files_STAT/MOD${MOD}_HIST_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_P0_YMmean.nc
cdo -r setcalendar,standard -ymonstd  -seldate,1961-01-01,1990-12-31 ./files_STAT/MOD${MOD}_HIST_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_P0_YMstd.nc
cdo -r setcalendar,standard -yearmean                                ./files_STAT/MOD${MOD}_HIST_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_HIST_YEARmean.nc

#-----------------------> P1
cdo -r setcalendar,standard -ymonmean -seldate,2021-01-01,2050-12-31 ./files_STAT/MOD${MOD}_FUT_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_P1_YMmean.nc
cdo -r setcalendar,standard -ymonmean -seldate,2021-01-01,2050-12-31 ./files_STAT/MOD${MOD}_FUT_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_P1_YMstd.nc
cdo -r setcalendar,standard -yearmean                                ./files_STAT/MOD${MOD}_FUT_${TYP}_${VAR}_STAT${STAT}.nc ./files_STAT_derived/MOD${MOD}_${TYP}_${VAR}_STAT${STAT}_FUT_YEARmean.nc

                            done
                        done
                    done
                done

#-------------------------------------------------------------------------
#---------------------------------- EOBS ---------------------------------
#-------------------------------------------------------------------------
                    for STAT in {1..7}             ; do
                            for VAR in tas pr      ; do
cdo -r setcalendar,standard -ymonmean -seldate,1961-01-01,1990-12-31 ./files_STAT/EOBS_HIST_${VAR}_STAT${STAT}.nc ./files_STAT_derived/EOBS_HIST_${VAR}_STAT${STAT}_P0_YMmean.nc
cdo -r setcalendar,standard -ymonstd  -seldate,1961-01-01,1990-12-31 ./files_STAT/EOBS_HIST_${VAR}_STAT${STAT}.nc ./files_STAT_derived/EOBS_HIST_${VAR}_STAT${STAT}_P0_YMstd.nc
cdo -r setcalendar,standard -yearmean                                ./files_STAT/EOBS_HIST_${VAR}_STAT${STAT}.nc ./files_STAT_derived/EOBS_HIST_${VAR}_STAT${STAT}_HIST_YEARMean.nc
                            done
                    done

