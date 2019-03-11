function Aeq_3 = gen_input_equality(blocks, B)

tot_cols = length(blocks);
tot_rows = sum(blocks);
alloc = zeros(tot_rows, tot_cols);

for i = 1:tot_cols
    n_rows = blocks(i);
    
    if i == 1
        n_prev_rows = 0;
    else
        n_prev_rows = sum(blocks(1:i-1));
    end
    
    extension = zeros(n_rows, tot_cols);
    extension(:,i) = 1;
    
    alloc(n_prev_rows+1:n_prev_rows+n_rows,:) = extension;
end

Aeq_3 = kron(alloc, -B);

end