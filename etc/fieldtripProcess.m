ft_defaults;
javaaddpath /Users/iulia/Documents/MATLAB/fieldtrip/external/egi_mff/java/MFF-1.0.jar

folder = '/Users/iulia/Documents/MATLAB/Data/';

data = [  
{'p10_overnight1 20120910 1813'};
{'p10_overnight1 20120910 1813'};
{'p10_overnight2 20120912 1812'};
{'p1_overnight1 20120502 1710'};
{'p1_overnight1 20120502 1710'};
{'p2_overnight1 20120525 1549'};
{'p2_overnight2 20120529 1754'};
{'p2_overnight2 20120529 1754'};
{'p2_overnight3 20120613 1752'};
{'p5_overnight1 20120705 1814'};
{'p5_overnight2 20120711 1703'};
{'p5_overnight2 20120711 1703'};
    ];

filename = [folder data{3}];
header = ft_read_header(filename);
events = ft_read_event(filename, 'eventformat', 'egi_mff_v2');
data = ft_read_data(filename, 'dataformat', 'egi_mff_v2', 'headerformat', 'egi_mff_v1');

