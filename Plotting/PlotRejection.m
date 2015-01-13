function PlotRejection(patientnr, nightnr)

    ha = tight_subplot(3,1);
    
    axes(ha(1));
    PlotChannelStdDevs(patientnr, nightnr);
    axes(ha(2));
    PlotRejectionBadChans(patientnr, nightnr);
    axes(ha(3));
    PlotRejectionWpli(patientnr, nightnr);

end