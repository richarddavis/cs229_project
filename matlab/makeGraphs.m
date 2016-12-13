model_labels = {'Always 1', 'Naive\newlineBernoulli', ...
  'Logistic\newlineRegression', 'BKT', ...
  'Clustered\newlineBKT'};

bar(mses);
title('MSEs of Predicted Probabilities against Student Responses');
xlabel('Prediction model');
ylabel('MSE');
legend(data_set_names);
set(gca, 'XTickLabel', model_labels);
saveas(gcf,'graphs/MSEs.png');
close;

bar(error_rates);
title('Error rates for predicted student responses');
xlabel('Prediction model');
ylabel('Error rate');
legend(data_set_names);
set(gca, 'XTickLabel', model_labels);
saveas(gcf,'graphs/Error_rates.png');
close;

bar(ROC_AUCs);
title('AUROCs of Predictions against Student Resposnes');
xlabel('Prediction model');
ylabel('MSE');
legend(data_set_names);
set(gca, 'XTickLabel', model_labels);
saveas(gcf,'graphs/AUROCs.png');
close;

for data_set_num = 1:num_data_sets
  hold on;
  for model_num = 1:num_models
    X = ROC_Xs{model_num, data_set_num};
    Y = ROC_Ys{model_num, data_set_num};
    plot(X,Y);
  end
  t = sprintf('ROC curves for models on %s', data_set_names{data_set_num});
  title(t);
  legend(data_set_names);
  legend('Location','southeast');
  xlabel('False positive rate');
  ylabel('False negative rate');
  %legend(model_names);
  f = sprintf('graphs/roc_%s.jpg', data_set_names{data_set_num});
  saveas(gcf,f);
  hold off;
  close;
end
