## Usage: grab(file, cycleT=100, N=6)
##    Calculate Cycle Averaged values from csv result file
##    Note: File extension .csv assumed
##          
## Author: Ravi Sankar Saripalli
## Assuming the bed goes through cycles as follows
##  Feed, Blow, Purge, Pressurize
##   0.2  0.3   0.2    0.3
function  grab(file, cycleT=100, N=6)

strP = sprintf("bedA.adsbr.p[%d]",N) ;
strY = sprintf("bedA.adsbr.y[%d_1]",N) ;
varnames={ "bedA.vin.inlet.m_flow", "bedA.vout.inlet.m_flow", ...
           "bedA.vblow.inlet.m_flow", "vpurge.inlet.m_flow", ...
           strP, strY, ...
           "src.port.m_flow", "sink.port.m_flow",...
           "atm.port.m_flow"};
names={"Mvin" "Mvout" "Mblow" "Mpur" "Pbar" "O2" "Msrc" "Msnk" "Matm" "Recov" "MBErr" };
tx=getvarcsv("time",file); 

for i=1:9
data(:,i)=getvarcsv(varnames{i},file);
end
data = [tx data];  
data = dropdup(data); %save mydata data ; 
header=sprintf("%13s",names{:});

tx= data(:,1); 
delt = mean(tx(2:end)-tx(1:end-1));

[result, ss] = cages(data(:,2:end), delt, cycleT);

disp(header); disp(result);

Result.file=file;
Result.time = data(end,1);
Result.delt = delt ;
Result.O2 = result(end,6);
Result.O2Recovery = result(end,end-1);
Result.Min = result(end,1); Result.Mout = result(end,2);
Result.Mblow = result(end,3); Result.Mpurge = result(end,4);
Result.Qin = Result.Min / rhomix(0.21) ;
Result.Qout = Result.Mout / rhomix(Result.O2/100) ;
Result.ProdMeanO2 = ss.MeanO2(end) ;
Result.ProdMeanOutflow = ss.MeanOutflow(end);
Result.MeanPurgeP = ss.MeanPurgeP(end);
disp(Result);

end


function ans = dropdup(data)
k = 0 ;
for i = 2:size(data,1)
  if (data(i,1) == data(i-1,1)) 
    k = k + 1;
    mark(k) = i-1 ;
   end
end
data(mark,:)=[] ;
ans = data ;
end

function [result, s] = cages(data,  delt, cycleT)
%Grab the temporal data and spew out avged vales over each cycle
% as time progresses

NS = floor(cycleT/delt); 
NP = size(data,1) ;

for k = 0 : (NP/NS)-1 ;
window = [k*NS + 1 : (k+1)*NS ] ;
cages(k+1,:) = sum(abs(data(window, 1:9)))*delt/cycleT ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feedF = 0.2 ;
for k = 0 : (NP/NS)-1 ;
  window = [k*NS + 1 : k*NS + NS*feedF ] ;
  OutflowO2 = 0 ; Outflow = 0 ; 
  for m = window(1:end)
    yO2 = 1 - data(m,6) ;
    mw = yO2 * 32 + (1-yO2) * 28 ;
    molflow = data(m,2) / mw ;
    Outflow = Outflow + molflow ;
    OutflowO2 = OutflowO2 + molflow * yO2;  
  end
  s.MeanO2(k+1) = 100 * OutflowO2 / Outflow ;
  MeanMw = (s.MeanO2(k+1) * 32 + (100-s.MeanO2(k+1)) * 28)/100 ;
  s.MeanOutflow(k+1) = 0.2 * MeanMw * Outflow / size(window,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get Mean Purge Pressure in the Cycle
purgeF = 0.2 ; blowF = 0.3 ; feedF = 0.2 ;
for k = 0 : (NP/NS)-1 ;
  offset = NS * (feedF + blowF) ;
  window = [k*NS + offset + 1 : k*NS + offset + NS*purgeF ] ;
  sumP = 0 ;
  for m = window(1:end)
     sumP = sumP + data(m,5) ;
  end
  s.MeanPurgeP(k+1) = sumP / size(window,2);
end

%Change from N2 fraction to O2%
cages(:,end-3) = (1 .- cages(:,end-3))*100 ;

%Get O2 Recovery
po2 = cages(:,end-3) ;
prodO2 = cages(:,2) .* ((po2 * 32) ./ (po2*32+(100-po2)*28)) ;
po2 = 21.0 ;
feedO2 =   cages(:,1) * (po2 * 32.0 / (po2*32+(100-po2)*28)) ;
cages(:,end+1) = 100 * prodO2 ./ (prodO2 .+ feedO2);

%Get Mass Balance Error
out = cages(:,2) + cages(:,3) ;
in = cages(:,1);
cages(:,end+1) = 100 * (in - out) ./ in ;
%result = cages(end,:);

result = cages;
end
