set my_path = ($path)
source /data/aces/aces1/quarantines/Linux-i686/Feb-14-2008/init-sge.csh > /dev/null
set path = ($my_path $path)
setenv MINC_COMPRESS 0
unsetenv MINC_FORCE_V2
