load("blade1_data.mat");

tS = point(4).time(:,2);


sf = length(tS)./max(tS);

for points = 1:10

    tempoutput = mean(point(points).output(:,:),2);
%     plot(point(points).time(:,1),tempoutput);
    hold on
    legendstrings{points}=sprintf('%s %d','Point ',points);
    



    FRF = fft(tempoutput());
    FRF = [ FRF(1) ; 2*FRF(2:end/2) ];

%     freq = (0:sf/size(FRF):sf);
%     freq = freq';
%     freq = freq(2:end) ;
    
    k= (0:(length(FRF)-1))';
    w=k*sf./length(FRF);


    set(gca, 'YScale', 'log')
    plot(w,abs(FRF))
    hold off

end
legend(legendstrings)