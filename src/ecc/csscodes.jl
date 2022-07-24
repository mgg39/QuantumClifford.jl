#IN PROGRESS
import nemo #nemo lib for dual code construct 
using LinearAlgebra, Statistics, Compat #for funct automation

#structure for CSS codes
struct CSS <: AbstractECC

    function css_n end
    function classical_code_G_matrix end
    function classical_code_H_matrix end
    function classic_parity_checks end
    function dual_code_prt1 end
    function dual_code_prt2 end

end

#----------------Generating Hamming codes ----------------------------------------------------
#= ODO:
    Number the bits starting from 1: bit 1, 2, 3, 4, 5, 6, 7, etc.
    Write the bit numbers in binary: 1, 10, 11, 100, 101, 110, 111, etc.
    All bit positions that are powers of two (have a single 1 bit in the binary form of their position) are parity bits: 1, 2, 4, 8, etc. (1, 10, 100, 1000)
    All other bit positions, with two or more 1 bits in the binary form of their position, are data bits.
    Each data bit is included in a unique set of 2 or more parity bits, as determined by the binary form of its bit position.
        Parity bit 1 covers all bit positions which have the least significant bit set: bit 1 (the parity bit itself), 3, 5, 7, 9, etc.
        Parity bit 2 covers all bit positions which have the second least significant bit set: bits 2-3, 6-7, 10-11, etc.
        Parity bit 4 covers all bit positions which have the third least significant bit set: bits 4–7, 12–15, 20–23, etc.
        Parity bit 8 covers all bit positions which have the fourth least significant bit set: bits 8–15, 24–31, 40–47, etc.
        In general each parity bit covers all bits where the bitwise AND of the parity position and the bit position is non-zero.
=#

#Testing code for CSS code contruction
#[7,4] Hamming code -> Steane's 7

#classical_code_G_matrix
classical_code_G_matrix(c::CSS) = [1:0:0:0 0:1:0:0 0:0:1:0 0:0:0:1]

#classical_code_H_matrix
classical_code_H_matrix(c::CSS) = [0:0:1 0:1:0 0:1:1 1:0:0 1:0:1 1:1:0 1:1:1]

#----------------------------------------------------------------------------------------------


#----------------CSS code generation ----------------------------------------------------------

#-----------Building dual code ----------------

#create matrix, over space range x



#convert into nemo matrix: def space matrix (float -> binary)

#=
#port processing nemo ------
MatrixSpace(ResidueRing(ZZ,2), rᴬ, Δ)

function dual_code(H)
    null = nullspace(H)[2]
    @assert all(a*null .== 0)
    @assert size(a,1) + size(null,2) == size(a,2)
    transpose(null)
end

G2_orthcolumnspace(c::Rep3) = nullspace(M, rtol=3) 

GD(c::Rep3) = [0:G2 G2_orthcolumnspace:0] =#

#------------------------------

#det with nemo
dual_code_prt1(c:CSS) = [1:0:0:0 0:1:0:0 0:0:1:0 0:0:0:1] #tst H 8 https://en.wikipedia.org/wiki/Hamming_code#[7,4]_Hamming_code
dual_code_prt2(c:CSS) = [0:1:1:1 1:0:1:1 1:1:0:1 1:1:1:0] #tst H 8

#-----------Building CSS code ----------------

parity_checks(c::CSS) = S"" 

code_n(c::CSS) = css_n(c::CSS)#variable input dependent?

parity_matrix(c::CSS) = stab_to_gf2(parity_checks(c::CSS))

#Enconding circuit ----------------------------------

encoding_circuit(c::CSS) = []#TODO
#----------------------------------------------------------------

#Syndrome circuit -------------------------------------
naive_syndrome_circuit(c::Steane5) = []

#iterating through all the steps of the encoding circuit
for i in encoding_circuit(c::Steane5):
    #iterating through the different physical qubits
    for a in code_n(c::Steane5):
        #second iteration through available physical qubits (for CNOT gates)
        for b in code_n(c::Steane5):
            #change qubit order if CNOT gate
            if i == sCNOT(a,b):
                #naming the steps
                @eval 
                $(Symbol(:x, i)) = step[$i]
                #adding the steps to the circuit build
                append!(naive_syndrome_circuit(step[$i], sCNOT(b,a)))
            
            #change X->Z & vice-versage 
            elseif i == Z(a):
                @eval 
                $(Symbol(:x, i)) = step[$i]
                append!(naive_syndrome_circuit(step[$i], X(a)))
            
            elseif i == X(a):
                @eval 
                $(Symbol(:x, i)) = step[$i]
                append!(naive_syndrome_circuit(step[$i], Z(a)))

            else:
                @eval 
                $(Symbol(:x, i)) = step[$i]
                append!(encoding_circuit(step[$i], i)) 

#----------------------------------------------------------------

code_s(c::CSS) = nrow(S)

code_k(c::CSS) = css_n(c::CSS) - code_s(c::CSS)

rate(c::CSS) = code_k(c::CSS)/code_s(c::CSS)

#distance(c::CSS) = undefined for now

logx_ops(c::CSS) = P"XXXXXXXXX"

logz_ops(c::CSS) = P"ZZZZZZZZZ"

logy_ops(c::CSS) = P"YYYYYYYYY" 
