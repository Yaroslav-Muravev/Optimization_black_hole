% Создание первого поколения
% Один из поколения будет нашим вариантом (идеальным предположительно)

function initial_gen = Create_initial_gen()
    initial_gen = [
        {ones(1, 18), 5 2 1 0.5 115/255 2 1};
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10));
        add_to_cell({Create_one_dim_arr()}, Create_one_dim_arr(7, 10))
    ];
end

function res_cell = add_to_cell(cell, array_to_add)
    res_cell = cell;
    for item_from_array = array_to_add
        res_cell{end+1} = item_from_array;
    end
end