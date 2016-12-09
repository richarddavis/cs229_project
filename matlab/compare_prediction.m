function [true_pos, true_neg, false_pos, false_neg] = compare_prediction(test_seq, predicted_seq)
    true_pos = 0;
    false_pos = 0;
    true_neg = 0;
    false_neg = 0;

    comparison = predicted_seq - test_seq;
    for i = 1:numel(comparison)
       if comparison(1,i) == 0
           if test_seq(1,i) == 1
               true_neg = true_neg + 1;
           else
               true_pos = true_pos + 1;
           end
       else
           if test_seq(1,i) == 1
               false_pos = false_pos + 1;
           else
               false_neg = false_neg + 1;
           end
       end 
    end
end