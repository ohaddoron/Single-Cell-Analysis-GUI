function MakeStructMultiple(folderPath,outputLocation,dt)
%%  
    dt = dt/60;
    files = dir([folderPath '\*.xls']);
    numOfXLS = length(files);
    %mkdir([folderPath '\mat files']);
    disp(['Opening folder ' folderPath]);
    
    for i = 1 : numOfXLS
        disp(['Opening file ' files(i).name]);
        filePath = [folderPath '\' files(i).name];
        At = MakeStructSingle(filePath,dt);
        save([outputLocation '\' strrep(files(i).name,'.xls','')],'At');
        %system('taskkill /F /IM EXCEL.EXE');
    end
end
function At = MakeStructSingle(File,dt)
%%
    Excel = actxserver('Excel.Application');
    workBook = Excel.Workbooks.Open(File);
    workSheets  =  Excel.Sheets;
    for i = 1:workSheets.Count
        sheet = get(workSheets,'item',i);
        sheetName{i} = sheet.Name;
    end
    numOfSheets = length(sheetName);
    for i = 1 : numOfSheets
        
        sheetNametemp{i} = sheetName{i};
        sheetName{i} = strrep(strrep(strrep(sheetNametemp{i},' ',''),'=',''),'^','');
        sheetName{i} = strrep(sheetName{i},'Ellipticity(oblate)','Ellipticity_oblate');
        sheetName{i} = strrep(sheetName{i},'Ellipticity(prolate)','Ellipticity_prolate');
        sheetName{i} = strrep(sheetName{i},'-','_');
        sheetName{i} = char(sheetName{i});
        exl = Excel.Sheets.Item(sheetNametemp{i});
        robj = exl.Columns.End(4);
        numrows = robj.row; 
        dat_range = ['A1:J' num2str(numrows)]; 
        rngObj = exl.Range(dat_range);
        try
            exlData.(sheetName{i}) = rngObj.Value;
        catch
            continue;
        end
        
    end
    numOfSheets = length(sheetName);
    invoke(Excel,'Quit');
    for i = 1 : numOfSheets
        sheet = sheetNametemp{i};
        if strfind(sheet,'Recovered')
            continue
        end
        switch sheet
            %case 'Center of Homogeneous Mass'
            %    continue
            case 'Number of Disconnected Componen'
                continue
            case 'Number of Triangles'
                continue
            case 'Number of Vertices'
                continue
            case 'Number of Voxels'
                continue
            case 'Overall'
                continue
            case 'Center of Image Mass Ch=1'
                continue
            case 'Center of Image Mass Ch=2'
                continue
            case 'Center of Image Mass Ch=3'
                continue
                %{
            case 'Intensity Median Ch=1'
                continue
            case 'Intensity Median Ch=2'
                continue
            case 'Intensity Median Ch=3'
                continue
                %}
            case 'Intensity Min Ch=1'
                continue
            case 'Intensity Min Ch=2'
                continue
            case 'Intensity Min Ch=3'
                continue
            case 'Intensity StdDev Ch=1'
                continue
            case 'Intensity StdDev Ch=2'
                continue
            case 'Intensity StdDev Ch=3'
                continue
            %case 'Intensity Sum Ch=1'
            %    continue
            case 'Speed'
                continue
            case 'Acceleration'
                continue
            case 'Track Ar1'
                continue
            case 'Track Ar1 Mean'
                continue
            case 'Track Area Mean'
                continue
            case 'Track Center of Homogeneous Mas'
                continue
            case 'Track Center of Image Mass Mean'   
                continue
            case 'Track Ellipsoid Axis A Mean';
                continue
            case 'Track Ellipsoid Axis B Mean'
                continue
            case 'Track Ellipsoid Axis C Mean'
                continue
            case 'Track Ellipsoid Axis Length A M'
                continue
            case 'Track Ellipsoid Axis Length B M'
                continue
            case 'Track Ellipsoid Axis Length C M'
                continue
            case 'Track Intensity Center Mean Ch='
                continue
            case 'Track Intensity Max Ch=1'
                continue
            case 'Track Intensity Max Ch=2'
                continue
            case 'Track Intensity Mean Ch=1'
                continue
            case 'Track Intensity Mean Ch=2'
                continue
            case 'Track Intensity Mean Ch=3'
                continue
            case 'Track Intensity Median Ch=1'
                continue
            case 'Track Intensity Median Ch=2'
                continue
            case 'Track Intensity Median Ch=3'
                continue
            case 'Track Intensity Min Ch=1'
                continue
            %{
            case 'Track Intensity Sum Ch=1'
                continue
            case 'Track Intensity Sum Ch=2'
                continue
            case 'Track Intensity Sum Ch=3'
                continue
            %}
            case 'Track Number of Branches'
                continue
            case 'Track Number of Fusions'
                continue
            case 'Track Number of Surfaces'
                continue
            case 'Track Number of Triangles'
                continue
            case 'Track Number of Voxels'
                continue
            case 'Track Position'
                continue
            case 'Track Speed Mean'
                continue
            case 'Track Speed Min'
                continue
            case 'Track Speed StdDev'
                continue
            case 'Track Speed Variation'
                continue
            case 'Track Sphericity Mean'
                continue
            case 'Track Straightness'
                continue
            case 'Track Volume Mean'
                continue
            case 'Velocity'
                continue
            case 'Track Duration'
                continue
            case 'Track Intensity StdDev Ch=1'
                continue
            case 'Track Intensity StdDev Ch=2'
                continue
            case 'Track Intensity StdDev Ch=3'
                continue
            case 'Track Length'
                continue
            case 'Track Speed Max'
                continue
            case 'Track Displacement Length'
                continue
            case 'Time'
                continue
        end
        try
            data = exlData.(sheetName{i});
        catch
            continue
        end
        
        [Row,Col] = size(data);
        text = data(1,1:Col);
        parentVal = data(2:Row,strcmp(text,'Parent'));
        data(find(cellfun(@isempty,parentVal)),:) = [];
        [Row,~] = size(data);
        timeVal = data(2:Row,strcmp(text,'Time'));
        timeVal(strcmp(timeVal,'')) = [];
        timeVal = cell2mat(timeVal);
        parentVal = data(2:Row,strcmp(text,'Parent'));
        
        if isempty(parentVal)
            parentVal = data(2:Row,strcmp(text,'TrackID'));
        end
        parentVal(strcmp(parentVal,'')) = [];
        parentVal = cell2mat(parentVal) - 1000000000 + 1;
        
        switch sheet
            case 'Track Displacement'
                Track_Displacement_X = data(2:Row,strcmp(text,'Track Displacement X'));
                Track_Displacement_Y = data(2:Row,strcmp(text,'Track Displacement Y'));
                Track_Displacement_Z = data(2:Row,strcmp(text,'Track Displacement Z'));
                Track_Displacement_X(strcmp(Track_Displacement_X,'')) = [];
                Track_Displacement_Y(strcmp(Track_Displacement_Y,'')) = [];
                Track_Displacement_Z(strcmp(Track_Displacement_Z,'')) = [];
                Track_Displacement_X = cell2mat(Track_Displacement_X);
                Track_Displacement_Y = cell2mat(Track_Displacement_Y);
                Track_Displacement_Z = cell2mat(Track_Displacement_Z);
                At.Track_Displacement_X = Track_Displacement_X';
                At.Track_Displacement_Y = Track_Displacement_Y';
                At.Track_Displacement_Z = Track_Displacement_Z';
                At.Track_Displacement_Length = sqrt(At.Track_Displacement_X.^2 + At.Track_Displacement_Y.^2 + At.Track_Displacement_Z.^2);
            case 'Position'
                At.x_Pos = nan(nanmax(timeVal),nanmax(parentVal));
                At.y_Pos = nan(nanmax(timeVal),nanmax(parentVal));
                At.z_Pos = nan(nanmax(timeVal),nanmax(parentVal));                
            case 'Ellipsoid Axis A'
                At.Ellip_Ax_A_X = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_A_Y = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_A_Z = nan(nanmax(timeVal),nanmax(parentVal));
            case 'Ellipsoid Axis B'
                At.Ellip_Ax_B_X = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_B_Y = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_B_Z = nan(nanmax(timeVal),nanmax(parentVal));
            case 'Ellipsoid Axis C'
                At.Ellip_Ax_C_X = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_C_Y = nan(nanmax(timeVal),nanmax(parentVal));
                At.Ellip_Ax_C_Z = nan(nanmax(timeVal),nanmax(parentVal));
            case 'Center of Homogeneous Mass' 
                At.Center_of_Homogeneous_Mass_X = nan(nanmax(timeVal),nanmax(parentVal));
                At.Center_of_Homogeneous_Mass_Y = nan(nanmax(timeVal),nanmax(parentVal));
                At.Center_of_Homogeneous_Mass_Z = nan(nanmax(timeVal),nanmax(parentVal));
            otherwise
                At.(sheetName{i}) = nan(nanmax(timeVal),nanmax(parentVal));
        end
        for j = 1 : nanmax(timeVal)
            curParentVal = parentVal(timeVal == j);
            switch sheet
                case 'Position'
                    xPos = data(2:Row,strcmp(text,'Position X'));
                    xPos(strcmp(xPos,'')) = [];
                    xPos = cell2mat(xPos);
                    yPos = data(2:Row,strcmp(text,'Position Y'));
                    yPos(strcmp(yPos,'')) = [];
                    yPos = cell2mat(yPos);
                    zPos = data(2:Row,strcmp(text,'Position Z'));
                    zPos(strcmp(zPos,'')) = [];
                    zPos = cell2mat(zPos);
                    At.x_Pos(j,curParentVal) = xPos(timeVal == j);
                    At.y_Pos(j,curParentVal) = yPos(timeVal == j);
                    At.z_Pos(j,curParentVal) = zPos(timeVal == j);
                case 'Ellipsoid Axis A'
                    EllipAxA_X = data(2:Row,strcmp(text,'Ellipsoid Axis A X'));
                    EllipAxA_X(strcmp(EllipAxA_X,'')) = [];
                    EllipAxA_X = cell2mat(EllipAxA_X);
                    EllipAxA_Y = data(2:Row,strcmp(text,'Ellipsoid Axis A Y'));
                    EllipAxA_Y(strcmp(EllipAxA_Y,'')) = [];
                    EllipAxA_Y = cell2mat(EllipAxA_Y);
                    EllipAxA_Z = data(2:Row,strcmp(text,'Ellipsoid Axis A Z'));
                    EllipAxA_Z(strcmp(EllipAxA_Z,'')) = [];
                    EllipAxA_Z = cell2mat(EllipAxA_Z);
                    At.Ellip_Ax_A_X(j,curParentVal) = EllipAxA_X(timeVal == j);
                    At.Ellip_Ax_A_Y(j,curParentVal) = EllipAxA_Y(timeVal == j);
                    At.Ellip_Ax_A_Z(j,curParentVal) = EllipAxA_Z(timeVal == j);
                case 'Ellipsoid Axis B'
                    EllipAxB_X = data(2:Row,strcmp(text,'Ellipsoid Axis B X'));
                    EllipAxB_X(strcmp(EllipAxB_X,'')) = [];
                    EllipAxB_X = cell2mat(EllipAxB_X);
                    EllipAxB_Y = data(2:Row,strcmp(text,'Ellipsoid Axis B Y'));
                    EllipAxB_Y(strcmp(EllipAxB_Y,'')) = [];
                    EllipAxB_Y = cell2mat(EllipAxB_Y);
                    EllipAxB_Z = data(2:Row,strcmp(text,'Ellipsoid Axis B Z'));
                    EllipAxB_Z(strcmp(EllipAxB_Z,'')) = [];
                    EllipAxB_Z = cell2mat(EllipAxB_Z);
                    At.Ellip_Ax_B_X(j,curParentVal) = EllipAxB_X(timeVal == j);
                    At.Ellip_Ax_B_Y(j,curParentVal) = EllipAxB_Y(timeVal == j);
                    At.Ellip_Ax_B_Z(j,curParentVal) = EllipAxB_Z(timeVal == j);
                case 'Ellipsoid Axis C'
                    EllipAxC_X = data(2:Row,strcmp(text,'Ellipsoid Axis C X'));
                    EllipAxC_X(strcmp(EllipAxC_X,'')) = [];
                    EllipAxC_X = cell2mat(EllipAxC_X);
                    EllipAxC_Y = data(2:Row,strcmp(text,'Ellipsoid Axis C Y'));
                    EllipAxC_Y(strcmp(EllipAxC_Y,'')) = [];
                    EllipAxC_Y = cell2mat(EllipAxC_Y);
                    EllipAxC_Z = data(2:Row,strcmp(text,'Ellipsoid Axis C Z'));
                    EllipAxC_Z(strcmp(EllipAxC_Z,'')) = [];
                    EllipAxC_Z = cell2mat(EllipAxC_Z);
                    At.Ellip_Ax_C_X(j,curParentVal) = EllipAxC_X(timeVal == j);
                    At.Ellip_Ax_C_Y(j,curParentVal) = EllipAxC_Y(timeVal == j);
                    At.Ellip_Ax_C_Z(j,curParentVal) = EllipAxC_Z(timeVal == j);
                case 'Center of Homogeneous Mass'
                    Center_of_Homogeneous_Mass_X = data(2:Row,strcmp(text,'Center of Homogeneous Mass X'));
                    Center_of_Homogeneous_Mass_Y = data(2:Row,strcmp(text,'Center of Homogeneous Mass Y'));
                    Center_of_Homogeneous_Mass_Z = data(2:Row,strcmp(text,'Center of Homogeneous Mass Z'));
                    Center_of_Homogeneous_Mass_X(strcmp(Center_of_Homogeneous_Mass_X,'')) = [];
                    Center_of_Homogeneous_Mass_Y(strcmp(Center_of_Homogeneous_Mass_Y,'')) = [];
                    Center_of_Homogeneous_Mass_Z(strcmp(Center_of_Homogeneous_Mass_Z,'')) = [];
                    Center_of_Homogeneous_Mass_X = cell2mat(Center_of_Homogeneous_Mass_X);
                    Center_of_Homogeneous_Mass_Y = cell2mat(Center_of_Homogeneous_Mass_Y);
                    Center_of_Homogeneous_Mass_Z = cell2mat(Center_of_Homogeneous_Mass_Z);
                    At.Center_of_Homogeneous_Mass_X(j,curParentVal) = Center_of_Homogeneous_Mass_X(timeVal == j,1);
                    At.Center_of_Homogeneous_Mass_Y(j,curParentVal) = Center_of_Homogeneous_Mass_Y(timeVal == j,1);
                    At.Center_of_Homogeneous_Mass_Z(j,curParentVal) = Center_of_Homogeneous_Mass_Z(timeVal == j,1);
                otherwise
                    value = data(2:Row,strcmp(text,'Value'));
                    value(strcmp(value,'')) = [];
                    value = cell2mat(value);
                    try 
                        At.(sheetName{i})(j,curParentVal) = value(timeVal == j,strcmp(text(1,:),'Value'));
                    catch
                        continue;
                    end
            end
        end
    end
    %At = rmfield(At,'TrackDisplacementLength');
    clear exlData workBook workSheets rngObj robj Excel exl
    [Row,Col] = size(At.x_Pos);
    %% Eccentricity
    semi_minor_axis = (At.EllipsoidAxisLengthA + At.EllipsoidAxisLengthB) / 2;
    semi_major_axis = At.EllipsoidAxisLengthC;
    At.Eccentricity=(1-((semi_minor_axis./semi_major_axis).^2)).^0.5;
    %% Velocity calculation
    At.Velocity_X = (At.x_Pos(2:end,:) - At.x_Pos(1:end-1,:))/dt;
    At.Velocity_Y = (At.y_Pos(2:end,:) - At.y_Pos(1:end-1,:))/dt;
    At.Velocity_Z = (At.z_Pos(2:end,:) - At.z_Pos(1:end-1,:))/dt;
    At.Velocity_X = [nan(1,Col); At.Velocity_X];    
    At.Velocity_Y = [nan(1,Col); At.Velocity_Y];
    At.Velocity_Z = [nan(1,Col); At.Velocity_Z];
    At.Velocity = (At.Velocity_X.^2 + At.Velocity_Y.^2 + At.Velocity_Z.^2).^0.5;
    %% Acceleration calculation
    At.Acceleration_X = (At.Velocity_X(2:end,:) - At.Velocity_X(1:end-1,:))/dt;
    At.Acceleration_Y = (At.Velocity_Y(2:end,:) - At.Velocity_Y(1:end-1,:))/dt;
    At.Acceleration_Z = (At.Velocity_Z(2:end,:) - At.Velocity_Z(1:end-1,:))/dt;
    At.Acceleration_X = [nan(1,Col); At.Acceleration_X];    
    At.Acceleration_Y = [nan(1,Col); At.Acceleration_Y];
    At.Acceleration_Z = [nan(1,Col); At.Acceleration_Z];
    At.Acceleration = (At.Acceleration_X.^2 + At.Acceleration_Y.^2 + At.Acceleration_Z.^2).^0.5;
    %% Displacement 
    B = ~isnan(At.x_Pos);
    [~, firstIdxs] = max(~isnan(At.x_Pos));
    lastIdxs = arrayfun(@(x) find(B(:, x), 1, 'last'), 1:size(At.x_Pos, 2));
    x_PosFinal = diag(At.x_Pos(lastIdxs,1:size(At.x_Pos,2)));
    y_PosFinal = diag(At.y_Pos(lastIdxs,1:size(At.y_Pos,2)));
    z_PosFinal = diag(At.z_Pos(lastIdxs,1:size(At.z_Pos,2)));
    x_PosInitial = diag(At.x_Pos(firstIdxs,1:size(At.x_Pos,2)));
    y_PosInitial = diag(At.y_Pos(firstIdxs,1:size(At.y_Pos,2)));
    z_PosInitial = diag(At.z_Pos(firstIdxs,1:size(At.z_Pos,2)));
    Displacement_Final = x_PosFinal.^2 + y_PosFinal.^2 + z_PosFinal.^2;
    Displacement_Initial = x_PosInitial.^2 + y_PosInitial.^2 + z_PosInitial.^2;
    At.Displacement = (abs(Displacement_Final - Displacement_Initial))';
    %% Instantaneous Speed
    T = meshgrid((1:Row)*dt,1:Col);
    T = T';
    DT = T(3:end,:) - T(1:end-2,:);
    Dx = At.x_Pos(3:end,:) - At.x_Pos(1:end-2,:);
    Dy = At.y_Pos(3:end,:) - At.y_Pos(1:end-2,:);
    Dz = At.z_Pos(3:end,:) - At.z_Pos(1:end-2,:);
    At.Instantaneous_Speed = sqrt(Dx.^2 + Dy.^2 + Dz.^2)./DT;
    At.Instantaneous_Speed = [nan(2,Col); At.Instantaneous_Speed];
    %% MSD
    [N,nc]=size(At.x_Pos);
    MSD = NaN(N,nc);
    MSD(1,:) = zeros(1,nc);
    for n=1:(N-1)
        xTemp=NaN(N,nc);
        xTemp((1+n):N,:)=At.x_Pos(1:(N-n),:);
        xDelta = At.x_Pos - xTemp;
        xDeltaSquared = xDelta.^2;

        yTemp=NaN(N,nc);
        yTemp((1+n):N,:)=At.y_Pos(1:(N-n),:);
        yDelta = At.y_Pos - yTemp;
        yDeltaSquared = yDelta.^2;
        
        zTemp=NaN(N,nc);
        zTemp((1+n):N,:)=At.z_Pos(1:(N-n),:);
        zDelta = At.z_Pos - zTemp;
        zDeltaSquared = zDelta.^2;

        deltaSquared = xDeltaSquared + yDeltaSquared + zDeltaSquared;

        NaN_times=~isnan(deltaSquared);
        Values_Count = sum(NaN_times);

        MSD(n+1,:) = nansum(deltaSquared) ./ Values_Count;
    end
    At.MSD = MSD;
    %% Mean curvilinear speed
    At.Mean_Curvilinear_Speed = 1/(N-1) * nansum(At.Velocity(1:end-1,:));
    %% Mean Straight Line Speed
    Ttot = (N-1) * dt;
    At.Mean_Straight_Line_Speed = At.Displacement/Ttot;
    %% Linearity of forward progression 
    At.Linearity_of_Forward_Progression = At.Mean_Straight_Line_Speed ./At.Mean_Curvilinear_Speed;
    At.Linearity_of_Forward_Progression(~isfinite(At.Linearity_of_Forward_Progression)) = nan;
    %% Confinement ratio
    At.Confinement_Ratio = At.Displacement./At.Track_Displacement_Length;
    %% Instantaneous angle
    Dx = At.x_Pos(2:end,:) - At.x_Pos(1:end-1,:);
    Dy = At.y_Pos(2:end,:) - At.y_Pos(1:end-1,:);
    At.Instantaneous_Angle = atan(Dy./Dx);
    At.Instantaneous_Angle = [nan(1,Col); At.Instantaneous_Angle];
    %% Directional change
    At.Directional_Change = At.Instantaneous_Angle(2:end,:) - At.Instantaneous_Angle(1:end-1,:);
    At.Directional_Change = [nan(1,Col); At.Directional_Change];
    %% Maximum distance traveled 
    P = sqrt(At.x_Pos.^2 + At.y_Pos.^2 + At.z_Pos.^2);
    dP = abs(P(2:end,:) - P(1:end-1,:));
    At.Maximum_Distance_Traveled = nanmax(nanmax(dP));
    %% Total trajectory time
    At.Total_Trajectory_Time = Ttot;
    %% Coll %Changed for 3D (Sari 071215)
    r = 200;
    [T,C]=size(At.x_Pos);
    avg_CosAng=nan(T,C);
    for t=2:T
        for i=1:C
            vi=[At.Velocity_X(t,i) At.Velocity_Y(t,i) At.Velocity_Z(t,i)]; %Changed for 3D (Sari 071215)
            sum_CosAng=0;
            n=0;
            for j=1:C
                if abs(At.x_Pos(t,j)-At.x_Pos(t,i))<r && abs(At.y_Pos(t,j)-At.y_Pos(t,i) )<r && abs(At.y_Pos(t,j)-At.y_Pos(t,i) )<r %Changed for 3D (Sari 071215)  
                    vj=[At.Velocity_X(t,j) At.Velocity_Y(t,j) At.Velocity_Z(t,j) ]; %Changed for 3D (Sari 071215)
                    CosAng=(vi(1)*vj(1)+vi(2)*vj(2)+vi(3)*vj(3))/(((vi(1)^2+vi(2)^2+vi(3)^2)^0.5)*((vj(1)^2+vj(2)^2+vj(3)^2)^0.5));%Changed for 3D (Sari 071215)    
                    if ~isnan(CosAng)
                        sum_CosAng=sum_CosAng+CosAng;
                        n=n+1;
                    end
                 end      
            end
        avg_CosAng(t,i)=sum_CosAng/n;
        end
    end
    At.Coll = avg_CosAng;
    %% dt
    At.dt = dt * 60;
    %% Center of mass
    At.Rx = 1./nansum(At.Volume,2) .* nansum((At.Volume .* At.x_Pos),2);
    At.Ry = 1./nansum(At.Volume,2) .* nansum((At.Volume .* At.y_Pos),2);
    
    %% Full Width Half Maximum Parameters
    
% %     All parameters are calculated for velocity

    At.Starting_Time = [];
    At.Starting_Value = [];
    At.Ending_Time = [];
    At.Ending_Value = [];
    At.Maximum_Height = [];
    At.Time_of_Maximum_Height = [];
    At.Full_Width_Half_Maximum = [];
    
    
    for j = 1 : size(At.Velocity,2)
        [m,idx] = nanmax(At.Velocity(:,j));
        StartingTime = find(At.Velocity(1:idx,j) < m/2,1,'last') ;
        if ~isempty(StartingTime)
            StartingValue = At.Velocity(StartingTime,j);
        else
            StartingTime = nan;
            StartingValue = nan;
        end
        EndingTime = find(At.Velocity(idx:end,j) < m/2,1,'first');
        if ~isempty(EndingTime)
            EndingValue = At.Velocity(EndingTime,j);
        else
            EndingTime = nan;
            EndingValue = nan;
        end

        if ~isnan(EndingTime) && ~isnan(StartingTime)
            FWHM = EndingTime - StartingTime;
        end
        if ~isnan(EndingTime) && isnan(StartingTime)
            FWHM = 2 * (EndingTime - idx);
        end
        if isnan(EndingTime) && ~isnan(StartingTime)
            FWHM = 2 * (idx - StartingTime);
        end
        if isnan(EndingTime) && isnan(StartingTime)
            FWHM = nan;
        end
        StartingTime = StartingTime * At.dt;
        EndingTime = EndingTime * At.dt;
        idx = idx * At.dt;
        
        
        
        At.Starting_Time = [At.Starting_Time StartingTime];
        At.Starting_Value = [At.Starting_Value StartingValue];
        At.Ending_Time = [At.Ending_Time EndingTime];
        At.Ending_Value = [At.Ending_Value EndingValue];
        At.Maximum_Height = [At.Maximum_Height m];
        At.Time_of_Maximum_Height = [At.Time_of_Maximum_Height idx];
        At.Full_Width_Half_Maximum = [At.Full_Width_Half_Maximum FWHM];
    end


    
    
    
    
    
end
        