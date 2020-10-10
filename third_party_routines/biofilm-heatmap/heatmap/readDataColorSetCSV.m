## Copyright (C) 2018 Jacek Chodak
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} readDataCSV (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Jacek Chodak <jacek.chodak@b-tu.de>
## Created: 2018-01-25

function [retval] = readDataColorSetCSV (strFile, strColumnNamePattern, cellColorSet, vDimension)
# init
  iSkip = 1;
  iIdxCell = 0;
  iDataSize = 11;
  iDimension = length(vDimension); 
  # Read data
  DATA = csvread(strFile, iSkip, 0);
  cellColorData = cell();
  iDataLength = length(DATA(:, 1));
  # Read header
  fileId = fopen(strFile, "r");
  strHeader = fgetl(fileId);
  # Split header
  HEADER(1,:) = regexp(strHeader, "\,", "split");
  iHeaderLength = length(HEADER(1,:));
  # Calculate data size
  switch (iDimension)
  case 1
    iDataSize1D = vDimension(1);#length(subSetData(1,:));
    iDataSize2D = 1;
    iDataSize3D = 1;
  case 2
    iDataSize1D = vDimension(1);#sqrt(length(subSetData(1,:)));
    iDataSize2D = vDimension(2);
    iDataSize3D = 1;
  endswitch
  
  
  for cellStrColorSet = cellColorSet
    strColorSet = cellStrColorSet{1};
    iIdxCell++;
    iIdxColumn = 0;
    subSetData = zeros(iDataLength, iDataSize1D * iDataSize2D * iDataSize3D);
    #
    cellColumns = cell();
    structData = struct();
    for iIdxX = 1:iDataSize1D
      for iIdxY = 1:iDataSize2D
        for iIdxZ = 1:iDataSize3D
        iIdxColumn++;
        strColorPos = sprintf(strColumnNamePattern, strColorSet, iIdxX, iIdxY, iIdxZ);
        cellColumns{iIdxColumn} = strColorPos;
        structData.(strColorPos) = zeros(iDataLength, 1);
        end
      end
    end
    
    for iIdx = 1:iHeaderLength
       try
        structData.(HEADER(1, iIdx){1});
        structData.(HEADER(1, iIdx){1}) =  DATA(:, iIdx);
       catch
       ## NotInColorSet
       end_try_catch
    end
    ## Iterate over struct 
    #keys = fieldnames(structData);
    #for iIdxSorted = 1:numel(keys)
    #  sortedData(:, iIdxSorted) = structData.(keys{iIdxSorted});
    #end
    for iIdxSorted = 1:numel(cellColumns)
      sortedData(:, iIdxSorted) = structData.(cellColumns{iIdxSorted});
    end
 
    cellColorData(iIdxCell) = sortedData;
   
  end
  # return;
  retval = [cellColorData];
endfunction
