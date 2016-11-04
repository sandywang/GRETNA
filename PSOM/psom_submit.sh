#!/bin/bash

# NAME
#    psom_submit - submit a job and reports failure with tag files
#
# SYNOPSIS
#    psom_submit COMMAND FILE_FAILED FILE_EXIT FILE_OQSUB
#
# DESCRIPTION
#    This is a simple script to submit jobs (or execute any command, really) 
#    and generate empty tag files (as well as a warning) if the submission fails.
#    CMD is the command to execute
#    FILE_FAILED, FILE_EXIT and FLAG_OQSUB are the name of the tag files generated
#    in case of failure
#
# COPYRIGHT
#    Pierre Bellec, Departement d'informatique et de recherche operationnelle
#    Centre de recherche de l'institut de Geriatrie de Montreal
#    Universite de Montreal, 2012.
#    Maintainer : pierre.bellec@criugm.qc.ca
#    See licensing information in the code.

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
echo Submitting the job with the following command:
echo $1
eval $1
if [ $? -ne 0 ]
then
    echo The submission of the job through $1 failed
    touch $2
    touch $3
    touch $4
fi
