From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Fri, 11 Nov 2016 01:01:19 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: implement the VFS clone_range,
 copy_range, and dedupe_range features
In-Reply-To: <5b95de23-5751-72a6-1733-2af0a683c80f@suse.com>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
	<147873190419.2820.6549312356582219407.stgit@birch.djwong.org>
	<8dd17796-6128-545f-6854-a43b7cd6321d@suse.com>
	<20161111062047.GD21519@birch.djwong.org>
	<5b95de23-5751-72a6-1733-2af0a683c80f@suse.com>
Message-ID: <20161111090119.GE21519@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Ren <zren@suse.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Nov 11, 2016 at 02:45:54PM +0800, Eric Ren wrote:
> On 11/11/2016 02:20 PM, Darrick J. Wong wrote:
> >On Fri, Nov 11, 2016 at 01:49:48PM +0800, Eric Ren wrote:
> >>Hi,
> >>
> >>A few issues obvious to me:
> >>
> >>On 11/10/2016 06:51 AM, Darrick J. Wong wrote:
> >>>Connect the new VFS clone_range, copy_range, and dedupe_range features
> >>>to the existing reflink capability of ocfs2.  Compared to the existing
> >>>ocfs2 reflink ioctl We have to do things a little differently to support
> >>>the VFS semantics (we can clone subranges of a file but we don't clone
> >>>xattrs), but the VFS ioctls are more broadly supported.
> >>How can I test the new ocfs2 reflink (with this patch) manually? What
> >>commands should I use to do xxx_range things?
> >See the 'reflink', 'dedupe', and 'copy_range' commands in xfs_io.
> >
> >The first two were added in xfsprogs 4.3, and copy_range in 4.7.
> 
> OK, thanks. I think you are missing the following two inline comments:
> 
> >>>+	spin_lock(&OCFS2_I(dest)->ip_lock);
> >>>+	if (newlen > i_size_read(dest)) {
> >>>+		i_size_write(dest, newlen);
> >>>+		di->i_size = newlen;
> >>di->i_size = cpu_to_le64(newlen);

Good catch!

> >>>+	}
> >>>+	spin_unlock(&OCFS2_I(dest)->ip_lock);
> >>>+
> >>Add ocfs2_update_inode_fsync_trans() here? Looks this function was
> >>introduced by you to improve efficiency.
> >>Just want to awake your memory about this, though I don't know about the
> >>details why it should be.

D'oh!  Yes, I did miss that.

The function updates the destination inode's information.  Specifically,
it updates i_size if we reflinked blocks into the file past EOF.
Looking at it some more, I also need to update i_blocks or the stat(2) info
will be wrong, and I also need to convert inline data to extents prior
to reflinking.

--D

> >>
> >>Eric
> Thanks,
> Eric
