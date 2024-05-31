%% clear workspace
close all; clear; clc;

%% saturation function
x = linspace(-10,10,1000);
saturated_x = min(1, max(-1, x));
saturated_x2 = min(1, max(-1, 2*x));
saturated_x3 = min(1, max(-1, 100*x));
figure;
plot(x,saturated_x)
axis([-10.1 10.1 -1.1 1.1])
grid on;


%% modified sigmoid
y = -1+2./(1+exp(-x));
y1 = -1+2./(1+exp(-5*x));
y2 = -1+2./(1+exp(-10*x));
y3 = -1+2./(1+exp(-100*x));
figure;
plot(x,y,x,y1,x,y2,x,y3)

%% trig approximation
z = tanh(2*x/1);
figure;
plot(x,z)
