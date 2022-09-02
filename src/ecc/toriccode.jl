import .ECC

using LinearAlgebra
using .ECC

struct Toric <: AbstractECC 
    n #change to l
end 

code_n(c::Toric) = c.n

#Parity checks ----------------------------------
function valinrow(o::Vector, v::Int64)
    for a in o
        if v == a
            return true
        else
            return false
        end
    end
end

function checks(c::Toric) 
    #not all n can make square lattices
    available_n = [4,12,24] #these values only go up to 9 sided grids - working on a generation function #not count unused qubits
    for i in available_n
        if c.n == i
            if i == 4
                j = 1
            else
                j = i/4 -1
            end

            j = convert(Int8, j)
            z_locations = zeros(c.n, c.n)
            x_locations = zeros(c.n, c.n)
            z_n = 1
            x_n = 1

            #Row classification
            oddrows = []
            evenrows = []
            for i in range(1,c.n+1)
                if i % ((2j)+(j/2)) == 0 && i != 0
                    push!(evenrows,i-4)
                    push!(evenrows,i-3)
                    push!(oddrows,i-2)    
                    push!(oddrows,i-1)  
                    push!(oddrows,i) 
                end               
            end
            
            for location in range(1,c.n)
                #Z gates
                #within the rox bounds
                #last location within length bounds
                #want to make sure w don't take midle row values  
                if z_n <= (c.n) && (location+2j+1) <= (c.n) && location in evenrows
                    z_locations[z_n,location] = 1
                    z_locations[z_n,location+j] = 1
                    z_locations[z_n,location+j+1] = 1
                    z_locations[z_n,location+2j+1] = 1
                #=
                elseif z_locations[location] !=1 && z_n < (c.n) && (location) < (c.n) 
                    z_locations[location,z_n] = 0
                =#
                end

                a = (j/2)+2j
                b = (j/2)+j
                a = convert(Int8, a)
                b = convert(Int8, b)
                #X gates -not running as expected
                if (location+a) <= (c.n) && x_n <= (c.n)
                    if (valinrow(oddrows,location) != valinrow(oddrows,location+j)) # top and left
                        if (valinrow(oddrows,location) != valinrow(oddrows,location+j+1)) #making sure we are not at a border
                            if (valinrow(oddrows,location) != valinrow(oddrows,location+j) && (valinrow(oddrows,location+j) == valinrow(oddrows,location+j+1)) && (valinrow(oddrows,location+j+1) !=valinrow(oddrows,location+a) == true)) # 4 sides
                                x_locations[x_n,location] = 1
                                x_locations[x_n,location+j] = 1
                                x_locations[x_n,location+1+j] = 1
                                x_locations[x_n,la] = 1
                            
                            elseif (valinrow(oddrows,location) != valinrow(oddrows,location+j)) && ( valinrow(oddrows,location+j) != valinrow(oddrows,location+a))  #top left
                                x_locations[x_n,location] = 1
                                x_locations[x_n,location+j] = 1
                                x_locations[x_n,a] = 1
                            
                            elseif (valinrow(oddrows,location) != valinrow(oddrows,location+b)) && (valinrow(oddrows,location+b) != valinrow(oddrows,location+a)) #top right
                                x_locations[x_n,location] = 1
                                x_locations[x_n,location+1+j] = 1
                                x_locations[x_n,a] = 1
                            end
                        end 

                    elseif (location+j) <= (c.n) && x_n <= (c.n) #right bottom
                        if (valinrow(oddrows,location) != valinrow(oddrows,location+j))
                            x_locations[x_n,location] = 1
                            x_locations[x_n,location+j] = 1
                        elseif (location+b) <= (c.n) && x_n <= (c.n) #left bottom
                            if (valinrow(oddrows,location) != valinrow(oddrows,location+b) == true)
                                x_locations[x_n,location] = 1
                                x_locations[x_n,location+b] = 1
                            end
                        end
                    end

                end
                z_n += 1 #next z
                x_n += 1 #next x
            end #for 

            #making X & Z into bool
            Z = !=(0).(z_locations)
            X = !=(0).(x_locations)

            return Stabilizer(X,Z)

        end #if
    end #for

end #function

parity_checks(c::Toric) = checks(c)
#-----------------------------------------------------

parity_matrix(c::Toric) = stab_to_gf2(parity_checks(c))

#Encoding circuit ----------------------------------

encoding_circuit(c::Toric) = [] #TODO
#-----------------------------------------------------

distance(c::Toric) = sqrt(c.n)

code_k(c::Toric) = 1