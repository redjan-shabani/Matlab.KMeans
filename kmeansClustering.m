%Author: REDJAN F. SHABANI
%Universita' degli studi di Roma "LA SAPIENZA"
%Ingegneria Informatica - Intelligenza Artificiale
%Version: Gen. 2010

%-->input DS, n-by-N matrix where the coloums represents the points in the
%n-dimensional space
%-->input K, K-Means parameter, number ofdesired clusters
function [IDC,SUB]=kmeansClustering(DS,K)
	
	% 1-NORMALIZING DATASET
	[DS,t]=dataNorm(DS);
	
	% 2-INITIALIZING MEANS
	MNS=meansInit(DS,K);
	
	% 3-CLASSIFATION FROM MEANS
	IDC=classificationFromMeans(DS,MNS);
	
	% 4-MEANS AND CLASSES RECTIFICATION
	iteration=1;
	max_iterations=10000;%maximum number of iterations
	IDC_=IDC;
	SUB=[];
	while(true)
		
		% 4.1-MEANS FROM CLASSIFICATION
		MNS=meansFromClassification(DS,IDC);
		
		% 4.2-CLASSIFATION FROM MEANS
		IDC=classificationFromMeans(DS,MNS);
		
		% 4.3-COUNTING SUBSTITUTIONS
		SUBS=abs(sum(sum(IDC_-IDC)));
		if(SUBS==0)%terminating loop if no sustitution done
			break;
		end
		SUB=[SUB SUBS];
		IDC_=IDC;
		
		if(iteration>max_iterations)
			break;
		end
		iteration=iteration+1;		
	end

end


function [DSN,m]=dataNorm(DS)
	%-->input DS, dataset to be normalized
	%-->output DSN, dataset with normalized data
	%-->output t,traslation vector	
	
	m=sum(DS,2)/size(DS,2);
	DSN=DS-m*ones(1,size(DS,2));
end

function MNS=meansInit(DS,K)
	%-->input DS, dataset
	%-->input K, number of means
	%-->output MNS, matrix n-by-K conteining means as coloumn vectors
	[n,~]=size(DS);
	R=max(max(DS));
	MNS=random('unif',-R,+R,n,K);
	for k=1:K
		MNS(:,k)=DS(:,nearest(MNS(:,k),DS));		
	end
end

function IDC=classificationFromMeans(DS,MNS)
	[~,N]=size(DS);
	
	%initializing the labels clas vector
	IDC=zeros(1,N);
	for n=1:N
		x_n=DS(:,n);
		IDC(1,n)=nearest(x_n,MNS);		
	end	
end

function indx=nearest(x,M)
	[~,cM]=size(M);
	%differesnce
	diff=M-x*ones(1,cM);
	%squared differences
	diff2=diff.^2;
	%sum of squared differences
	sdiff2=sum(diff2);
	%index of the minimum ssd
	indx=find(sdiff2==min(sdiff2));
	indx=indx(1);	
end

function MNS=meansFromClassification(DS,IDC)
	K=max(IDC);
	[n,~]=size(DS);
	MNS=zeros(n,K);
	for k=1:K
		MNS(:,k)=mean(DS(:,IDC==k),2);
	end
end