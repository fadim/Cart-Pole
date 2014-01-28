N_BOXES = 162;        % Number of boxes
ALPHA	= 1000;       % Learning rate for action weights, w.
BETA    = 0.5;        % Learning rate for critic weights, v. 
GAMMA   = 0.95;       % Discount factor for critic. 
LAMBDAw	= 0.9;        % Decay rate for w eligibility trace. 
LAMBDAv	= 0.8;        % Decay rate for v eligibility trace

MAX_FAILURES  =  100;      % Termination criteria. 
MAX_STEPS   =     50000;

steps = 0;
failures=0;

% Initialize action and weights and traces
w =zeros(N_BOXES,1); %Action vector
v = zeros(N_BOXES,1); %Failure vector
xbar= zeros(N_BOXES,1);
e= zeros(N_BOXES,1);


% Starting state is (0 0 0 0)
x         = 0;       % cart position
x_dot     = 0;       % cart velocity
theta     = 0;       % pole angle
theta_dot = 0.0;     % pole angular velocity

% Baþlangýç pozisyonlarýný içeren kutuyu buluyor
box = get_box(x, x_dot, theta, theta_dot);


 % Plot the cart and pole
 h = figure(1);
 set(h,'doublebuffer','on')
 
% Sistem en iyi davranýþý öðrenene kadar  
while (steps < MAX_STEPS & failures < MAX_FAILURES)

    % Plot the cart and pole 
    plot_Cart_Pole(x,theta)
    
    %Rastgele bir action seçiliyor
    if Random_Pole_Cart<prob_push_right(w(box))
        y =1;
    else
        y=0;
    end
    
    %Update traces.
    e(box)= e(box) + (1.0 - LAMBDAw) * (y - 0.5);
    xbar(box) =xbar(box)+ (1.0 - LAMBDAv);
    
    %Remember prediction of failure for current state
    oldp = v(box);
    
    %Rastgele seçilen actioný sisteme uyguluyoruz
    [x,x_dot,theta,theta_dot]=Cart_Pole(y,x,x_dot,theta,theta_dot);
    
    %Yeni state'in hangi kutuya tekabül ettiðini buluyoruz.
    box = get_box(x, x_dot, theta, theta_dot);
    
    if (box < 0)	
        %Failure state'in meydana gelme durumu
        failed = 1;
	    failures=failures+1;
        disp(['Trial was ' int2str(failures) ' steps '  num2str(steps)]);
        
        steps = 0;
        
        %Tüm state'leri tekrar sýfýrlýyoruz. Baþlangýç state'ine dönüyoruz
	    x =0;
        x_dot = 0;
        theta =0;
        theta_dot = 0.0;
	    box = get_box(x, x_dot, theta, theta_dot);
        
        r = -1.0;  %Reinforcement of failure 
	    p = 0.;    %Prediction of failure
    else
        
        failed = 0;
        
        
        r = 0;  %Reinforcement is 0. 
        steps=steps+1;
	    p= v(box);  % Verilen kutu numarasýnýn failure olma durumu tahmin ediliyor bir önceki öðrenme durumuna göre
    end
    
    %Reinforcement is:   current reinforcement
	%     + gamma * new failure prediction - previous failure prediction
    
    rhat = r + GAMMA * p - oldp;
    
    
    for i=1:N_BOXES,
        
         w(i) = w(i)+ ALPHA * rhat * e(i);
	     v(i) = v(i)+ BETA * rhat * xbar(i);
         
         if (v(i) < -1.0)
	        v(i) = v(i);
         end
         
         if (failed)
             %Failure olma durumunda tüm traceleri sýfýrlýyoruz
              e(i) = 0.;
	          xbar(i) = 0.;
              
          else
              e(i)=e(i) * LAMBDAw;
              xbar(i) =xbar(i)* LAMBDAv;
          end
          
      end
      %Plot the cart and pole using the new x and theta after applying the action
      plot_Cart_Pole(x,theta)
  end
  
if (failures == MAX_FAILURES)
    disp(['Pole not balanced. Stopping after ' int2str(failures) ' failures ' ]);
else
    disp(['Pole balanced successfully for at least ' int2str(steps) ' steps ' ]);
end