struct Shor9 <: AbstractECC end

"""The number of physical qubits in a code."""
code_n(c::Shor9) = 9

"""Parity check tableau of a code."""
parity_checks(c::Shor9) = S"ZZ_______
                            _ZZ______
                            ___ZZ____
                            ____ZZ___
                            ______ZZ_
                            _______ZZ
                            XXXXXX___
                            ___XXXXXX"

parity_matrix(c::Shor9) = stab_to_gf2(parity_checks(c::Shor9))

#Enconding circuit ----------------------------------
c1 = sCNOT(1,4)
c2 = sCNOT(1,7)

h1 = sHadamard(1)
h2 = sHadamard(4)
h3 = sHadamard(7)

c3 = sCNOT(1,2)
c4 = sCNOT(4,5)
c5 = sCNOT(7,8)

c6 = sCNOT(1,3)
c7 = sCNOT(4,6)
c8 = sCNOT(7,9) 

encoding_circuit(c::Shor9) = [c1,c2,h1,h2,h3,c3,c4,c5,c6,c7,c8]
#----------------------------------------------------------------

#Syndrome circuit -------------------------------------
function naive_syndrome(encoding_circuit)
    naive_syndrome_circuit = []

    #iterating through all the steps of the encoding circuit
    for i in 1:size(encoding_circuit)
        #iterating through the different physical qubits
        for a in 1:code_n
            #second iteration through available physical qubits (for CNOT gates)
            for b in 1:code_n
                #change qubit order if CNOT gate
                if encoding_circuit[i] == sCNOT(a,b)
                    #adding the steps to the circuit build
                    append!(naive_syndrome_circuit(sCNOT(b,a)))
            
                #Hadamard gates response -> keep step as is
                else
                    append!(naive_syndrome_circuit(encoding_circuit[i]))                        
                end
            end
        end
        return naive_syndrome_circuit
    end
end
#----------------------------------------------------------------

code_s(c::Shor9) = nrow(S)

code_k(c::Shor9) = code_n(c::Shor9) - code_s(c::Shor9)

rate(c::Shor9) = code_k(c::Shor9)/code_s(c::Shor9)

distance(c::Shor9) = 3

logx_ops(c::Shor9) = P"XXXXXXXXX"
                       
logz_ops(c::Shor9) = P"ZZZZZZZZZ"

isdegenerate(c::Shor9) = true 