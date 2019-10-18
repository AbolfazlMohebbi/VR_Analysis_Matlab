function y = DetrendPoly(varargin)
%DETRENDPOLY detrends data using polyfit and polyval
%
if (length(varargin)< 2)
     x = varargin{1};
     PolyOrder = 9;
else  
    x = varargin{1};
    PolyOrder = varargin{2};
    
end

t = (1:length(x));
[p,s,mu] = polyfit(t, x, PolyOrder);
f_y = polyval(p,t,[],mu);
y = x - f_y;

end

