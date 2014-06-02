function eeglabSet = NukeEventStructure(eeglabSet)
% return an events array with a single mock event

    eeglabSet.event = [];
    eeglabSet.urevent = [];

    myevent.type = 'mock';
    myevent.latency = 1;
    myevent.value = '';
    myevent.duration = 0;
    myevent.codes = [];
    myevent.init_index = 1;
    myevent.init_time = 1;
    
    eeglabSet.urevent = myevent;
    
    myevent.urevent = 1;
    
    eeglabSet.event = myevent;

end

