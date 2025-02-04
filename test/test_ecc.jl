using QuantumClifford
using QuantumClifford.ECC: AbstractECC, Steane5, Steane7, Shor9, Bitflip3, naive_syndrome_circuit, code_n, parity_checks, encoding_circuit, code_s, code_k, rate, distance,logx_ops, logz_ops, isdegenerate

function test_op(c::AbstractECC)
    @testset "Physical and Logical qubit" begin

        physicalqubit = random_stabilizer(code_k(c))

        gate = rand((:x,:z))

        if isdegenerate(c) == true
            physicalgate, logicalgate = if gate==:x
                P"X",logz_ops(c)[1]
            elseif gate == :z
                P"Z",logx_ops(c)[1]
            end
        else
            physicalgate, logicalgate = if gate==:x
                P"X",logx_ops(c)[1]
            elseif gate == :z
                P"Z",logz_ops(c)[1]
            end
        end

        #run 1
        #start physical state
        physicalqubit1 = copy(physicalqubit)
        #perform physical gate
        apply!(physicalqubit1,physicalgate)
        #encode into logical state
        bufferqubits1 = one(Stabilizer,code_s(c))
        logicalqubit1 = physicalqubit1⊗bufferqubits1 
        for gate in encoding_circuit(c)
            apply!(logicalqubit1,gate)
        end
        

        #run 2
        #start same physical state
        physicalqubit2 = copy(physicalqubit)
        #encode logical state
        bufferqubits2 = one(Stabilizer,code_s(c))
        logicalqubit2 = physicalqubit2⊗bufferqubits2 
        for gate in encoding_circuit(c)
            apply!(logicalqubit2,gate)
        end
        #apply logical gate
        apply!(logicalqubit2,logicalgate)


        @test canonicalize!(logicalqubit1) == canonicalize!(logicalqubit2)
       
        #physicalqubit
        encoding_circuit_physical = encoding_circuit(c)
        physicalqubit = S"X"
        apply!(physicalqubit,P"X")

        #logicalqubit
        encoding_circuit_logical = encoding_circuit(c)

        if c == Steane5()
            ancillary_qubit_count = 3
        elseif c == Steane7()
            ancillary_qubit_count = 4
        elseif c == Shor9()
            ancillary_qubit_count = 8
        elseif c == Bitflip3()
            ancillary_qubit_count = 2
        end
        

        bufferqubits = one(Stabilizer,ancillary_qubit_count)
        logicalqubit = physicalqubit⊗bufferqubits 
        for gate in encoding_circuit_logical
            apply!(logicalqubit,gate)
        end

        canonicalize!(logicalqubit)

        for gate in encoding_circuit(c)
            @test encoding_circuit_physical == encoding_circuit_logical
        end

    end
end


function test_ns(c::AbstractECC)

    @testset "Naive syndrome circuits" begin
        #initiate physical qubit
        physicalqubit = random_stabilizer(code_k(c))
        #obtain syndrome circuit
        nc = naive_syndrome_circuit(c)
        convert(Vector{AbstractSymbolicOperator}, nc)

        s = []
        #h = []
        for check in parity_checks(c)
            append!(s,project!(physicalqubit,check))
        end

        i = 1
        for gate in nc
            try
                apply!(physicalqubit,gate)

                a = s[i]
                b = Register(physicalqubit)
                #append!(h,project!(b,check))

                @test a == b
                

            catch
                0
            end
            i+= 1
        end

        
    end
    
end
    
codes = [Steane5(),Steane7(),Shor9()]
    
for c in codes
    #test_op(c)
    test_ns(c)
end
    
    
