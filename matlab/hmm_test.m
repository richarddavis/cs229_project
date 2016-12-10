trans = [0.95,0.05;
      0.10,0.90];
emis = [1/6, 5/6,;
   5/6, 1/6];

seq1 = hmmgenerate(100,trans,emis);
seq12 = [seq1(1:50) repmat(NaN,1,100) seq1(51:100)]
seq2 = hmmgenerate(200,trans,emis);
seq22 = [seq2(1:100) repmat(NaN,1,100) seq2(101:200)]
seqs = {seq1,seq2};
[estTR,estE] = hmmtrain(seqs,trans,emis)