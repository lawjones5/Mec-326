% point = get_tap_test_data;

tS = point(4).time(:,2);

sf = size(tS)./abs(max(tS));
for avg 1to8
    plot(point(1).time(),point(1).output());
    legend
end