@echo off

if [%~1]==[] goto :blank1
if [%~2]==[] goto :blank2

for %%a in (%2) do (
    set dstrepo=%%~fa
    set filepath=%%~dpa
    set filename=%%~nxa
)    
set temppath=%filepath%__%filename%

git init --bare %temppath%
pushd %1
hg push %temppath%
popd
git clone %temppath% %dstrepo%
echo Removing temporary git repo '%temppath%'
rmdir /s/q %temppath%
echo.
echo Git repo ready at '%dstrepo%' and is a copy of '%1'
pushd %dstrepo%
git status
popd

goto done

:blank1
ECHO ERROR: No source repo parameter
goto usage

:blank2
ECHO ERROR: No dest repo parameter
goto usage

:usage
ECHO.
ECHO usage: script ^<source-hg-repo^> ^<dest-git-repo^>
ECHO          ^<source-hg-repo^> must be a mercurial repo
ECHO          ^<dest-git-repo^> must not exist
ECHO.
ECHO notes:
ECHO        The mercurial repo must have BOOKMARKS on every
ECHO        branch that is to be converted. No bookmark means
ECHO        no transfer of that branch.

:done

