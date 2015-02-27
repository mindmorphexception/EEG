function [p,f] = doftest(model)
%copied from fTest.m

% F test for whole model (assumes constant term)
ssr = model.SST - model.SSE;
nobs = model.NumObservations;
dfr = model.NumEstimatedCoefficients - 1;
dfe = nobs - 1 - dfr;
f = (ssr./dfr) / (model.SSE/dfe);
p = fcdf(1./f,dfe,dfr); % upper tail
end
