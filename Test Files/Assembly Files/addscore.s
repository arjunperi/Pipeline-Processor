nop # Basic Addi Test with no Hazards
nop # Values initialized using addi (positive only)
nop # Author: Peri, Arjun
nop
nop
nop 
addi $r2, $r0, 1		# r2 = 1
j1: bne $r2, $r3, b1	# if r2 = r3 (the button press register), then we go to addi, if not then just branch to jump and come back
addi $r1, $r1, 1	
j j1
b1: j j1

