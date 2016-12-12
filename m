From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 12 Dec 2016 15:08:51 -0800
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2/reflink: fix file block size
	reporting
In-Reply-To: <20161212094820.GY29149@eguan.usersys.redhat.com>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
	<148149317758.31093.14955725683270205488.stgit@birch.djwong.org>
	<20161212094820.GY29149@eguan.usersys.redhat.com>
Message-ID: <20161212230851.GI25841@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eryu Guan <eguan@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

On Mon, Dec 12, 2016 at 05:48:20PM +0800, Eryu Guan wrote:
> On Sun, Dec 11, 2016 at 01:52:57PM -0800, Darrick J. Wong wrote:
> > Some of the reflink tests try to require a specific filesystem block
> > size so that they can test file block manipulation functions.  That's
> > straightforward for most filesystems but ocfs2 throws in the additional
> > twist that data fork block mappings are stored in units of clusters, not
> > blocks, which causes these reflink tests to fail.
> > 
> > Therefore, introduce a new helper that retrieves the file minimum block
> > size and adapt the reflink tests to use that instead.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc         |   21 +++++++++++++++++++--
> >  tests/generic/205 |    2 +-
> >  tests/generic/206 |    2 +-
> >  tests/generic/216 |    2 +-
> >  tests/generic/217 |    2 +-
> >  tests/generic/218 |    2 +-
> >  tests/generic/220 |    2 +-
> >  tests/generic/222 |    2 +-
> >  tests/generic/227 |    2 +-
> >  tests/generic/229 |    2 +-
> >  tests/generic/238 |    2 +-
> >  11 files changed, 29 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 2639fbd..30111d4 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -925,7 +925,7 @@ _scratch_mkfs_blocksized()
> >  	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
> >  	;;
> >      ocfs2)
> > -	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
> > +	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize -C $blocksize $SCRATCH_DEV
> >  	;;
> >      *)
> >  	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
> > @@ -3029,13 +3029,30 @@ _sysfs_dev()
> >  	echo /sys/dev/block/$_maj:$_min
> >  }
> >  
> > +# Get the minimum block size of a file.  Usually this is the
> > +# minimum fs block size, but some filesystems (ocfs2) do block
> > +# mappings in larger units.
> > +get_file_block_size()
> 
> Name it with leading underscore? As it's a common helper.
> 
> > +{
> > +	if [ -z $1 ] || [ ! -d $1 ]; then
> > +		echo "Missing mount point argument for get_file_block_size"
> > +		exit 1
> > +	fi
> > +	if [ "$FSTYP" = "ocfs2" ]; then
> > +		stat -c '%o' $1
> > +	else
> > +		stat -f -c '%S' $1
> 
> We can use "get_block_size $1" here.
> 
> > +	fi
> > +}
> > +
> > +# Get the minimum block size of an fs.
> >  get_block_size()
> 
> We should rename it with a underscore too, but probably in an different
> patch.

Ok.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
