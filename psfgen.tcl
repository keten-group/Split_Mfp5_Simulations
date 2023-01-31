package require psfgen
resetpsf
topology charmm2lammps_all36_tip3/top_all36_prot_C2L_TIP3_OH_CLA.rtf
topology charmm2lammps_all36_tip3/toppar_water_ions_namd.str

alias residue HIS HSE
set N <N>
# set N 24
for {set i 1} {$i < [expr {$N + 1}]} {incr i} {
	segment P$i { pdb melt_chain$i.pdb }
	coordpdb melt_chain$i.pdb P$i
	guesscoord
}

##### ADD WATER
segment W { pdb melt_water.pdb }
coordpdb melt_water.pdb W
guesscoord
##### END ADD WATER

##### ADD IONS
if { [file exists melt_ions.pdb ] == 1} {
	# https://9to5answer.com/tcl-check-file-existence
	segment I { pdb melt_ions.pdb }
	coordpdb melt_ions.pdb I
	guesscoord
}
##### END ADD IONS

writepdb ionized_noTER.pdb
writepsf ionized.psf
# writepdb <psfgen_out>_noTER.pdb
# writepsf <psfgen_out>.psf

# Generate PQR file
mol delete all
mol new ionized.psf
mol addfile ionized_noTER.pdb
animate write pqr ionized.pqr
# mol new <psfgen_out>.psf
# mol addfile <psfgen_out>_noTER.pdb
# animate write pqr <psfgen_out>.pqr
mol delete all
resetpsf