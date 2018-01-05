function [f] = specialcase(f)
    [a,b,c] = size(f);
    for i = 1:a
        for j = 1:b
            if f(i,j, 1) == 255 && f(i,j,2) == 238 && f(i,j,3) == 97 || f(i,j, 1) == 186 && f(i,j,2) == 240 && f(i,j,3) == 68
                f(i,j,1) = 100;
                f(i,j,2) = 149;
                f(i,j,3) = 105;
            end
        end
    end
end

