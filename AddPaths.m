function AddPaths(dirOrg)
   
    global dirData    
    global dirDataOrg    
    
    global recomputeAll
    global loadAll         
    
    if(strcmp(GetMacAddress(),'18-66-DA-34-E5-42')) %PC MPI
        dirData = 'D:/ND_Exploration/';
    else
        dirData = '/Users/andreas/Documents/ND_Exploration/';
    end
 
    addpath(genpath(pwd));        
    rmpath(genpath([pwd filesep 'NoClass']));       
    
    dirDataOrg = dirData;
    if(nargin >= 1)
        ChangeDirData([dirDataOrg filesep dirOrg],'ORG');
    end
    
    if(isempty(recomputeAll))
       recomputeAll = false;
    end
    
    loadAll = true;   
    
    if(recomputeAll)
        disp('!!! No precomputed data will be used. recomputeAll = true !!!\n');
    elseif(loadAll)
        disp('Data will be used loaded if available. loadAll = true \n');
    end
    
    function mac_add = GetMacAddress()
        switch computer('arch')
             case {'maci','maci64'}
                 [~,a]=system('ifconfig');
                 c=strfind(a,'en0');if ~isempty(c),a=a(c:end);end
                 c=strfind(a,'en1');if ~isempty(c),a=a(1:c-1);end
                 % find the mac address
                 b=strfind(a,'ether');
                 mac_add=a(1,b(1)+6:b(1)+22);
             case {'win32','win64'}
                 [~,a]=system('getmac');
                 b=strfind(a,'=');
                 %mac_add=a(b(end):b(end)+19);
                 mac_add=a(b(end)+2:b(end)+18);
             case {'glnx86','glnxa64'}
                 [~,a]=system('ifconfig');b=strfind(a,'Ether');
                 mac_add=a(1,b(1)+17:b(1)+33);
             otherwise,mac_add=[];
        end

        mac_add = strtrim(mac_add);
    end
end