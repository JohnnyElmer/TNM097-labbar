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

%ad more reddish because the red spectrum is a lot wider interval on the red
%spectrum and ad2 is more greenish because it has a larger green spectrum
%and higher intensity of green

%%
%2.1  
e = ones(1,61);

NF = Ad' * e';
NF = 1./NF;
plot(NF)

figure

NF2 = Ad2' * e';
NF2 = 1./NF2;
plot(NF2)

%More green in ad2 means that we want to dampen it more, which is why the
%factor around there is lower.
%%
%2.2

RGB_cal_D65 = RGB_raw_D65.*NF;
showRGB(RGB_cal_D65');

RGB_cal2_D65 = RGB_raw2_D65.*NF2;
showRGB(RGB_cal2_D65');

%they look the same, wiiii

%%
%2.3

plot(y,CIED65)
legend('CIED65')
figure
plot(y,CIEA)
legend('CIEA')

%outdoor more blue and variable, indoor light has a softer curve and the
%red light is expressed the most.

%%
%2.4

RGB_raw1_65 = Ad' * (chips20.*CIED65)';
RGB_raw2_65 = RGB_raw1_65.*NF;
showRGB(RGB_raw2_65');

RGB_raw1_A = Ad' * (chips20.*CIEA)';
RGB_raw2_A = RGB_raw1_A.*NF;
showRGB(RGB_raw2_A');

%like we mentioned before the outdoor light is more blue in tone and the
%indoor light is more on the red side.

%%
%2.5 

R = ones(1,61);

NFR = Ad' * (R.*CIED65)';
NFR = 1./NFR;
RGB_new_raw_65 = RGB_raw_D65.*NFR;
showRGB(RGB_new_raw_65');

NFR2 = Ad' * (R.*CIEA)';
NFR2 = 1./NFR2;
RGB_new_raw2_A = RGB_raw2_A.*NFR2;
showRGB(RGB_new_raw2_A');

%we are updating a thing we should not update but fuck it, orka fixa den
%skiten nu, vi har godk??nt!

%tried looking into if we were updating anything strangely but at the most
%we update NFR and NFR2, nothing else, so either something else is
%fundamentally wrong somewhere or this is fully correct, might want to ask
%Daniel/Sasan about that
%%
%3.1
load('xyz.mat')

XYZ_norm = xyz(:,2)'*CIED65';
XYZ_norm = 100/sum(XYZ_norm);

XYZ_D65_ref = xyz' * (chips20.*CIED65)';

XYZ_cal_D65 = XYZ_D65_ref * XYZ_norm;

%pretty much the same as before but using the information/tips given in the
%lab instructions

%%
%3.2
load('M_XYZ2RGB.mat')

XYZ_obj = inv(M_XYZ2RGB)*RGB_cal_D65;

[l,a,b] = xyz2lab(XYZ_obj(1,:),XYZ_obj(2,:),XYZ_obj(3,:));

[l2,a2,b2] = xyz2lab(XYZ_cal_D65(1,:),XYZ_cal_D65(2,:),XYZ_cal_D65(3,:));

difference = sqrt((l-l2).^2 +(a-a2).^2 +(b-b2).^2);
maxVal = max(difference)
meanVal = mean(difference)

%is this acceptable? We feel yes, but would ~love~ to discuss it

%%
%3.3
plot(y,Ad(:,1),'r');
hold on
plot(y,Ad(:,2),'g');
hold on
plot(y,Ad(:,3),'b');
legend('Red','Green','Blue')

figure
plot(y,xyz(:,1),'r');
hold on
plot(y,xyz(:,2),'g');
hold on
plot(y,xyz(:,3),'b');
legend('x','y','z')

%blue channel is similar in that it has the strongest intensity and takes
%up a similar range. Green is a lot weaker and takes up a slightly
%different wavelength and red is more spread out in general. Also, the
%values given by xyz is a lot smoother.

%%
%3.4
D = RGB_cal_D65';
C = XYZ_cal_D65';
A = pinv(D)*C;

XYZ_from_RGB = D*A;

%transpose to make sure it works
XYZ_from_RGB = XYZ_from_RGB';

[ll,aa,bb] = xyz2lab(XYZ_from_RGB(1,:),XYZ_from_RGB(2,:),XYZ_from_RGB(3,:));
[ll2,aa2,bb2] = xyz2lab(XYZ_cal_D65(1,:),XYZ_cal_D65(2,:),XYZ_cal_D65(3,:));

diff = sqrt((ll-ll2).^2 +(aa-aa2).^2 +(bb-bb2).^2);
maxVal = max(diff)
meanVal = mean(diff)

%No clue why incorrect 

%%
%3.5

A2 = Optimize_poly(RGB_cal_D65,XYZ_cal_D65);
XYZ_estimation = Polynomial_regression(RGB_cal_D65, A2);

[ll,aa,bb] = xyz2lab(XYZ_estimation(1,:),XYZ_estimation(2,:),XYZ_estimation(3,:));
[ll2,aa2,bb2] = xyz2lab(XYZ_cal_D65(1,:),XYZ_cal_D65(2,:),XYZ_cal_D65(3,:));

diff = sqrt((ll-ll2).^2 +(aa-aa2).^2 +(bb-bb2).^2);
maxVal = max(diff)
meanVal = mean(diff)

%%

%3.4 & 3.5 gives same results
%3.2 completely different values
%2.1 is confusing


