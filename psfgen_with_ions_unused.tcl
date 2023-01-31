package require psfgen
package require topotools
resetpsf
# topology charmm2lammps_all36_tip3/top_all36_prot_C2L_TIP3_OH.rtf
topology charmm2lammps_all36_tip3/top_all36_prot_C2L_TIP3.rtf
topology charmm2lammps_all36_tip3/toppar_water_ions_namd.str
alias residue HIS HSE
set N <N>
for {set i 1} {$i < [expr {$N + 1}]} {incr i} {
	segment P$i { pdb melt_chain$i.pdb }
	coordpdb melt_chain$i.pdb P$i
	guesscoord
}

### ADD IONS
segment I { 
	pdb <ions pdb>
	# first none
	# last none
}
coordpdb <ions pdb> I
guesscoord
### END ADD IONS

### ADD WATER
segment W { pdb melt_water.pdb }
coordpdb melt_water.pdb W
guesscoord
### END ADD WATER

writepdb ionized_noTER.pdb
writepsf ionized.psf
mol delete all
resetpsf