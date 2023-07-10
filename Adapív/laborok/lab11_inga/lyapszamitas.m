clc;
close all;
clear all;
om=3;
si=1;
Am=[0 1;
    -om^2 -si*om];
Q=eye(2);
p=lyap(Am,eye(2));
