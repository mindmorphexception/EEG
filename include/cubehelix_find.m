function [vec,rng,dmn,resnorm] = cubehelix_find(map,pos,prm)
% Return parameter values for the Cubehelix colorscheme that matches the input colormap.
%
% (c) 2015 Stephen Cobeldick
%
% So you have a nice Cubehelix colormap but you can't remember the exact
% parameter values that were used to define it, or perhaps you want to match
% a Cubehelix scheme to your document's chosen colorscheme: this function can
% help! An optimzation routine finds the Cubehelix colorscheme that best matches
% the input RGB colormap, and returns its parameter values (takes a few seconds).
%
% Syntax:
%  [vec,rng,dmn] = cubehelix_find(map)
%  [vec,rng,dmn] = cubehelix_find(map,pos)
%  [vec,rng,dmn] = cubehelix_find(map,pos,prm)
%
% Note1: Requires the Optimization Toolbox function "lsqnonlin".
% Note2: The parameter <start> is modulus three, i.e. 3==0.
% Note3: The search bounds are lb=[0,-20,0,0,0,0,0,0] and ub=[3,+20,3,3,1,1,1,1];
%
% See also CUBEHELIX BREWERMAP RGBPLOT COLORMAP LSQNONLIN OPTIMSET
%
% ### Matching a Colorscheme ###
%
% The basic syntax assumes that the input colormap is a Cubehelix colormap:
%  [vec,rng,dmn] = cubehelix_find(map)
%
% You can also find the closest Cubehelix colorscheme that matches a
% colormap of arbitrary colors (e.g. a corporate or document colorscheme).
% This can be achieved by suppling a colormap of the desired colors, and a
% vector giving their relative positions in the final Cubehelix colorscheme:
%
% map = [0.16,0.59,0.87; 0.78,0.55,0.35; 0.78,0.9,0.9]; % three nodes
% pos = [0.25,0.5,0.75]; % relative positions of the three <map> nodes
% [vec,rng,dmn] = cubehelix_find(map,pos);
% cubehelix_view(5,vec,rng,dmn)
%
% ### Holding Parameter Values Constant ###
%
% In some situations it may be desirable to force some parameter values to
% stay constant. The third (optional) input can be used to specify any of
% the eight parameter values, other values to be determined are set to NaN:
%
% prm = [NaN,NaN,NaN,1,NaN,NaN,0,1]; % constant gamma=1 and domain=[0,1]
% [vec,rng,dmn] = cubehelix_find(map,pos,prm);
% cubehelix_view(5,vec,rng,dmn)
%
% ### Examples ###
%
% cubehelix_find(cubehelix(10))
%  ans = [0.5,-1.5,1,1]
%
% map = cubehelix(10, 1.4,-0.7,0.9,1.2, [0.05,0.97]);
% [vec,rng,dmn] = cubehelix_find(map)
%  vec = [1.4,-0.7,0.9,1.2]
%  rng = [0.05,0.97]
%  dmn = [0,1]
%
% map = cubehelix(64, [2.3,0.4,0.5,0.6], [0.05,0.24], [0.19,0.85]);
% [vec,rng,dmn] = cubehelix_find(map)
%  vec = [2.3,0.4,0.5,0.6]
%  rng = [0.05,0.24]
%  dmn = [0.19,0.85]
%
% ### Input and Output Arguments ###
%
% Inputs (*=default):
%  map = NumericMatrix, an RGB colormap to be matched to a Cubehelix colorscheme.
%  pos = NumericVector, the relative positions of the nodes in <map>. Size 1xrows(map).
%  prm = NumericVector, vector of Cubehelix parameters to keep constant. Size 1x8.
%        parameters=[start,rots,hue,gamma,range,domain], NaN indicates non-constant values.
% Outputs:
%  vec = NumericVector, the Cubehelix parameters derived from <map>: [start,rots,hue,gamma].
%  rng = NumericVector, range of brightness levels of the scheme's endnodes. Size 1x2.
%  dmn = NumericVector, domain of the scheme calculation (endnode positions). Size 1x2.
%
% [vec,rng,dmn] = cubehelix_find(map,*pos,*prm)

