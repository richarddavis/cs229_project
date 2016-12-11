function [train1_data, test1_data] = get_concept_data(concept, test_pct, all_data, cluster_data)
    all_sequences = all_data.(concept);
    num_students = size(fieldnames(all_sequences), 1)
    
    % Split data by cluster (assumes we only have two clusters labeled 1
    % and 2.
    clust_1 = all_sequences;
    clust_2 = all_sequences;
    fields = fieldnames(all_sequences);
    for i = 1:numel(fields)
        if cluster_data.(fields{i}) == 1
            clust_1 = rmfield(clust_1, fields{i});
        else
            clust_2 = rmfield(clust_2, fields{i});
        end
    end

    clust1_seqs = struct2cell(clust_1);
    clust2_seqs = struct2cell(clust_2);
    % Convert structs to cell arrays (for now throw out student ID since
    % we've already split data by cluster).
    
    % Randomly assign students to train or test group
    num_students_1 = size(clust1_seqs,1);
    num_students_2 = size(clust2_seqs,1);
    assign1 = binornd(1, test_pct, num_students_1, 1);
    assign2 = binornd(1, test_pct, num_students_2, 1);   
    
    test1_data_size = sum(assign1);
    train1_data_size = num_students_1 - test1_data_size;
    test2_data_size = sum(assign2);
    train2_data_size = num_students_2 - test1_data_size;
    
    % Initialize cell arrays for train and test data
    test1_data = cell(1, test1_data_size);
    train1_data = cell(1, train1_data_size);
    test2_data = cell(1, test2_data_size);
    train2_data = cell(1, train2_data_size);
    
    test1_index = 0;
    train1_index = 0;
    
    for j = 1:size(clust1_seqs,1)
        
        seq = clust1_seqs(j,1);
        if iscell(seq)
            s = seq{1,1} + 1;
        elseif isvector(seq)
            s = seq(1,:) + 1;
        end

        if assign1(j,1) == 1
            test1_index = test1_index + 1;
            test1_data{1, test1_index} = s;
        else
            train1_index = train1_index + 1;
            train1_data{1, train1_index} = s;
        end
    end
end
