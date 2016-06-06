function xls_run_macro(xlsfile,macro,params)
% 
% Run MS Excel macro
% 
% 
%USAGE
%-----
% xls_run_macro(xlsfile,macro)
% xls_run_macro(xlsfile,macro,params)
% 
% 
%INPUT
%-----
% - XLSFILE: name of the Excel file
% - MACRO  : macro name
% - PARAMS : parameters for the MACRO
% 
% 
%OUTPUT
%------
% - XLSFILE will be edited
% 
% 
%N.B.
% - In some cases when an error occurs, MS Excel must be manually closed
%   (in Task Manager for Windows systems)
% - Some macros do not run if the visibility of MS Excel is off. So it is
%   on by default.
% 
% 
% Based on "How can I run an Excel macro from MATLAB?"
% (http://www.mathworks.com/support/solutions/en/data/1-5VWJJT/index.html)
% 
% 
% See also XLS_CHECK_IF_OPEN
% 

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2012-Dec-30, 09:02 pm


% Input
%==========================================================================
if exist(xlsfile,'file')~=2
    fprintf('%s not found.\n',xlsfile)
    return
end
if ~ischar(macro)
    disp('Invalid input for MACRO.')
    return
end


% Close Excel file
%-----------------
tmp = xls_check_if_open(xlsfile,'close');
if tmp~=0 && tmp~=10
    fprintf('%s could not be closed.\n',xlsfile)
    return
end


% The full path is required for the command "Workbooks.Open" to work
% properly
%-------------------------------------------------------------------
if isempty(strfind(xlsfile,filesep))
    xlsfile = fullfile(pwd,xlsfile);
end


% Read Excel file
%==========================================================================
Excel     = actxserver('Excel.Application'); % open Excel as a COM Automation server
set(Excel,'Visible',1);                      % make the application visible
 % or ExcelApp.Visible = 1;
 % necessary for some macros to run properly
set(Excel,'DisplayAlerts',0);                % make Excel not display alerts (e.g., sound and confirmation)
 % or Excel.Application.DisplayAlerts = false; % or 0
Workbooks = Excel.Workbooks;                 % get handle to Excel's Workbooks
Workbook  = Workbooks.Open(xlsfile);         % open the Excel Workbook and activate it


% Execute macro
%==========================================================================
try
    if nargin==3
        Excel.Run(macro,params);
    else
        Excel.Run(macro);
        %Excel.ExecuteExcel4Macro(sprintf('''!%s()',macro));
    end
catch ME
    disp(ME.message)
end


% Save and close
%==========================================================================
Workbook.SaveAs(xlsfile);   % save the workbook
Workbooks.Close; % close the workbook
try
    Excel.Quit;      % quit Excel
catch
    invoke(Excel,'Quit');
end
%Excel.release;   % release object
delete(Excel);   % delete the handle to the ActiveX Object

clear Excel Workbooks Workbook Sheets