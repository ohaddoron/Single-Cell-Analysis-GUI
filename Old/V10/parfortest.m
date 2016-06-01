t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',... 
                 'StartDelay',60);
parfor i = 1 : 2
    if i == 1
        start(t);
        stat = true;
        while stat == true
            disp('.');
            pause(1);
        end
        if stat == false
            error('end');
        end

    else
        h = bar_graph(folderPath,parBarGraph,Arrange,concat);
    end
end