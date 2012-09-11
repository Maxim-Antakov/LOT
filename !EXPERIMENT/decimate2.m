function NI = decimate2(I, m, n)
[M, N] = size(I);
kx = M/m;
ky = N/n;
fx = 1/M;
fy = 1/N;
fsr_x = fx/2/kx;
fsr_y = fy/2/ky;

I_shift = fftshift(I);
FI = fft2(I_shift);

[f1,f2] = freqspace([M N],'meshgrid');
Hd = zeros(M,N); 
Hd = (abs(f1)<20*fsr_x).*(abs(f2)<20*fsr_y);
mesh(f1,f2,Hd)
nFI = FI.*Hd;
nI = ifft2(nFI);
nI = ifftshift(nI);
nI = nI.*conj(nI);
figure
imagesc(nI)