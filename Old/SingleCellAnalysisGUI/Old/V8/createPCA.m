function [coeffs,scores,pcvars] = createPCA (summaryTablePath)

    [data,txt] = xlsread(summaryTablePath);
    Labels = txt(1,2:end);
    data = normr(data);
    [coeffs,scores,pcvars] = princomp(data');
    pcvars = pcvars/sum(pcvars) * 100;
    x = scores(:,1);
    y = scores(:,2);
    z = scores(:,3);
    dx = 0.0001;
    dy = 0.0001;
    dz = 0.0001;
    figure;
    scatter3(x,y,z,30,jet(length(x)),'filled');
    text(x+dx,y+dy,z+dz,Labels);
    xlabel(['PC-1 ' num2str(pcvars(1)) '%']);
    ylabel(['PC-2 ' num2str(pcvars(2)) '%']);
    zlabel(['PC-3 ' num2str(pcvars(3)) '%']);
end