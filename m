From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 12 Dec 2016 15:03:53 -0800
Subject: [Ocfs2-devel] [PATCH 4/7] reflink: fix space consumption tests
In-Reply-To: <20161212102539.GA29149@eguan.usersys.redhat.com>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
	<148149319048.31093.2083894591825614863.stgit@birch.djwong.org>
	<20161212102539.GA29149@eguan.usersys.redhat.com>
Message-ID: <20161212230352.GF25841@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eryu Guan <eguan@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

On Mon, Dec 12, 2016 at 06:25:39PM +0800, Eryu Guan wrote:
> On Sun, Dec 11, 2016 at 01:53:10PM -0800, Darrick J. Wong wrote:
> > Some of the tests try to check that we can't COW when we're out of
> > space, but some tricky filesystems make this hard because writing N
> > blocks doesn't increase used blocks by N....
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/populate   |   14 ++++++++++++++
> >  tests/generic/171 |    5 ++---
> >  tests/generic/173 |    5 ++---
> >  tests/generic/174 |    5 ++---
> >  tests/generic/282 |    3 +--
> >  5 files changed, 21 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index d0003c5..9811d21 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -30,6 +30,20 @@ _require_xfs_db_blocktrash_z_command() {
> >  	$XFS_DB_PROG -x -f -c 'blocktrash -z' "${TEST_DEV}" | grep -q 'nothing on stack' || _notrun "blocktrash -z not supported"
> >  }
> >  
> > +# Eat free space until we can't anymore.
> > +_consume_free_space() {
> > +	dir=$1
> > +
> > +	old_nr_free=0
> > +	nr_free=$(stat -f -c '%f' $dir)
> > +	x=0
> > +	while [ $nr_free -gt 0 ] && [ $old_nr_free != $nr_free ]; do
> > +		$XFS_IO_PROG -f -c "pwrite -b 4194304 0 $((blksz * nr_free))" $dir/eat_my_space.$((x++))
> 
> blksz not defined in the function.
> 
> Xiaoguang Wang did something similar back in Nov. and I'm still queuing
> his patch. (His 1/2 patch conflicts with your scrub/repair patchset and
> it might be easier for you to let your patches go first.)
> 
> generic: make 17[1-4] work well when btrfs compression is enabled
> https://patchwork.kernel.org/patch/9408451/
> 
> Does this patch work for you? If so, perhaps you only need to update
> generic/282 using the "_fill_fs" helper?

Aha!  I had this feeling in the back of my head that someone was
already trying to push a helper function.

At this point XFS online scrub/repair is slipping to 4.11 anyway so you
may as well take Xioguang's patches and I'll just rebase all my stuff
off of that.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
