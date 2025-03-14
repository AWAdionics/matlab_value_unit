classdef constants_mavu
    properties (Constant)
        %MUST BE ORDERED FROM BIGGEST TO SMALLEST!
        accepted_units = {'L_brine','g_eau','mol','g','L','K','m','J','C','s'}

        %any order here
        accepted_prefixes = {'T','G','M','k','h','da',' ','d','c','m','mu','n','p'}
        prefixes_multiplier = struct('T',10^12,'G',10^9,'M',10^6,'k',10^3, ...
                                    'h',10^2,'da',10^1,'d',10^(-1), ...
                                    'c', 10^(-2),'m',10^(-3),'mu',10^(-6), ...
                                    'n', 10^(-9),'p',10^(-12))
       
    end
end