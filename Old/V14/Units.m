function uni = Units(par)
% Returns the units of par
    switch par
        case 'Vsize_2D'
            uni = '[\mum/h]';
        case 'Vx'
            uni = '[\mum/h]';
        case 'Vy'
            uni = '[\mum/h]';
        case 'Displacement2_IM'
            uni = '[\mum^2]'; 
        case 'Area'
            uni = '[\mum^2]';
        case 'Velocity'
            uni = '[\mum/h]';
        case 'Velocity_X'
            uni = '[\mum/h]';
        case 'Velocity_Y'
            uni = '[\mum/h]';
        case 'Velocity_Z'
            uni = '[\mum/h]';
        case 'Acceleration'
            uni = '[\mum/h^2]';
        case 'Acceleration_X'
            uni = '[\mum/h^2]';
        case 'Acceleration_Y'
            uni = '[\mum/h^2]';
        case 'Acceleration_Z'
            uni = '[\mum/h^2]';
        case 'Center_of_Homogeneous_Mass_X'
            uni = '[\mum]';
        case 'Center_of_Homogeneous_Mass_Y'
            uni = '[\mum]';
        case 'Center_of_Homogeneous_Mass_Z'
            uni = '[\mum]';
        case 'Displacement2'
            uni = '[\mum^2]';
        case 'EllipsoidAxisLengthA'
            uni = '[\mum]';
        case 'EllipsoidAxisLengthB'
            uni = '[\mum]';
        case '[EllipsoidAxisLengthC]'
            uni = '[\mum]';
        case 'x_Pos'
            uni = '[\mum]';
        case 'y_Pos'
            uni = '[\mum]';
        case 'z_Pos'
            uni = '[\mum]';
        case 'Track_Displacement_X'
            uni = '[\mum]';
        case 'Track_Displacement_Y'
            uni = '[\mum]';
        case 'Track_Displacement_Z'
            uni = '[\mum]';
        case 'Volume'
            uni = '[\mum^3]';
        case 'Displacement'
            uni = '[\mum]';
        case 'MSD'
            uni = '[\mum^2]';
        case 'Starting_Time'
            uni = '[min]';
        case 'Starting_Value'
            uni = '[\mum/h]';
        case 'Ending_Time'
            uni = '[min]';
        case 'Ending_Value'
            uni = '[\mum/h]';
        case 'Maximum_Height'
            uni = '[\mum/h]';
        case 'Time_of_Maximum_Height'
            uni = '[min]';
        case 'Full_Width_Half_Maximum'
            uni = '[min]';
        otherwise 
            uni = '';
    end
end