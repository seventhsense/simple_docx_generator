"hi HitLine ctermbg=Cyan guibg=Cyan
"hi MissLine ctermbg=Magenta guibg=Magenta
hi HitSign ctermfg=Green cterm=bold gui=bold guifg=Green
hi MissSign ctermfg=Red cterm=bold gui=bold guifg=Red

sign define hit  linehl=HitLine  texthl=HitSign  text=>>
sign define miss linehl=MissLine texthl=MissSign text=:(

"Generated by simplecov-vim
let s:coverage = {'lib/simple_docx_generator.rb': [[5, 6],[]], 'lib/simple_docx_generator/mydocx.rb': [[3, 4, 13, 24, 30, 31, 32, 33, 34, 35, 43, 44, 45, 46, 48, 55, 56, 57, 64, 65, 70, 71, 72, 79, 80, 81, 82, 83, 84, 85, 86, 96, 97, 98, 99, 100, 101, 102, 103, 105, 110, 111, 114, 115, 116, 117, 118, 122, 123, 124, 125, 126, 127, 128, 129, 133, 137, 138, 139, 141, 144, 145, 146, 147, 148, 149, 150, 152, 154, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 176, 177, 179, 180],[182]], 'lib/simple_docx_generator/version.rb': [[1, 2],[]], 'spec/simple_docx_generator_spec.rb': [[],[]],  }

let s:generatedTime = 1476311082

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
