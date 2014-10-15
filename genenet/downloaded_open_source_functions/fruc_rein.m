%Author: Unkown ( and minor change by Avigail Taylor )
%Version: --
%Date: --
%Description: Finds optimal node placement for visualising a network. Documentation available at: http://netwiki.amath.unc.edu/VisComms/VisComms
%Implementation: DOWNLOADED FROM http://netwiki.amath.unc.edu/VisComms/VisComms. Minor change by Avigail Taylor: 'seed' parameter removed. 
%Keywords: optimal node placement network visualisation 
%Example: This is an auxiliary function. IT HAS BEEN DOWNLOADED FROM http://netwiki.amath.unc.edu/VisComms/VisComms. Not intended for direct calling by the user.

function [xy] = fruc_rein(A,eps) % PARAMETER 'seed' removed A. Taylor
% This function uses the Fruchterman-Reingold Algorithm to find the optimal
% node placement for a given network.
%
%Inputs:
%
% A is the adjacency matrix for the network
%
% eps is the accuracy at which the algorith will act, .01 works well in
% most cases.
%
%seed is the seed for the random number generator for intial placement of
%the nodes.
%
%Outputs:
%
%xy is the matrix of xy coordinates for each node in your network, 
%the first column is the x coordinates and the second column is the y 
%coordinates.
%
%Calling this Function:
%
%[xy] = fruc_rein(A,eps, seed)
%
% Last modified by ALT May 14, 2009

% Distances are written as one over the weight for a weighted matrix (the
% more weight representing a link, the closer in distance they should be)

%rand('twister',seed); -- Removed by A. Taylor

A(find(A)) = 1./A(find(A));
n = length(A);
W = 3;
t=1;
L = 3;
% Initialize the point's
xy=rand(n,2)-1.5;
k = .75*sqrt((W*L)/n);
displacement = zeros(n,2);
displacement(1,1)=1;
z = 0;

max_out_counter = 0; %ADDED BY AVI IN CASE TOO HARD TO PLOT.
while ((max(max(abs(displacement))))>=eps & max_out_counter<500 )

    max_out_counter = max_out_counter + 1; %ADDED BY AVI IN CASE TOO HARD TO PLOT.
    
    [row,col] = find(A);
    z=z+1;
    
    m(z)=max(max(abs(displacement)));
    l2=length(m);
   
    if l2>=6
       	v=diff(m);
       
    	if abs(v(end))<=.00000001
        	break
    	end 
    end

    displacement = zeros(n,2);
    
    for l = 1:length(row)
        d = xy(row(l),:)-xy(col(l),:);
        displacement(row(l),:) = displacement(row(l),:)-A(row(l),col(l))*(((d/norm(d))*fa(norm(d),k))*.5);
        displacement(col(l),:) = displacement(col(l),:)+A(col(l),row(l))*(((d/norm(d))*fa(norm(d),k))*.5);
    end
    for i = 1:n
        idx=1:n;
        idx=find(idx~=i);
        xyi=repmat(xy(i,:),n-1,1);
        d=xyi-xy(idx,:);
        normd=((d(:,1).^2)+(d(:,2).^2)).^.5;
        displacement(i,:)=displacement(i,:)+sum([(d(:,1)./normd).*fr(normd,k) (d(:,2)./normd).*fr(normd,k)]);
        xy(i,:) = xy(i,:) + (displacement(i,:)/norm(displacement(i,:)))*min(norm(displacement(i,:)),t);
    end
    t=.99*t;

end

end

%--------------------------------------------------------------------------
function [f_a] = fa(distance,k)


f_a = ((distance^2)./k);
%f_a = ((distance)./k);

end

%--------------------------------------------------------------------------
function [f_r] = fr(distance,k)


f_r = ((k^2)./distance);
%f_r = ((k)./distance);

end
