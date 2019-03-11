function u = gen_input_sequence(N, nx, nu, z, u_blocks)

u = zeros(N*nu,1);

for i = 1:length(u_blocks)
    if i == 1
        i_cumu = 0;
    else
        i_cumu = sum(u_blocks(1:i-1));
    end
    
    u(i_cumu+1:i_cumu+u_blocks(i)) = repelem(z(N*nx+i), u_blocks(i));
end

end

