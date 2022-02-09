function [ filtered ] = rgb_filter( img )
%RGB_FILTER Summary of this function goes here
%   Detailed explanation goes here
f=MFTsp(15,0.0847,500);
% Denna funktion returnerar ett lågpass filter som representerar ögat. I
% detta fall betraktningsavståndet har satts till 500 mm och punkternas
% storlek till 0.0847. Observera att punktens storlek motsvarar ett tryck
% i 300 dpi. (0.0847 = 1/300 * 25.4 mm)


% Ögats filter är applicerat till signalen (originalbilden)
filtered(:,:,1) = conv2(img(:,:,1), f, 'same');
filtered(:,:,2) = conv2(img(:,:,2), f, 'same');
filtered(:,:,3) = conv2(img(:,:,3), f, 'same');

% no negative rgb values
filtered(:,:,1) = (filtered(:,:,1) > 0) .* filtered(:,:,1);
filtered(:,:,2) = (filtered(:,:,2) > 0) .* filtered(:,:,2);
filtered(:,:,3) = (filtered(:,:,3) > 0) .* filtered(:,:,3);

end