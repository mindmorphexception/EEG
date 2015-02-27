function [map,lo,hi] = cubehelix(N,start,rots,hue,gamma,rng,dmn)
% Generate an RGB colormap of Dave Green's Cubehelix colorscheme. With range and domain control.
%
% (c) 2015 Stephen Cobeldick
%
% ### Function ###
%
% Returns a colormap with colors defined by Dave Green's Cubehelix colorscheme.
% The colormap nodes are selected along a tapered helix in the RGB color cube,
% with a continuous increase in perceived intensity. Black-and-white printing
% using postscript results in a monotonically increasing grayscale colorscheme.
%
% This function offers two extra controls over the Cubehelix colorscheme:
%  <rng> specifies the intensity levels of the colormap's endnodes (lightness).
%  <dmn> subsamples a part of the helix, so the endnodes are color (not gray).
% These options are both explained in the section below 'Range and Domain'.
%
% Syntax:
%  map = cubehelix;
%  map = cubehelix(N);
%  map = cubehelix(N,start,rots,hue,gamma);
%  map = cubehelix(N,start,rots,hue,gamma,rng);
%  map = cubehelix(N,start,rots,hue,gamma,rng,dmn);
%  map = cubehelix(N,[start,rots,hue,gamma],...)
%  map = cubehelix([],...)
% [map,lo,hi] = cubehelix(...)
%
% Cubehelix is defined here: http://astron-soc.in/bulletin/11June/289392011.pdf
% For more information and examples: http://www.mrao.cam.ac.uk/~dag/CUBEHELIX/
%
% See also BREWERMAP RGBPLOT COLORMAP COLORBAR SURF CONTOURF IMAGE CONTOURCMAP JET LBMAP
%
% ### Range and Domain ###
%
% Using the default <rng> and <dmn> value of [0,1] creates colormaps with
% exactly the same characteristics as Dave Green's original algorithm: the
% colormap (and the tapered-helix) begins with black, and ends with white.
%
% The range option <rng> sets the intensity level of the colormap's endnodes:
%  cubehelix(3, [0.5,-1.5,1,1], [0.2,0.8]) % rng=[0.2,0.8]
%  ans = 0.2          0.2          0.2     % <- gray, not black
%        0.62751      0.47498      0.28642
%        0.8          0.8          0.8     % <- gray, not white
%
% The domain option <dmn> sets the sampling window for the Cubehelix, such
% that the tapered-helix does not taper all the way to unsaturated (gray).
% This allows the colormap to end with colors rather than gray shades:
%  cubehelix(3, [0.5,-1.5,1,1], [0.2,0.8], [0.3,0.7]) % dmn=[0.3,0.7]
%  ans = 0.020144     0.29948      0.15693 % <- color, not gray shade
%        0.62751      0.47498      0.28642
%        0.91366      0.71351      0.95395 % <- color, not gray shade
%
% The function "colormap_view" demonstrates the effects of these options.
%
% ### Examples ###
%
% % New colors for the "colormap" example:
% load spine
% image(X)
% colormap(cubehelix)
%
% % New colors for the "surf" example:
% [X,Y,Z] = peaks(30);
% surfc(X,Y,Z)
% colormap(cubehelix([],0.7,-0.7,2,1,[0.2,0.8],[0.4,0.8]))
% axis([-3,3,-3,3,-10,5])
%
% ### Input and Output Arguments ###
%
% Inputs (*=default):
%  N     = NumericScalar, an integer to define the colormap length.
%        = *[], uses the length of the current figure's colormap.
%  start = NumericScalar, *0.5, the start color (modulus 3): R=1, G=2, B=3.
%  rots  = NumericScalar, *-1.5, the number of R->G->B rotations over the scheme length.
%  hue   = NumericScalar, *1,    controls how saturated the colors are.
%  gamma = NumericScalar, *1,    can be used to emphasize low or high intensity values.
%  rng   = NumericVector, *[0,1], range of brightness levels of the scheme's endnodes. Size 1x2.
%  dmn   = NumericVector, *[0,1], domain of the scheme calculation (endnode positions). Size 1x2.
%
% Outputs:
%  map = NumericMatrix, a colormap of RGB values between 0 and 1. Size Nx3
%  lo  = LogicalMatrix, true where <map> values<0 were clipped to 0. Size Nx3
%  hi  = LogicalMatrix, true where <map> values>1 were clipped to 1. Size Nx3
%
% [map,lo,hi] = cubehelix(N, start,rots,hue,gamma, rng, dmn)
% OR
% [map,lo,hi] = cubehelix(N, [start,rots,hue,gamma], rng, dmn)

