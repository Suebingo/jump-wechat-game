function [f] = circle( f, i, j, r, v)  
    for a = i-r : i+r
        for b = j-r : j+r
            f(a, b) = v;
        end
    end
end 