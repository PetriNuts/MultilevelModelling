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
## @deftypefn {Function File} {@var{retval} =} bioAnim (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Jacek Chodak <jacek.chodak@b-tu.de>
## Created: 2018-01-26

function [retval] = bioAnim (strFile,
                             strColumnNamePattern,
                             cellColorSet,
                             vDimension,
                             vRange = [],
                             vColorScale = [],
                             strScale="lin",
                             bSave=false,
                             strDir="anim")
  # Init
  bIsLogScale = strcmp("log", strScale);
  LOGSCALE = [0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000 2000 5000 10000];
  cellDataSet = {"Time"};
  iDimension = length(vDimension); 
  # Set save dir
  if bSave
    cellPath = strsplit(strFile, {"/", "."});
    strDestinationDir = [strDir, "/", cell2mat(cellPath(1,length(cellPath) - 1))];
    # Make dir
    #mkdir(strDir);
    # only on linux/unix
    system(["mkdir -p ", strDestinationDir]);
  endif
  # Read data
  iLengthColorSet = size(cellColorSet)(2);
  cellData = readDataColorSetCSV(strFile, strColumnNamePattern, cellColorSet, vDimension);
  # Tiem
  vDataTime = readDataColorCSV(strFile, "Time");
  vTime = vDataTime;
  if isempty(vRange)
    iFrames = length(vTime);
    vRange = 1:1:iFrames;
  endif
  # Calculate data size
  switch (iDimension)
  case 1
    iDataSize = length(cellData{1}(1,:));
  case 2
    iDataSize = sqrt(length(cellData{1}(1,:)));
    N = iDataSize*ones(1,iDataSize);
  endswitch
  # Max color value
  if length(vColorScale) < iLengthColorSet
    for iIdx = (length(vColorScale) + 1):iLengthColorSet
      vMaxColorScaleZ(iIdx) = max(max(max(cellData{iIdx})));
    end
  else
    vMaxColorScaleZ = vColorScale;
  endif
  # Animation
  figure();
  for iIdx = vRange
  
    for iIdxColorSet = 1:iLengthColorSet
      # Preparing matrix to plot
       switch (iDimension)
        case 1
          Z = cellData{iIdxColorSet}(iIdx,:);
        case 2
          cellZ = mat2cell(cellData{iIdxColorSet}(iIdx,:), 1, N);
          Z = cell2mat(cellZ');
      endswitch
      if bIsLogScale
        Z = log10(Z);
      endif
      subplot (iLengthColorSet, 1, iIdxColorSet);
      imagesc(Z);
      if bIsLogScale
        colorbar("YTick", log10(LOGSCALE), "YTickLabel", LOGSCALE);
        caxis(log10([LOGSCALE(1) dMaxColorScaleZ]));
      else
        colorbar;
        caxis([0 vMaxColorScaleZ(iIdxColorSet)]);
      endif
      switch (iDimension)
        case 1
          set(gca,'dataAspectRatio', [2 1 1]);
          set(gca, "yticklabel", "");
        case 2
          set(gca,'dataAspectRatio', [1 1 1]);
      endswitch
      # change postion of orgin to Right/Down
      view([0 -90]);
      # Titile
      strTitle=sprintf("Time Frame %d", iIdx);
      title(strTitle);
      xlabel(cellColorSet{iIdxColorSet});
    end
    if bSave
      pause(.00001);
      strFilename = [strDestinationDir, sprintf("/frame%05d.png", iIdx)];
      print(strFilename);
      # Save to pdf
      # print([strFilename ".pdf"], "-append");
    else
      pause(.00001);
    endif
  
  end

  
endfunction
