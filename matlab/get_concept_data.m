function [train_data, test_data] = get_concept_data(concept, test_pct, all_data)
    all_sequences = all_data.(concept);
    num_students = size(all_sequences, 2);
    
    % Randomly assign students to train or test group
    assign = binornd(1, test_pct, num_students, 1);
    test_data_size = sum(assign);
    train_data_size = num_students - test_data_size;
    
    % Initialize cell arrays for train and test data
    test_data = cell(1, test_data_size);
    train_data = cell(1, train_data_size);
    
    test_index = 0;
    train_index = 0;
    for j = 1:size(all_sequences,2)
        
        seq = all_sequences(1,j);
        if iscell(seq)
            s = seq{1,1} + 1;
        elseif isvector(seq)
            s = seq(1,:) + 1;
        end
        
        if assign(j,1) == 1
            test_index = test_index + 1;
            test_data{1, test_index} = s;
        else
            train_index = train_index + 1;
            train_data{1, train_index} = s;
        end
    end
end
