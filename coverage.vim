"hi HitLine ctermbg=Cyan guibg=Cyan
"hi MissLine ctermbg=Magenta guibg=Magenta
hi HitSign ctermfg=Green cterm=bold gui=bold guifg=Green
hi MissSign ctermfg=Red cterm=bold gui=bold guifg=Red

sign define hit  linehl=HitLine  texthl=HitSign  text=>>
sign define miss linehl=MissLine texthl=MissSign text=:(

"Generated by simplecov-vim
let s:coverage = {'simple_docx_generator.rb': [[1, 2],[]], 'simple_docx_generator/mydocx.rb': [[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 19, 23, 24, 25, 29, 30, 33, 34, 35, 39, 40, 41, 42, 43, 44, 47, 50, 51, 52, 53, 54, 57, 58, 59, 60, 61, 62, 63, 64, 68, 72, 73, 74, 76, 79, 80, 81, 82, 83, 84, 85, 87, 89, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 114, 115, 121, 127],[117, 122, 123, 124, 128, 129, 130]],  }

let s:generatedTime = 1352590222

function! BestCoverage(coverageForName)
  let matchBadness = strlen(a:coverageForName)
  for filename in keys(s:coverage)
    let matchQuality = match(a:coverageForName, filename . "$")
    if (matchQuality >= 0 && matchQuality < matchBadness)
      let found = filename
    endif
  endfor

  if exists("found")
    return s:coverage[found]
  else
    echom "No coverage recorded for " . a:coverageForName
    return [[],[]]
  endif
endfunction

let s:signs = {}
let s:signIndex = 1

function! s:CoverageSigns(filename)
  let [hits,misses] = BestCoverage(a:filename)

  if (getftime(a:filename) > s:generatedTime)
    echom "File is newer than coverage report which was generated at " . strftime("%c", s:generatedTime)
  endif

  if (! exists("s:signs['".a:filename."']"))
    let s:signs[a:filename] = []
  endif

  for hit in hits
    let id = s:signIndex
    let s:signIndex += 1
    let s:signs[a:filename] += [id]
    exe ":sign place ". id ." line=".hit." name=hit  file=" . a:filename
  endfor

  for miss in misses
    let id = s:signIndex
    let s:signIndex += 1
    let s:signs[a:filename] += [id]
    exe ":sign place ".id." line=".miss." name=miss file=" . a:filename
  endfor
endfunction

function! s:ClearCoverageSigns(filename)
  if(exists("s:signs['". a:filename."']"))
    for signId in s:signs[a:filename]
      exe ":sign unplace ".signId
    endfor
    let s:signs[a:filename] = []
  endif
endfunction

let s:filename = expand("<sfile>")
function! s:AutocommandUncov(sourced)
  if(a:sourced == s:filename)
    call s:ClearCoverageSigns(expand("%:p"))
  endif
endfunction

command! -nargs=0 Cov call s:CoverageSigns(expand("%:p"))
command! -nargs=0 Uncov call s:ClearCoverageSigns(expand("%:p"))

augroup SimpleCov
  au!
  exe "au SourcePre ".expand("<sfile>:t")." call s:AutocommandUncov(expand('<afile>:p'))"
augroup end

Cov
