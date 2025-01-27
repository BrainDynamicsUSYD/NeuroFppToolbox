% CH4Fig9
figure_width = 11.4; % cm
figure_hight = 11.4; % cm
figure('NumberTitle','off','name', 'CH4Fig9', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!

dir_strut = dir('*_RYG.mat');
num_files = length(dir_strut);
files = cell(1,num_files);
for id_out = 1:num_files
    files{id_out} = dir_strut(id_out).name;
end
% dir_strut2 = dir('*_config_data.mat');
% num_files2 = length(dir_strut2);
% files2 = cell(1,num_files2);
% for id_out = 1:num_files2
%     files2{id_out} = dir_strut2(id_out).name;
% end
bin = 500; % 4ms
hw = 31;
[Lattice,~] = lattice_nD(2, hw);
xr = [];
yr = [];
no = 1;
Coor = [0;0];
LoalNeu = cell(1);
R = load(files{1});
for i = 1
    dist = Distance_xy(Lattice(:,1),Lattice(:,2),Coor(1,i),Coor(2,i),2*hw+1); %calculates Euclidean distance between centre of lattice and node j in the lattice
    LoalNeu{i} = find(dist<=R.ExplVar.AreaR)';
end
for id_out = 1:100 % num_files
    fprintf('Processing output file No.%d out of %d...\n', id_out, num_files);
    fprintf('\t File name: %s\n', files{id_out});
    R = load(files{id_out});
    %     fprintf('\t File name: %s\n', files2{id_out}); % id_out-11
    %     load(files2{id_out},'StiNeu')
    StiNeu = LoalNeu;        
    LoadC = [];
    RecallC = [];
    r = sum(movsum(full(R.spike_hist{1}(StiNeu{no},:)),bin,2));
    candx = Lattice(StiNeu{no},1);
    candy = Lattice(StiNeu{no},2);
    for i = 2e4:2.25e4
        if r(i) > 50 % 30 % 60pr
            spike_x_pos_o = repmat(candx,1,bin).*R.spike_hist{1}(StiNeu{no},i-bin/2+1:i+bin/2);
            spike_x_pos_o = spike_x_pos_o(R.spike_hist{1}(StiNeu{no},i-bin/2+1:i+bin/2));
            spike_y_pos_o = repmat(candy,1,bin).*R.spike_hist{1}(StiNeu{no},i-bin/2+1:i+bin/2);
            spike_y_pos_o = spike_y_pos_o(R.spike_hist{1}(StiNeu{no},i-bin/2+1:i+bin/2));
            [x,y,~,~,~,~] = fit_bayesian_bump_2_spikes_circular(spike_x_pos_o,spike_y_pos_o,2*hw+1,'quick');
            LoadC = [LoadC;x y length(spike_x_pos_o)];
        end
    end
    for i = 2.26e4:length(r)-bin/2 % 4.46e4 % length(r) % 
        if r(i) >= 120 % >25
            % neurons within WM area
            spike_x_pos_o = repmat(candx,1,bin).*R.spike_hist{1}(StiNeu{1},i-bin/2+1:i+bin/2);
            spike_x_pos_o = spike_x_pos_o(R.spike_hist{1}(StiNeu{1},i-bin/2+1:i+bin/2));
            spike_y_pos_o = repmat(candy,1,bin).*R.spike_hist{1}(StiNeu{1},i-bin/2+1:i+bin/2);
            spike_y_pos_o = spike_y_pos_o(R.spike_hist{1}(StiNeu{1},i-bin/2+1:i+bin/2));
            [x,y,~,~,~,~] = fit_bayesian_bump_2_spikes_circular(spike_x_pos_o,spike_y_pos_o,2*hw+1,'quick');
            RecallC = [RecallC;x y length(spike_x_pos_o) i];
        end
    end
    [x,y,~,~,~,~] = fit_bayesian_bump_2_spikes_circular(candx,candy,2*hw+1,'quick');
    % Load Center
    ind = find(LoadC(:,3) == max(LoadC(:,3)));
    xl = mean(LoadC(ind,1));
    yl = mean(LoadC(ind,2));
    % Recall Centers
    xtemp = [];
    ytemp = [];
    num = [];
    for i = 1:size(RecallC,1)
        xtemp = [xtemp RecallC(i,1)];
        ytemp = [ytemp RecallC(i,2)];
        num = [num RecallC(i,3)];
        if (i==size(RecallC,1)) || RecallC(i+1,4)-RecallC(i,4) > 1
            ind = find(num == max(num));
            xr = [xr mean(xtemp(ind))];
            yr = [yr mean(ytemp(ind))];
            xtemp = [];
            ytemp = [];
            num = [];
        end
    end
end
y0 = y;
%
subplot(2,2,1)
plot(xr,yr,'b.',xl,yl,'r>',x,y0,'r*')
xlim([-31,31]) % ([-31,31]) % ([-17 -15])
ylim([-31,31]) % ([-31,31]) % ([-17 -15])
xlabel('x','fontSize',10)
ylabel('y','fontSize',10)
text(-0.1,1,'A','Units', 'Normalized','FontSize',12)
hold on;
axes('Position',[.3 .7 .15 .15])
box on
plot(xr,yr,'b.',xl,yl,'r>',x,y0,'r*')
xlim([-0.6,0.6]) % ([-1,1]) % ([-17 -15])
ylim([-0.6,0.6]) % ([-1,1]) % ([-17 -15])
xlabel('x')
ylabel('y')
%%
subplot(2,2,2)
% figure
Color = [0.93 0.69 0.13;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
i = 1;
edges = -1.5:0.05:1.5;
[N,edges] = histcounts(Ceny{i}(:),edges,'Normalization','probability'); % ,edges
edges = (edges(1:end-1)+edges(2:end))/2;
plot(edges,N,'o','color',Color(i,:))
hold on
edges = -1.5:0.05:1.5;
[N,edges] = histcounts(Ceny{i}(:),edges,'Normalization','probability'); % ,edges
edges = (edges(1:end-1)+edges(2:end))/2;
pd = fitdist(Ceny{i}(:),'normal')
y = pdf(pd,edges);
plot(edges,y/sum(y),'-','color',Color(i,:));
xlabel('y-Error','fontSize',10)
ylabel('Probability','fontSize',10)

% edges = linspace(-1,1,31); % 1:[-1,1]; 2:[-24,-22]; 3&4&5:[-17,-15];
% [xN,edges] = histcounts(xr,edges,'Normalization','probability');
% p = (edges(1:end-1)+edges(2:end))/2;
% pd = fitdist(xr','Normal');
% y = pdf(pd,p);
% plot(p,xN,'b.',p,y/sum(y),'r--','MarkerSize',8,'LineWidth',2)
% xlabel('Position on x axis','fontSize',10)
% ylabel('Probability','fontSize',10)
text(-0.1,1,'B','Units', 'Normalized','fontSize',12)
%%
subplot(2,2,3)
Color = [0.93 0.69 0.13;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
heiy = zeros(1,7);
STDy = zeros(1,7);
for i = 1:7 % :7
    edges = -1.5:0.05:1.5;
    [N,edges] = histcounts(Ceny{i}(:),edges,'Normalization','probability'); % ,edges
    edges = (edges(1:end-1)+edges(2:end))/2;
    pd = fitdist(Ceny{i}(:),'Normal')
    STDy(i) = pd.sigma;
    y = pdf(pd,edges);
    heiy(i) = max(y/sum(y));
    plot(edges,y/sum(y),'-.','color',Color(i,:));
    hold on
end
xlabel('y-Error','fontSize',10)
ylabel('Probability','fontSize',10)
legend('1-item','2-item','3-item','4-item','5-item','6-item','7-item')

% edges = linspace(-1,1,31); % 1:[-1,1]; 2:[-24,-22]; 3&4&5:[-17,-15];
% [xN,edges] = histcounts(xr,edges,'Normalization','probability');
% p = (edges(1:end-1)+edges(2:end))/2;
% pd = fitdist(xr','Normal');
% y = pdf(pd,p);
% plot(p,xN,'b.',p,y/sum(y),'r--','MarkerSize',8,'LineWidth',2)
% xlabel('Position on x axis','fontSize',10)
% ylabel('Probability','fontSize',10)
text(-0.1,1,'C','Units', 'Normalized','fontSize',12)
%%
% subplot(2,1,2)
% cd ..
% load('1-7Items.mat')
% x = [1,2,4,7];
% v1 = polyfit(log10(x),log10(FitHeightWithin2s(x)/FitHeightWithin2s(1)),1);
% x1 = 1:0.1:10;
% y1 = 10^v1(2)*x1.^v1(1);
% plot(x,FitHeightWithin2s(x)/FitHeightWithin2s(1),'k.','MarkerSize',10)
% hold on
% plot(x1,y1,'b-') %  
% xlabel('Loading Items')
% ylabel('Precision Index')
%
% subplot(2,1,2)
% load('1-7Items.mat')
% MeanDuration = cellfun(@mean,Duration)*1e-3; % s
% MeanDuration = vec2mat(MeanDuration,100);
% dur = mean(MeanDuration,2);
% STD = std(MeanDuration,0,2);
% yyaxis left
% plot(1:7,FitHeightWithin2s,'>-','LineWidth',1.5) % 'MarkerSize',8,
% ylabel('Height of Precision Curve','fontsize',10)
% yyaxis right
% errorbar(1:7,dur,STD,'o-','LineWidth',1.5)
% xlabel('Loading Items','fontSize',10)
% ylabel('Mean Recall Duration(s)','fontSize',10)
% text(-0.1,1,'C','Units', 'Normalized','fontSize',12)
% subplot(2,2,4)
STDymat = zeros(7,10);
STDy = zeros(1,7);
for i = 1:7 % :7
    group = 1:floor(length(Ceny{i}(:))/10):length(Ceny{i}(:));
    pd = fitdist(Ceny{i}(:),'Normal');
    STDy(i) = pd.sigma; % 1/pd.sigma^2;
    for j = 1:length(group)-1
    pd = fitdist(Ceny{i}(group(j):group(j+1))','Normal'); % 'Normal'
    STDymat(i,j) = pd.sigma; % 1/pd.sigma^2;
    end
end
IE = 1:7;
s = std(STDymat,0,2);
errorbar(1:7,STDy,s,'o')
NP = STDy; % heiy; % (heix + heiy)/2;
% NP = NP/NP(1);
v2 = polyfit(log10(IE),log10(NP),1);
x2 = IE;
y2 = 10^v2(2)*x2.^v2(1);
hold on
plot(x2,y2,'LineWidth',1.5)
xlabel('WM items','fontSize',10)
ylabel('SD','fontSize',10) % Precision
legend('sd','power-law fit') % precision
text(-0.1,1,'D','Units', 'Normalized','fontSize',12)
%%
set(gcf, 'PaperPositionMode', 'auto'); % this is the trick!
print -depsc CH4Fig9