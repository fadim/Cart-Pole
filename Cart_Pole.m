function [x,x_dot,theta,theta_dot]=Cart_Pole(action,x,x_dot,theta,theta_dot)

% Sistem parametreleri

g=9.8;              %Gravity
Mass_Cart=1.0;      %Mass of the cart 
Mass_Pole=0.1;      %Mass of the pole 
Total_Mass=Mass_Cart+Mass_Pole;
Length=0.5;         %Length of the pole 
PoleMass_Length=Mass_Pole*Length;
Force_Mag=10.0;
Tau=0.02;           %Time step
Fourthirds=1.3333333;


if action>0,
    force=Force_Mag;
else
    force=-Force_Mag;
end

temp = (force + PoleMass_Length *theta_dot * theta_dot * sin(theta))/ Total_Mass;

thetaacc = (g * sin(theta) - cos(theta)* temp)/ (Length * (Fourthirds - Mass_Pole * cos(theta) * cos(theta) / Total_Mass)); % çubuk ivmesi

xacc  = temp - PoleMass_Length * thetaacc* cos(theta) / Total_Mass;  % arabanýn ivmesi
 
% Sistemin 4 temel parametresinin Euler metodu ile güncellenmesi
x=x+Tau*x_dot;                         % x(t+1) = x(t)+T*x_dot(t)
x_dot=x_dot+Tau*xacc;                  % x_dot(t) = x(t)+T*x_ivme(t)
theta=theta+Tau*theta_dot;             % theta(t+1) = theta(t)+T*theta_dot(t)
theta_dot=theta_dot+Tau*thetaacc;      % theta_dot(t+1) = theta_dot(t)+T*theta_ivme(t)