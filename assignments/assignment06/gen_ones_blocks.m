function ones_blocks = gen_ones_blocks(blocks)

tot_cols = length(blocks);
tot_rows = sum(blocks);
ones_blocks = zeros(tot_rows, tot_cols);

for i = 1:tot_cols
    n_rows = blocks(i);
    
    if i == 1
        n_prev_rows = 0;
    else
        n_prev_rows = sum(blocks(1:i-1));
    end
    
    extension = zeros(n_rows, tot_cols);
    extension(:,i) = 1;
    
    ones_blocks(n_prev_rows+1:n_prev_rows+n_rows,:) = extension;
end
end