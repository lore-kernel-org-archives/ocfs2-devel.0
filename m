From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 21 Mar 2016 21:53:37 -0700
Subject: [Ocfs2-devel] HEADUP: generic FICLONE ioctl and
 ->clone_file_range method
In-Reply-To: <56F11E44020000F90002EAF5@prv-mh.provo.novell.com>
References: <20160321154259.GA14392@lst.de>
	<56F11E44020000F90002EAF5@prv-mh.provo.novell.com>
Message-ID: <20160322045336.GB5812@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 21, 2016 at 08:28:20PM -0600, Gang He wrote:
> Hi Christoph,
> 
> The feature sounds good. OCFS2 has file clone feature (so far, we only
> support clone the whole file), what efforts will be involved if we add this
> feature support?

An oversimplified answer to that question is "wire up whatever
reflinking you currently have to the VFS f_ops pointers." :)

I can do better than that:

From what I can tell, ocfs2 implements reflinking by creating a
reference count tree for the inodes that are supposed to share blocks;
the reference counts are incremented during a reflink operation and
decremented during CoW/punch/truncate/rm.  Essentially, a group of
files can share blocks by sharing the same refcount tree, but blocks
cannot be shared between two files that point to different refcount
trees.

If I'm not mistaken, this works just fine for ocfs2 to clone entire
files, but has the distinct disadvantage that (at the moment anyway)
one cannot share blocks between refcount tree groups, which is a
barrier to deduplication.

Looking at the ocfs2 source code, I see that __ocfs2_reflink() calls
ocfs2_attach_refcount_tree() to set up the i_refcount_loc field and
calls ocfs2_create_reflink_node() to copy the extents from one file to
another.  This is a good place to start.  To support the full
expressiveness of clone_file_range you'll have to modify
_create_reflink_node to be able to clone only a subset of a file's
extents.  Note that the VFS clone_file_range operates on existing
files only and has no way to request reflinking xattrs, so you needn't
worry about cloning xattr blocks or propagating inode fields.

One difficulty here is how ocfs2 will deal with a request to reflink
blocks in two files that belong to different refcount trees.  The
simplest solution is not to allow it, though that obviously makes the
feature much less useful.  One option is to modify the reflink code to
merge refcount trees, though a larger refcount tree comes at a cost
of higher contention at CoW time and lower performance.

For extra credit, note that there's also a new VFS f_ops pointer to
dedupe.  Like clone_file_range it takes enough arguments that one can
share any part of two files, but comes with the extra requirement that
the sharing can only happen if the two ranges are identical.  That
extra bit must be implemented in the FS at the moment.

On the flip side, ocfs2 already implements copy-on-write so the hookup
should be less difficult than, say, the huge retrofit going on in XFS
right now. :)

I'll try to help out with hooking ocfs2 up to reflink/dedupe in any
way I can, but Junxiao seems to be the main ocfs2 contact at Oracle
these days (and I'm a little busy with the aforementioned XFS retrofit)

ALSO: The quota accounting underflow bug that I reported in January
still hasn't been fixed:
https://oss.oracle.com/pipermail/ocfs2-devel/2016-January/011722.html

--D

PS: I hacked up xfstests to call reflink(1) instead of 'cp --reflink'.
Aside from the quota bug, the tests that only care about being able to
reflink entire files seemed to pass.

> 
> 
> 
> Thanks
> Gang
> 
> 
> >>> 
> > We made the btrfs clone support generic to add NFS support, and support
> > the future XFS reflink support.  It looks like ocfs2 could support
> > these as well, so it would be great to get the clone_file_range method
> > wired up.  xfstests has over 100 testcases for it, so it should be
> > easy to verify.
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com 
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
