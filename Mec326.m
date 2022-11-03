load("blade1_data.mat");

tS = point(4).time(:,2);

sf = size(tS)./abs(max(tS));

for points = 1:10

    tempoutput = mean(point(points).output(:,:),2);
%     plot(point(points).time(:,1),tempoutput);
    hold on
    legend
    FRF = fft(tempoutput());
    FRF = [ FRF(1) ; 2*FRF(2:end/2) ];


    size(FRF)
    freq = (0:sf/size(FRF):sf);
    freq = freq';
    freq = freq(2:end) ;

    set(gca, 'YScale', 'log')
    plot(freq(1:end),abs(FRF))
   

end