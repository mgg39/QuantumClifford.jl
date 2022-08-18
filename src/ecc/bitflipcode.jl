import .ECC
using .ECC

struct Bitflip3 <: AbstractECC end

"""The number of physical qubits in a code."""
code_n(c::Bitflip3) = 3

"""Parity check tableau of a code."""

parity_checks(c::Bitflip3) = S"___
                               _ZZ
                               Z_Z
                               ZZ_"

parity_matrix(c::Bitflip3) = stab_to_gf2(parity_checks(c::Bitflip3))

#Enconding circuit ----------------------------------
c1 = sCNOT(0,1)
c2 = sCNOT(0,3)

encoding_circuit(c::Bitflip3) = [c1,c2]

#----------------------------------------------------------------
#syndrome extraction circuit 
#naive_syndrome_circuit(c::Bitflip3) #Syndrome circuit

code_s(c::Bitflip3) = length(parity_checks(c))

code_k(c::Bitflip3) = code_n(c) - code_s(c)

rate(c::Bitflip3) = code_k(c)/code_s(c)

logx_ops(c::Bitflip3) = P"XXXXXXXXX"
                       
logz_ops(c::Bitflip3) = P"ZZZZZZZZZ"