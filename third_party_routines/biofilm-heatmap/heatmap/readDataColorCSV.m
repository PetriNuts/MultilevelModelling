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

function [retval] = readDataColorCSV (strFile, strColor)
  # init
  iSkip = 1;
  iIdxCell = 0;
  # Read data
  DATA = csvread(strFile, iSkip, 0);
  vData = [];
  # Read header
  fileId = fopen(strFile, "r");
  strHeader = fgetl(fileId);
  # Split header
  HEADER(1,:) = regexp(strHeader, "\,", "split");
  iHeaderLength = length(HEADER(1,:));
  iStartColumn = 0;
  iEndColumn = 0;
  for iIdx = 1:iHeaderLength
    if strncmpi(strColor, cell2mat(HEADER(1, iIdx)), length(strColor))
      if iStartColumn == 0
        iStartColumn = iIdx;
      endif
      iEndColumn = iIdx;
    endif
  end
  if iStartColumn > 0
    vData = DATA(:, iStartColumn:iEndColumn);
  endif
  # return;
  retval = [vData];
endfunction