% ### Input Wrangling ###
%
if nargin==0 || (isnumeric(N)&&isempty(N))
    N = size(get(gcf,'colormap'),1);
else
    assert(isnumeric(N)&&isscalar(N),'Input <N> must be a scalar numeric.')
    assert(isreal(N)&&N==fix(N),'Input <N> must be real and whole: %g+%gi',N,imag(N))
    N = double(N);
end
%
if N==0
    map = ones(0,3);
    lo = false(0,3);
    hi = false(0,3);
    return
end
%
% Parameters:
if nargin<2
    % Default parameter values.
    start = 0.5;
    rots  = -1.5;
    hue   = 1;
    gamma = 1;
elseif nargin<5
    % Parameters are in a vector.
    if nargin>2
        rng = rots;
    end
    if nargin>3
        dmn = hue;
    end
    assert(isnumeric(start)&&isvector(start)&&isreal(start)&&numel(start)==4,'Parameters can be in a 1x4 real numeric.')
    start = double(start);
    gamma = start(4); hue = start(3); rots = start(2); start = start(1);
else
    % Parameters as individual scalar values.
    assert(isnumeric(start)&&isscalar(start)&&isreal(start),'Input <start> must be a real scalar numeric.')
    assert(isnumeric(rots) &&isscalar(rots) &&isreal(rots), 'Input <rots> must be a real scalar numeric.')
    assert(isnumeric(hue)  &&isscalar(hue)  &&isreal(hue),  'Input <hue> must be a real scalar numeric.')
    assert(isnumeric(gamma)&&isscalar(gamma)&&isreal(gamma),'Input <gamma> must be a real scalar numeric.')
    start=double(start); rots=double(rots); hue=double(hue); gamma=double(gamma);
end
%
% Range:
if any(nargin==[0,1,2,5])
    rng = [0,1];
else
    assert(isnumeric(rng)&&isreal(rng)&&numel(rng)==2,'Input <rng> must be a 1x2 real numeric.')
    rng = double(rng);
end
%
% Domain:
if any(nargin==[0,1,2,3,5,6])
    dmn = [0,1];
else
    assert(isnumeric(dmn)&&isreal(dmn)&&numel(dmn)==2,'Input <dmn> must be a 1x2 real numeric.')
    dmn = double(dmn);
end
%
% ### Core Function ###
%
vec = linspace(dmn(1),dmn(2),abs(N)).';
ang = 2*pi * (start/3+1+rots*vec);
csm = [cos(ang),sin(ang)].';
fra = vec.^gamma;
amp = hue .* fra .* (1-fra)/2;
%
tmp = linspace(0,1,abs(N)).'.^gamma;
tmp = rng(1)*(1-tmp) + rng(2)*(tmp);
%
cof = [-0.14861,1.78277;-0.29227,-0.90649;1.97294,0];
%
vec = sign(N)*(1:abs(N)) - min(0,N-1);
for m = abs(N):-1:1
    n = vec(m);
    map(m,:) = tmp(n) + amp(n) * (cof*csm(:,n));
end
%
lo = map<0;
hi = map>1;
map = max(0,min(1,map));
%
end
%----------------------------------------------------------------------END:cubehelix