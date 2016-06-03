function [hAx, pos] = plot_mn(nY,nX,k,globPos,razX,razY); 
%     function hAx = plot_mn(nY,nX,k,globPos,razX,razY); 
% NPR plot_mn(4,3,k,[0.05 0.1 0.9 0.85],0.01,0.06)
% Polozaj k-te slike u rasteru nY x nX. Aktivira se subplot.
% nY x nX - broj slika po vertikali i horizontali,
% k - redni broj slike (kao kod subplot naredbe)
% globPos - vektor kao standardni 'position', obuhvaca svih nY x nX grafova
% razX - razmak izmedju slika u x-smjeru,
% razY - razmak izmedju slika u y_smjeru.
% Sve jedinice su relativne (imedju 0 i 1).
% z.p. 2-Oct-2006.


if(nargin>3) % Radi kompatibilnosti
    dno = globPos(2); vrh = globPos(2)+globPos(4);
    lijevo = globPos(1); desno = globPos(1)+globPos(3);
    
    % $$$ % --- parametri multi-plota
    % $$$ dno = 0.1; vrh = 0.95; 
    % $$$ lijevo = 0.05; desno = 0.95;
    % $$$ % $$$ razY = 0.01; razX = 0.01;
    % $$$ % promjenjeno zbog ubacivanja colorbar-a medju slike.
    % $$$ % U ovom slucaju se nista ne gubi xbog nametanja
    % $$$ % 'PlotBoxAspectRatio' za ASHELF-2 podrucje. z.p. 1-Feb-2005.
    % $$$ razY = 0.06; razX = 0.01;
else 
    dno = 0.1; vrh = 0.95; 
    lijevo = 0.05; desno = 0.95;
    razY = 0.06; razX = 0.01;
end   
lY = ((vrh-dno)-(nY-1)*razY)/nY;
lX = ((desno-lijevo)-(nX-1)*razX)/nX;


    % Polozaj slike
j1 = floor((k-1)/nX)+1;
i1 = k-(j1-1)*nX;
i2 = i1; j2 = nY-j1+1;
pX = lijevo+(i2-1)*(razX+lX);
pY = dno+(j2-1)*(razY+lY);


pos = [pX pY lX lY];
if(nargout==2)
    hAx = [];
else
    hAx = subplot('Position',pos);
end


% [pX pY lX lY]
return