% ### Input Wrangling ###
%
siz = size(map);
assert(isnumeric(map)&&ismatrix(map)&&siz(2)==3&&isreal(map)&&all(0<=map(:)&map(:)<=1),...
    'Input argument <map> must be a colormap of RGB values (size Nx3).')
% Grayscale colormap equivalent:
map = double(map);
mag = map*[0.298936;0.587043;0.114021];
%
R = size(map,1);
%
if nargin>2
    assert(isnumeric(prm)&&isvector(prm)&&isreal(prm)&&numel(prm)==8,...
        'Input argument <prm> must be a real numeric vector of size 1x8.')
    idx = isnan(prm);
    if ~any(idx)
        vec = prm(1:4);
        rng = prm(5:6);
        dmn = prm(7:8);
        resnorm = NaN;
        return
    end
    X = @(p)p(idx);
else
    idx = true(1,8);
    X = @(p)p;
end
%
% ### "lsqnonlin" Parameter Bounds ###
%
if R>2 % default algorithm cannot solve <3 colormap rows
    lb = X([0,-20,0,0,0,0,0,0]);
    ub = X([3,+20,3,3,1,1,1,1]);
    opt = optimset('Display','off', 'Algorithm','trust-region-reflective');
else % no bounds allowed for this algorithm
    lb = [];
    ub = [];
    opt = optimset('Display','off', 'Algorithm','levenberg-marquardt');
end
%
% ### Indexing for Sample Colors ###
%
if nargin>1 && ~isempty(pos) % sampled colors
    assert(isnumeric(pos)&&isvector(pos)&&isreal(pos)&&all(0<=pos&pos<=1)&&numel(pos)==R,...
        'Input argument <pos> is a vector of the relative position in the colorscheme of each <map> node.')
    [N,D] = rat(pos);
    P = prod(D);
    Y = N.*(P./D);
    E = @(m)m(Y,:);
else % complete Cubehelix colormap
    P = R;
    E = @(m)m;
end
%
% ### Define Solver Function ###
%
G = @(p)map-E(cubehelix(P,p(1:4),p(5:6),p(7:8)));
if nargin>2
    F = @(p)G(chfSubs(real(p),prm,idx));
else
    F = @(p)G(real(p));
end
%
% ### Find Optimum ###
%
% Estimate rotations from the number of peaks&troughs:
D = diff(bsxfun(@minus,map,mag),1,1);
idy = D(1:end-1,:)>=0 & D(2:end,:)<0;
idz = D(1:end-1,:)<0 & D(2:end,:)>=0;
rots = ceil(mean(sum([idy,idz],1)));
%
% Range of start and rotation values to try:
Sm = linspace(0,3-eps,(1+rots)*7);
Rm = rots*[1;-1]*[0.7,1,1.3];
Rm = [0;Rm(:)];
[Sm,Rm] = meshgrid(Sm(1:max(1,idx(1)*end)),Rm(1:max(1,idx(2)*end)));
% Solve!
[Zc,rn] = arrayfun(@(s,r)lsqnonlin(F,X([s,r,1,1,0,1,0,1]),lb,ub,opt), Sm,Rm, 'UniformOutput',false);
% Pick the best solution:
[resnorm,idz] = min([rn{:}]);
if nargin>2
    out(idx) = real(Zc{idz});
    out(~idx) = prm(~idx);
else
    out = real(Zc{idz});
end
dmn = out(7:8);
rng = out(5:6);
vec = out(1:4);
vec(1) = mod(vec(1),3);
% Residual norm per row:
resnorm = resnorm / R;
%
end
%----------------------------------------------------------------------END:cubehelix_find
function q = chfSubs(p,v,idx)
% Zip together contsant and non-constant parameter values.
%
q(idx) = p;
q(~idx) = v(~idx);
%
end
%----------------------------------------------------------------------END:chfSubs