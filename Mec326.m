clear all
clear figure

load("blade1_data.mat");

tS = point(4).time(:,2);


sf = length(tS)./max(tS);

for points = 1:10
    
%     tempoutput = mean(point(points).output(:,:),2);
    hold on

    tempoutput = point(points).output(:,:);
%     legendstrings{points}=sprintf('%s %d','Point ',points);

    N = length(tempoutput);

    tempFRF = fft(tempoutput())/N;
    FRF = mean(tempFRF,2);
    
    FRF = [ FRF(1) ; 2*FRF(2:end/2) ];

%     k= (0:(N-1))';
%     w=k*sf./N;
    w=(0:(N/2-1))'*sf/N;

    set(gca, 'YScale', 'log')
    %     plot(w,abs(FRF))
    xlim([0 1000])

% FINDING PEAKS
    [pks,locs] = findpeaks(abs(FRF),'MinPeakDistance',100);
    

    [pks,locs] = findpeaks(pks,locs);
    w_peak= w(locs);

    plot(w,abs(FRF),w(locs),pks,'or')





end
% legend(legendstrings)