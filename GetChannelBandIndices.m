function [chanIndicesAlpha, chanIndicesTheta, chanIndicesDelta] = GetChannelBandIndices(elec)

    % elec is a cell of strings containing all channel labels
    % returns the indices suited for elec

    % define channel indices for each band
    chanLabelsDelta = {'E23', 'E18', 'E16', 'E10', 'E3', 'E26', 'E22', 'E15', 'E9', 'E2'};
    chanLabelsTheta = { 'Cz', 'E7', 'E106', 'E80', 'E55', 'E31', 'E6', 'E112', 'E105', 'E87', 'E79', 'E54', 'E37', 'E30', 'E13'};
    chanLabelsAlpha = {'E58', 'E65', 'E70', 'E75', 'E83', 'E90', 'E96', ...
                            'E97', 'E91', 'E84', 'E76', 'E71', 'E66', 'E59', 'E51', ...
                            'E60', 'E67', 'E72', 'E77', 'E85'};
    
     
    chanIndicesDelta = find(ismember(elec,chanLabelsDelta));
    chanIndicesTheta = find(ismember(elec,chanLabelsTheta));                
    chanIndicesAlpha = find(ismember(elec,chanLabelsAlpha));               

end

