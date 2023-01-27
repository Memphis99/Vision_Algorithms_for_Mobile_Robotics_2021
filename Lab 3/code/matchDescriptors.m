function matches = matchDescriptors(query_descriptors, database_descriptors, lambda)
% Returns a 1xQ matrix where the i-th coefficient is the index of the
% database descriptor which matches to the i-th query descriptor.
% The descriptor vectors are MxQ and MxD where M is the descriptor
% dimension and Q and D the amount of query and database descriptors
% respectively. matches(i) will be zero if there is no database descriptor
% with an SSD < lambda * min(SSD). No two non-zero elements of matches will
% be equal.
    
    %find the most similar descriptors (least difference) between q and d
    [D, matches]=pdist2(database_descriptors.', query_descriptors.', 'squaredeuclidean', 'Smallest', 1);
    
    %find the minimum SSD from all matches
    dmin=min(D)
    
    %set all matches under the trashold at 0
    for i=1:length(D)
        if D(i)>lambda*dmin
            matches(i)=0;
        end
    end
    
    %find the position of the first occurrencies of matches
    [C, im, ic]=unique(matches);
    
    a=1:length(matches);
    
    %set every match that is not the first occurrency at 0
    for i=setdiff(a, im)
        matches(i)=0;
        
    end
    
end
        
        
   
    
    
