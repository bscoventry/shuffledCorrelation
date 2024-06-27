%----------------------------------------------------------------------------------------------------------------------
% Author: Brandon S Coventry         Wisconsin Institute for Translational Neuroengineering
% Date: 06/27/24
% Purpose: This performs a shuffled R test to establish significance of correlation coefficients. For other use cases,
%          see Coventry et al (2024) PNAS Nexus 3(2).
% Revision History: N/A
%----------------------------------------------------------------------------------------------------------------------
function [R,pvalue] = shuffledCorrelation(timeseries1,timeseries2,numShuff,useParallel)
% This function takes in 2 timeseries variables. It first calculates the direct R. Then, it shuffles timeseries 2 numShuff
% times and calculates an empiracle p-value. numShuff should be large to adequately sample the null distirbution. I Start
% with 5000. If useParallel == 1, use Matlab parallel computing toolbox. Set to 0 otherwise.
expR = corrcoef(timeseries1,timeseries2);
R = expR(1,2);
shufLen = length(timeseries1);
RCounter = 0;
if useParallel==1
    parfor ck = 1:numShuff
        shufIDX = randperm(shufLen);
        ts2 = timeseries2(:,shufIDX);           %Shuffle timeseries 2
        Remp = corrcoef(shufIDX,ts2);
        Remp = Remp(1,2);
        if Remp>R
            RCounter = RCounter + 1;
        end
    end
    pvalue = RCounter./numShuff;                %Empiracle p-value
else
    for ck = 1:numShuff
        shufIDX = randperm(shufLen);
        ts2 = timeseries2(:,shufIDX);           %Shuffle timeseries 2
        Remp = corrcoef(shufIDX,ts2);
        Remp = Remp(1,2);
        if Remp>R
            RCounter = RCounter + 1;
        end
    end
    pvalue = RCounter./numShuff;                %Empiracle p-value
end