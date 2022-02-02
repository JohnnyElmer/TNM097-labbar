function [lin] = linearization(im, TCRr, TCRg, TCRb)

x = 0:0.01:1;

lin(:,:,1) = interp1(TCRr, x, im(:,:,1), 'pchip');
lin(:,:,2) = interp1(TCRg, x, im(:,:,2), 'pchip');
lin(:,:,3) = interp1(TCRb, x, im(:,:,3), 'pchip');

end