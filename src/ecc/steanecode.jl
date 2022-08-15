struct Steane5 <: AbstractECC end
struct Steane7 <: AbstractECC end

#Steane 5 qubit code
parity_checks(c::Steane5) = S"XZZX_
                              _XZZX
                              X_XZZ
                              ZX_XZ"

code_n(c::Steane5) = 5

parity_matrix(c::Steane5) = stab_to_gf2(parity_checks(c::Steane5))

#Encoding circuit ----------------------------------
#https://www.researchgate.net/figure/Encoding-circuit-for-the-five-qubit-code-a-Circuit-to-encode-the-logical-minus-state_fig1_337273308

z1 = sZ(1)
h1 = sHadamard(3)
h2 = sHadamard(4)
is1 = sInvPhase(1)
c1 = sCNOT(3,5)
c2 = sCNOT(4,2)
h3 = sHadamard(2)
c3 = sCNOT(4,5)
c4 = sCNOT(2,1)
is2 = sInvPhase(3)
s2 = sPhase(4)
is3 = sInvPhase(5)
s2 = sPhase(1)
s3 = sPhase(2)
z2 = sZ(3)
c5 = sCNOT(1,5)
h4 = sHadamard(5)
c6 = sCNOT(2,5)

encoding_circuit(c::Steane5) = [z1,h1,h2,is1,c1,c2,h3,c3,c4,is2,s2,is3,s2,s3,z2,c5,h4,c6] 
#----------------------------------------------------------------

code_s(c::Steane5) = length(parity_checks(c))

code_k(c::Steane5) = code_n(c) - code_s(c)

rate(c::Steane5) = code_k(c)/code_s(c)

distance(c::Steane5) = 3

logx_ops(c::Steane5) = P"XXXXX" 
                       
logz_ops(c::Steane5) = P"ZZZZZ" 

isdegenerate(c::Steane5) = false 

#=
naive_syndrome(encoding_circuit) #Syndrome circuit
=#

##----------------------------------------------------------------------------------------------------------------------------

#steane 7 qubit code
parity_checks(c::Steane7) = S"___XXXX
                              _XX__XX
                              X_X_X_X
                              ___ZZZZ
                              _ZZ__ZZ
                              Z_Z_Z_Z"

code_n(c::Steane7) = 7

parity_matrix(c::Steane7) = stab_to_gf2(parity_checks(c::Steane7))

#Encoding circuit ----------------------------------
c1 = sCNOT(1,2)
c2 = sCNOT(1,3)

h1 = sHadamard(5)
h2 = sHadamard(6)
h3 = sHadamard(7)

c3 = sCNOT(7,1)
C4 = sCNOT(7,1)
c5 = sCNOT(7,4)
c6 = sCNOT(6,1)
c7 = sCNOT(6,3)
c8 = sCNOT(6,4)
c9 = sCNOT(5,2)
c10 = sCNOT(5,3)
c11 = sCNOT(5,2)

encoding_circuit(c::Steane7) = [c1,c2,h1,h2,h3,c3,c4,c5,c6, c7, c8, c9, c10, c11]
#----------------------------------------------------------------

code_s(c::Steane7) = length(parity_checks(c))

code_k(c::Steane7) = code_n(c) - code_s(c)

rate(c::Steane7) = code_k(c)/code_s(c)

distance(c::Steane7) = 3

logx_ops(c::Steane7) = P"XXXXXXX" 
                       
logz_ops(c::Steane7) = P"ZZZZZZZ" 

isdegenerate(c::Steane7) = false 

#=
naive_syndrome(encoding_circuit) #Syndrome circuit
=#