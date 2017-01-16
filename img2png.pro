;+
; NAME:
;	img2png.pro
;
; PURPOSE:
;	Converts an unformatted binary img file to a png
;
; AUTHOR:
;	Alex Fraser
;
; CATEGORY:
;	Utility
;
;
; CALLING SEQUENCE:
;	img2png, xdim, ydim, min, max, rotate7
;
;
; INPUTS:
;	A whole lot of .img files in the same directory as this program
;	
;	xdim: x-dimension of the image (no default - required)
;	ydim: y-dimension of the image (no default - required)
;	min: minimum for output scaling (no default - required)
;	max: maximum for output scaline (no default - required)
;	rotate7: if nonzero, rotate data by "7"
;
; KEYWORDS:
;	none
;
; OUTPUTS:
;	a directory (iodir/output/) containing png files
;
; RESTRICTIONS:
;	currently only correctly converts bsq interleave.
;	currently, image must be a floating point image
;	currently, image must be greyscale
;
; EXAMPLE:
;	img2png, xdim=1024, ydim=768, min=0,max=0.8
;
;
; MODIFICATION HISTORY:
;
;	Written by Alex Fraser, Jan 2008.
;	Updated Jan 2017. Happy 9 year anniversary, code!
;-

pro img2png, xdim=x, ydim=y, min=scalemin, max=scalemax, rotate7=rotflag
  
  ;propmt for the directory
  dir = dialog_pickfile(TITLE="Choose the directory containing the .img files", /DIRECTORY)
  
  ;Make the output directory
  FILE_MKDIR, dir+'output'
  
  ; Generate a list of all the .img files in this directory
  imglist = file_search(dir, '*.img')
  
  
  ;generate some blank space for the data
  data = FltArr(x,y)
  
  
  ;for each one of these files
  FOR i=0, n_elements(imglist)-1 DO BEGIN
  
  
  	;open the unformatted file
  	OpenR,  lun, imglist[i], /Get_Lun
  	ReadU, lun, data
  	Free_Lun, lun
  	
  	if rotflag ne 0 then begin
  	 data=rotate(data,7)
  	endif
  
  	;generate a new filename for the output png
  	;to do this, calculate the length of the imglist[i] string
  	strlength = strlen(imglist[i])
  	filename = STRMID(imglist[i], 0, strlength-4)
  	basename=file_basename(filename)
  	
  	
  	filename = dir+"output/"+basename+".png"
  
  	;write out the data
  	write_png, filename, bytscl(data, min=scalemin, max=scalemax)
  ENDFOR


end