clear all
clear figure
%Load Data
load("blade1_data.mat");
%Time step
tS = point(4).time(:,2);
%Sample Freq
sf = length(tS)./max(tS);

[modal_nf_blade1, modal_dr_blade1,modeshapes_blade1] = bladeanalysis(sf,point)

load("blade2_data.mat");

[modal_nf_blade2, modal_dr_blade2,modeshapes_blade2] = bladeanalysis(sf,point)

MAC_matrix = (modeshapes_blade1'*modeshapes_blade2)/((modeshapes_blade1'*modeshapes_blade1)*(modeshapes_blade2'*modeshapes_blade2))


function [nfOutput, dampingOutput,modalshapes] = bladeanalysis(sf,point)
%for all points
for points = 1:10

    tempoutput = point(points).output(:,:);
    tempinput = point(points).input(:,:);

    N = length(tempoutput);

    outFFT = fft(tempoutput())/N;
    inFFT = fft(tempinput())/N;
    tempFRF = outFFT./inFFT;

    FRF = mean(tempFRF,2);

    FRF = [ FRF(1) ; 2*FRF(2:end/2) ];


    w=(0:(N/2-1))'*sf/N;

    % FINDING PEAKS
    [pks,locs] = findpeaks(abs(FRF),'MinPeakDistance',50);

    [pks,locs] = findpeaks(pks,locs,'MinPeakHeight',0.5);

    w_peaks(points,:)= w(locs(1:5));

    FRFsign(points,:) = sign(angle(FRF(locs(1:5))));

    peakFRF(points,:)=pks(1:5);

    %Graphing Peaks
    figure(1)
    hold on
    set(gca, 'YScale', 'log')
    semilogy(w,abs(FRF))
    plot(w(locs),pks,'or')
    xlim([0 1000])
    hold off

    

    %for Peaks 1 to 5
    for pkNum = 1:5
        %         figure(2)

        u = locs(pkNum);

        halfPower = pks(1:5)./sqrt(2);
        %          subplot(5,1,pkNum)

        %          plot(w(u-100:u+100),abs(FRF(u-100:u+100))./max(abs(FRF(u-100:u+100))))

        %Linear Inter
        %Interpolating either side of the peak
        LbInterp = interp1(abs(FRF(u-100:u)),w(u-100:u),halfPower(pkNum));
        UbInterp = interp1(abs(FRF(u:u+100)),w(u:u+100),halfPower(pkNum));

        dampingRatio(points,pkNum) = (UbInterp-LbInterp)./(2*w(u));


    end
    

    figure(2)
    %     subplot(10,1,points)
    hold on
    plot(w,angle(FRF))
    xlim([0 1000])
    hold off
    
    %Plot Phases
    figure(3)
    imagFRF = imag(FRF);
    hold on
    plot(w,imag(FRF))
    plot(w(locs),imagFRF(locs),'or')
    xlim([0 1000])

    hold off


end
    %Output Values
    resW = mode(w_peaks,[1 5]);
    dampingOutput = median(dampingRatio,[1 5]);
    nfOutput = resW;
    
    %Defineing Lambda
    lamda = resW.*resW;

for n=1:10
    %Damping r times lambda r 
    dampXlambdaR = 2.*(lamda.*dampingOutput);
    %The combined lambda
    modalshapesJK(n,:) = peakFRF(n,:).*2.*(lamda.*dampingOutput);

end

%Definging first row with square root
modalshapes(1,:) = sqrt(modalshapesJK(1,:));

for n=2:size(modalshapesJK,1)
    %Dividing other units by top row 
    modalshapes(n,:) = modalshapesJK(n,:)./modalshapes(1,:);
    %sign bit
end

    modalshapes = modalshapes.*FRFsign;

end
