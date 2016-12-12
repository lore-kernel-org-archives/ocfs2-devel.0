From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 12 Dec 2016 15:06:37 -0800
Subject: [Ocfs2-devel] [PATCH 5/7] reflink: make error reporting
	consistent
In-Reply-To: <20161212104630.GB29149@eguan.usersys.redhat.com>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
	<148149319659.31093.17539238147279139276.stgit@birch.djwong.org>
	<20161212104630.GB29149@eguan.usersys.redhat.com>
Message-ID: <20161212230637.GG25841@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eryu Guan <eguan@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

On Mon, Dec 12, 2016 at 06:47:43PM +0800, Eryu Guan wrote:
> On Sun, Dec 11, 2016 at 01:53:16PM -0800, Darrick J. Wong wrote:
> > When we're using dm-error to simulate failed devices, we don't really
> > know if the write or the fdatasync is going to receive the EIO.  So,
> > capture the entire output and just look for the word error instead
> > of enshrining it in the golden output.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/265     |    6 +++++-
> >  tests/generic/265.out |    1 -
> >  tests/generic/266     |    5 ++++-
> >  tests/generic/266.out |    1 -
> >  tests/generic/267     |    2 +-
> >  tests/generic/268     |    5 ++++-
> >  tests/generic/268.out |    1 -
> >  tests/generic/271     |    5 +++--
> >  tests/generic/271.out |    1 -
> >  tests/generic/272     |    5 +++--
> >  tests/generic/272.out |    1 -
> >  tests/generic/276     |    2 +-
> >  tests/generic/276.out |    1 -
> >  tests/generic/278     |    5 +++--
> >  tests/generic/278.out |    1 -
> >  tests/generic/279     |    4 ++--
> >  tests/generic/279.out |    1 -
> >  tests/generic/281     |    4 ++--
> >  tests/generic/281.out |    1 -
> >  tests/generic/283     |    6 ++++--
> >  tests/generic/283.out |    1 -
> >  21 files changed, 32 insertions(+), 27 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/265 b/tests/generic/265
> > index 8e9d5bc..ceddfbe 100755
> > --- a/tests/generic/265
> > +++ b/tests/generic/265
> > @@ -80,7 +80,11 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
> > +urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
> > +	-c "fdatasync" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
> > +
> >  _dmerror_load_working_table
> >  _dmerror_unmount
> >  _dmerror_mount
> > diff --git a/tests/generic/265.out b/tests/generic/265.out
> > index 1b67114..31eb4e9 100644
> > --- a/tests/generic/265.out
> > +++ b/tests/generic/265.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file2
> >  CoW and unmount
> > -fdatasync: Input/output error
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file1
> >  Check for damage
> > diff --git a/tests/generic/266 b/tests/generic/266
> > index 4f9816a..09541c8 100755
> > --- a/tests/generic/266
> > +++ b/tests/generic/266
> > @@ -80,7 +80,10 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
> > +urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
> > +	-c "fdatasync" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
> >  
> >  echo "Clean up the mess"
> >  _dmerror_unmount
> > diff --git a/tests/generic/266.out b/tests/generic/266.out
> > index dd34ad3..1641654 100644
> > --- a/tests/generic/266.out
> > +++ b/tests/generic/266.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file2
> >  CoW and unmount
> > -fdatasync: Input/output error
> >  Clean up the mess
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file1
> > diff --git a/tests/generic/267 b/tests/generic/267
> > index e3a6b0c..2ec6ad9 100755
> > --- a/tests/generic/267
> > +++ b/tests/generic/267
> > @@ -80,7 +80,7 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full
> > +$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
> >  _dmerror_load_working_table
> >  rm -rf $testdir/file2 >> $seqres.full 2>&1
> >  _dmerror_unmount
> > diff --git a/tests/generic/268 b/tests/generic/268
> > index c7dcd57..b7d16ab 100755
> > --- a/tests/generic/268
> > +++ b/tests/generic/268
> > @@ -81,7 +81,10 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
> > +urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
> > +	-c "fdatasync" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
> >  _dmerror_load_working_table
> >  
> >  echo "Rewrite"
> > diff --git a/tests/generic/268.out b/tests/generic/268.out
> > index 234e8be..1a3b39a 100644
> > --- a/tests/generic/268.out
> > +++ b/tests/generic/268.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file2
> >  CoW and unmount
> > -fdatasync: Input/output error
> >  Rewrite
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file1
> > diff --git a/tests/generic/271 b/tests/generic/271
> > index ded8854..9439327 100755
> > --- a/tests/generic/271
> > +++ b/tests/generic/271
> > @@ -81,8 +81,9 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
> > -	2>&1 >> $seqres.full | _filter_xfs_io_error
> > +urk=$($XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "dio pwrite did not fail"
> >  _dmerror_load_working_table
> >  _dmerror_unmount
> >  _dmerror_mount
> > diff --git a/tests/generic/271.out b/tests/generic/271.out
> > index 54d5b0d..9b44ee7 100644
> > --- a/tests/generic/271.out
> > +++ b/tests/generic/271.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file2
> >  CoW and unmount
> > -pwrite: Input/output error
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file1
> >  Check for damage
> > diff --git a/tests/generic/272 b/tests/generic/272
> > index 5bc5b39..243adf5 100755
> > --- a/tests/generic/272
> > +++ b/tests/generic/272
> > @@ -81,8 +81,9 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
> > -	2>&1 >> $seqres.full | _filter_xfs_io_error
> > +urk=$($XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "dio pwrite did not fail"
> >  
> >  echo "Clean up the mess"
> >  _dmerror_unmount
> > diff --git a/tests/generic/272.out b/tests/generic/272.out
> > index 0b8bdca..10ecda9 100644
> > --- a/tests/generic/272.out
> > +++ b/tests/generic/272.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file2
> >  CoW and unmount
> > -pwrite: Input/output error
> >  Clean up the mess
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file1
> > diff --git a/tests/generic/276 b/tests/generic/276
> > index 83b902e..34b0029 100755
> > --- a/tests/generic/276
> > +++ b/tests/generic/276
> > @@ -82,7 +82,7 @@ echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> >  $XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
> > -	2>&1 >> $seqres.full | _filter_xfs_io_error
> > +	>> $seqres.full 2>&1
> 
> This seems different, the error is ignored after this update and test
> passes even if there's no error happened. Is this intentional?
> 
> The same question applies to generic/279 and generic/281.

Yes, it's intentional.  Some of the tests g/{276,279,281} let the first
write attempt fail and never retry, so it's sufficient to check the
md5sum hasn't changed even after recovery.  The others actually /do/
retry the write after removing the dm-error, so we have to check that
something spat out an error message.

Hmmm... that should go in the commit message next time around.

--D

> 
> Thanks,
> Eryu
> 
> >  _dmerror_load_working_table
> >  rm -rf $testdir/file2 >> $seqres.full 2>&1
> >  _dmerror_unmount
> > diff --git a/tests/generic/276.out b/tests/generic/276.out
> > index 88a0162..a080dd0 100644
> > --- a/tests/generic/276.out
> > +++ b/tests/generic/276.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file2
> >  CoW and unmount
> > -pwrite: Input/output error
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file1
> >  Check for damage
> > diff --git a/tests/generic/278 b/tests/generic/278
> > index 415742a..d751f01 100755
> > --- a/tests/generic/278
> > +++ b/tests/generic/278
> > @@ -82,8 +82,9 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
> > -	2>&1 >> $seqres.full | _filter_xfs_io_error
> > +urk=$($XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "dio pwrite did not fail"
> >  _dmerror_load_working_table
> >  
> >  echo "Rewrite"
> > diff --git a/tests/generic/278.out b/tests/generic/278.out
> > index 9ead4ac..cd22fcd 100644
> > --- a/tests/generic/278.out
> > +++ b/tests/generic/278.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file2
> >  CoW and unmount
> > -pwrite: Input/output error
> >  Rewrite
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file1
> > diff --git a/tests/generic/279 b/tests/generic/279
> > index 2f1ec4f..4541de3 100755
> > --- a/tests/generic/279
> > +++ b/tests/generic/279
> > @@ -80,8 +80,8 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" -c "msync -s 0 $filesize" $testdir/file2 > $TEST_DIR/mwrite.out 2>&1)
> > -cat $TEST_DIR/mwrite.out | tee -a $seqres.full
> > +$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
> > +	-c "msync -s 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
> >  _dmerror_load_working_table
> >  _dmerror_unmount
> >  _dmerror_mount
> > diff --git a/tests/generic/279.out b/tests/generic/279.out
> > index f34c2b2..009f05e 100644
> > --- a/tests/generic/279.out
> > +++ b/tests/generic/279.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file2
> >  CoW and unmount
> > -msync: Input/output error
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file1
> >  Check for damage
> > diff --git a/tests/generic/281 b/tests/generic/281
> > index c95acf2..e8e1661 100755
> > --- a/tests/generic/281
> > +++ b/tests/generic/281
> > @@ -80,8 +80,8 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" -c "msync -s 0 $filesize" $testdir/file2 > $TEST_DIR/mwrite.out 2>&1)
> > -cat $TEST_DIR/mwrite.out | tee -a $seqres.full
> > +$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
> > +	-c "msync -s 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
> >  
> >  echo "Clean up the mess"
> >  _dmerror_unmount
> > diff --git a/tests/generic/281.out b/tests/generic/281.out
> > index a2d8e3f..1bae187 100644
> > --- a/tests/generic/281.out
> > +++ b/tests/generic/281.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file2
> >  CoW and unmount
> > -msync: Input/output error
> >  Clean up the mess
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file1
> > diff --git a/tests/generic/283 b/tests/generic/283
> > index 8d56ac3..7bfdb4d 100755
> > --- a/tests/generic/283
> > +++ b/tests/generic/283
> > @@ -81,8 +81,10 @@ md5sum $testdir/file2 | _filter_scratch
> >  echo "CoW and unmount"
> >  sync
> >  _dmerror_load_error_table
> > -urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" -c "msync -s 0 $filesize" $testdir/file2 > $TEST_DIR/mwrite.out 2>&1)
> > -cat $TEST_DIR/mwrite.out | tee -a $seqres.full
> > +urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
> > +	-c "msync -s 0 $filesize" $testdir/file2 2>&1)
> > +echo $urk >> $seqres.full
> > +echo "$urk" | grep -q "error" || _fail "mwrite did not fail"
> >  _dmerror_load_working_table
> >  
> >  echo "Rewrite"
> > diff --git a/tests/generic/283.out b/tests/generic/283.out
> > index f9fd5c8..b475054 100644
> > --- a/tests/generic/283.out
> > +++ b/tests/generic/283.out
> > @@ -5,7 +5,6 @@ Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file1
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file2
> >  CoW and unmount
> > -msync: Input/output error
> >  Rewrite
> >  Compare files
> >  1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
