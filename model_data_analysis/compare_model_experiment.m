%compare model data with experimental data
[v,loop_number] = CollectVectorYG('grid','grid.jump_dist');
a = 10^(-3)*[2.04 4.38 6.33 6.82 9.40 9.15 9.88 10.1 11.9 10.9 12.0 12.0 13.8 12.6 12.6 13.0 13.9 13.1 11.6 11.2 12.0 10.9 10.5 10.3 10.4 9.40 11.4 10.6 10.3 9.93 8.91 8.71 8.37 9.25 8.42 8.03 7.84 7.89 7.98 8.13 6.91 6.57 7.30 7.45 7.01 7.01 7.06 6.33 6.23 5.99 5.45 5.65 6.67 5.74 5.65 4.92 4.82 5.11 5.06 4.92 5.26 4.43 5.26 5.60 4.63 4.43 4.48 4.43 3.89 3.65 4.43 4.19 4.14 3.51 3.36 4.28 3.07 3.31 3.12 2.82 3.55 2.92 3.26 3.31 2.39 3.36 3.21 2.58 2.48 2.68 3.07 2.58 3.12 2.73 3.31 3.12 2.53 2.87 2.43 2.19 2.92 2.09 2.92 2.29 2.19 2.34 2.43 2.48 1.75 2.87 2.19 2.04 1.85 2.14 1.46 2.43 2.24 1.95 2.00 2.29 1.95 2.00 1.36 2.14 2.04 1.95 1.70 1.70 2.19 2.00 1.75 1.66 1.61 1.41 1.70 1.36 1.41 1.75 1.56 1.46 0.78 1.75 1.61 1.36 1.51 1.75 1.75 1.56 1.66 1.61];
j = 1;
for i = [6,12,18,24];
    [N,bins] = hist(v(loop_number >= (10*i - 9) & loop_number <= 10*i),500);
    p = N/sum(N);
    figure(1)
    subplot(2,2,j)
    b1 = bar(0.1*(1:150),a,'histc');
    b1.FaceAlpha = 0.2;
    hold on;
    b2 = bar(bins,p,'histc');
    b2.FaceAlpha = 0.2;
    axis([0 15 0 0.05]);
    hold off;
    j = j + 1;
end