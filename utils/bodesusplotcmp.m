function bodesusplotcmp(sys1,sys2,inv,outv,freq,varargin)

nin1=strcmp(sys1.InputName,inv);
nout1=strcmp(sys1.OutputName,outv);
[mag1,phs1] = mybode(sys1(nout1,nin1),freq);

nin2=strcmp(sys2.InputName,inv);
nout2=strcmp(sys2.OutputName,outv);
[mag2,phs2] = mybode(sys2(nout2,nin2),freq);

unit=makeunit(inv,outv);
leg={'data1','data2'};

if ~isempty(varargin)
if iscellstr(varargin{1})
    if length(varargin{1})>1
        leg=varargin{1};
    end
end
end

figure
  subplot(5,1,[1 2 3])
  loglog(freq,mag1,'b-',freq,mag2,'r-','LineWidth',2)
  grid on
  title(['Transfer Function Bode Plot',' from ',inv,' to ',outv],...
      'FontSize',12,'FontWeight','bold','FontName','Cambria')
  ylabel(['Magnitude ',unit],'FontSize',12,'FontWeight','bold','FontName','Cambria')
  legend(leg{1},leg{2});
  set(gca,'FontSize',12,'FontName','Cambria')
  
  subplot(5,1,[4 5])
  semilogx(freq,phs1,'b-',freq,phs2,'r-','LineWidth',2)
  grid on
  ylim([-180 180])
  %xlim([10^(fmin) 10^(fmax)])
  ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Cambria')
  xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold','FontName','Cambria')
  set(gca,'FontSize',12,'FontName','Cambria')
  set(gca,'YTick',-180:90:180)
  
end