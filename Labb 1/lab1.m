%Load the ad matrices
load('Ad.mat')
load('Ad2.mat')

%%
%1.1, comparing sensitivities of two different rgb cameras

y = 400:5:700;

plot(y,Ad(:,1),'r');
hold on
plot(y,Ad(:,2),'g');
hold on
plot(y,Ad(:,3),'b');
legend('Red','Green','Blue')

figure

plot(y,Ad2(:,1),'r');
hold on
plot(y,Ad2(:,2),'g');
hold on
plot(y,Ad2(:,3),'b');
legend('Red','Green','Blue')

%They are most likely NOT going to look EXACTLY the same, since ad2 has
%more red and green in comparison to ad. But they are rather likely to look
%similar.

%%
%1.2 comparing rgb outputs for the different cameras. 
load('chips20.mat')
load('illum.mat')


RGB_raw_D65 = Ad' * (chips20.*CIED65)';
showRGB(RGB_raw_D65');

RGB_raw2_D65 = Ad2' * (chips20.*CIED65)';
showRGB(RGB_raw2_D65');

