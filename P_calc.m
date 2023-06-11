function P = P_calc(F,F_abs)
    for i = drange(1:10)
        P(i) = abs(F(i)/sum(F_abs));
    end
end

