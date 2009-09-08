From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 8 Sep 2009 13:23:42 -0700
Subject: [Ocfs2-devel] What's in ocfs2.git
Message-ID: <20090908202341.GB20761@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>

Hey everyone,
	ocfs2.git currently has 85 patches queued for the 2.6.32 merge
window, and that will probably grow to over 100.  So I wanted to fire
off a heads up for anyone who wants to re-review what is in there.
	The big feature item is the reflinkat(2) system call.
reflink(2) was discussed at the filesystem workshop this spring, and the
patch went through various stages of review in May before a final patch
was settled on.  This patch is included here now that ocfs2 provides
support for reflinks.
	All of these patches have been reviewed on the appropriate
mailing lists, some more than once.  So I've decided not to carpet-bomb
with patches.  The git locations are included for those wishing to view
the patches.
	There are two major hunks of the current queued patches.  The
first hunk separates the ocfs2_caching_info structure from ocfs2's
inodes.  We use the caching info to keep track of a metadata buffer's
up2date status in a cluster aware fashion.  Up until now, each buffer
was owned by a single inode, so the cache was tied to inodes.  But now
we need a caching info tied to a non-inode structure that is shared by
many inodes (the refcount tree, see below for more on that).  So we make
it a first-class structure and rework our up2date and journal code to
rely on it.
	Then there is the patch for the reflinkat(2) system call.
	The second major hunk is the implementation of "refcount trees",
the data structure ocfs2 uses to handle reflinks.  Refcount trees allow
for ocfs2 inodes to share data extents in a copy-on-write fashion.
We've been testing the heck out of them, and they're ready to go.

To look at what's currently prepped for the merge window:
[View]
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=shortlog;h=merge-window
[Pull]
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git merge-window

	The remaining work I have is a cleanup of ocfs2's extended
attribute setter code.  It unifies the code paths for the various ways
ocfs2 stores xattrs.  The current patches have been reviewed on the
mailing list, but I'm still chasing at least one bug.  As such, they're
not in the merge-window branch but are still living on their own xa_loc
branch.  If we get the bugs nailed down before the merge window is over,
we'll be going upstream this cycle.

To look at the extended attribute cleanups:
[View]
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=shortlog;h=xa_loc
[Pull]
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git xa_loc

Joel


[Merge window shortlog]

Coly Li (1):
      dlmglue.c: add missed mlog lines

Joel Becker (41):
      ocfs2: Make the ocfs2_caching_info structure self-contained.
      ocfs2: Change metadata caching locks to an operations structure.
      ocfs2: Take the inode out of the metadata read/write paths.
      ocfs2: move ip_last_trans to struct ocfs2_caching_info
      ocfs2: move ip_created_trans to struct ocfs2_caching_info
      ocfs2: Pass struct ocfs2_caching_info to the journal functions.
      ocfs2: Store the ocfs2_caching_info on ocfs2_extent_tree.
      ocfs2: Pass ocfs2_caching_info to ocfs2_read_extent_block().
      ocfs2: ocfs2_find_path() only needs the caching info
      ocfs2: ocfs2_create_new_meta_bhs() doesn't need struct inode.
      ocfs2: Pass ocfs2_extent_tree to ocfs2_unlink_path()
      ocfs2: ocfs2_complete_edge_insert() doesn't need struct inode at all.
      ocfs2: Get inode out of ocfs2_rotate_subtree_root_right().
      ocfs2: Pass ocfs2_extent_tree to ocfs2_get_subtree_root()
      ocfs2: Drop struct inode from ocfs2_extent_tree_operations.
      ocfs2: ocfs2_rotate_tree_right() doesn't need struct inode.
      ocfs2: ocfs2_update_edge_lengths() doesn't need struct inode.
      ocfs2: ocfs2_rotate_subtree_left() doesn't need struct inode.
      ocfs2: __ocfs2_rotate_tree_left() doesn't need struct inode.
      ocfs2: ocfs2_rotate_tree_left() no longer needs struct inode.
      ocfs2: ocfs2_merge_rec_left/right() no longer need struct inode.
      ocfs2: ocfs2_try_to_merge_extent() doesn't need struct inode.
      ocfs2: ocfs2_grow_branch() and ocfs2_append_rec_to_path() lose struct inode.
      ocfs2: ocfs2_truncate_rec() doesn't need struct inode.
      ocfs2: Make truncating the extent map an extent_tree_operation.
      ocfs2: ocfs2_insert_at_leaf() doesn't need struct inode.
      ocfs2: Give ocfs2_split_record() an extent_tree instead of an inode.
      ocfs2: ocfs2_do_insert_extent() and ocfs2_insert_path() no longer need an inode.
      ocfs2: ocfs2_extent_contig() only requires the superblock.
      ocfs2: Swap inode for extent_tree in ocfs2_figure_merge_contig_type().
      ocfs2: Remove inode from ocfs2_figure_extent_contig().
      ocfs2: ocfs2_figure_insert_type() no longer needs struct inode.
      ocfs2: Make extent map insertion an extent_tree_operation.
      ocfs2: ocfs2_insert_extent() no longer needs struct inode.
      ocfs2: ocfs2_add_clusters_in_btree() no longer needs struct inode.
      ocfs2: ocfs2_remove_extent() no longer needs struct inode.
      ocfs2: ocfs2_split_and_insert() no longer needs struct inode.
      ocfs2: Teach ocfs2_replace_extent_rec() to use an extent_tree.
      ocfs2: __ocfs2_mark_extent_written() doesn't need struct inode.
      ocfs2: Pass ocfs2_caching_info into ocfs_init_*_extent_tree().
      fs: Add the reflink() operation and reflinkat(2) system call.

Sunil Mushran (1):
      ocfs2: __ocfs2_abort() should not enable panic for local mounts

Tao Ma (41):
      ocfs2: Define refcount tree structure.
      ocfs2: Add metaecc for ocfs2_refcount_block.
      ocfs2: Add ocfs2_read_refcount_block.
      ocfs2: Abstract caching info checkpoint.
      ocfs2: Add new refcount tree lock resource in dlmglue.
      ocfs2: Add caching info for refcount tree.
      ocfs2: Add refcount tree lock mechanism.
      ocfs2: Basic tree root operation.
      ocfs2: Wrap ocfs2_extent_contig in ocfs2_extent_tree.
      ocfs2: Abstract extent split process.
      ocfs2: Add refcount b-tree as a new extent tree.
      ocfs2: move tree path functions to alloc.h.
      ocfs2: Add support for incrementing refcount in the tree.
      ocfs2: Add support of decrementing refcount for delete.
      ocfs2: Add functions for extents refcounted.
      ocfs2: Decrement refcount when truncating refcounted extents.
      ocfs2: Add CoW support.
      ocfs2: CoW refcount tree improvement.
      ocfs2: Integrate CoW in file write.
      ocfs2: CoW a reflinked cluster when it is truncated.
      ocfs2: Add normal functions for reflink a normal file's extents.
      ocfs2: handle file attributes issue for reflink.
      ocfs2: Return extent flags for xattr value tree.
      ocfs2: Abstract duplicate clusters process in CoW.
      ocfs2: Add CoW support for xattr.
      ocfs2: Remove inode from ocfs2_xattr_bucket_get_name_value.
      ocfs2: Abstract the creation of xattr block.
      ocfs2: Abstract ocfs2 xattr tree extend rec iteration process.
      ocfs2: Attach xattr clusters to refcount tree.
      ocfs2: Call refcount tree remove process properly.
      ocfs2: Create an xattr indexed block if needed.
      ocfs2: Add reflink support for xattr.
      ocfs2: Modify removing xattr process for refcount.
      ocfs2: Don't merge in 1st refcount ops of reflink.
      ocfs2: Make transaction extend more efficient.
      ocfs2: Use proper parameter for some inode operation.
      ocfs2: Create reflinked file in orphan dir.
      ocfs2: Add preserve to reflink.
      ocfs2: Implement ocfs2_reflink.
      ocfs2: Enable refcount tree support.
      ocfs2: Add ioctl for reflink.

Wengang Wang (1):
      ocfs2: add spinlock protection when dealing with lockres->purge.


[Extended attribute cleanup shortlog]

Joel Becker (16):
      ocfs2: Introduce ocfs2_xa_loc
      ocfs2: Remove xattrs via ocfs2_xa_loc
      ocfs2: Prefix the member fields of struct ocfs2_xattr_info.
      ocfs2: Add a name_len field to ocfs2_xattr_info.
      ocfs2: Wrap calculation of name+value pair size.
      ocfs2: Set the xattr name+value pair in one place
      ocfs2: Handle value tree roots in ocfs2_xa_set_inline_value()
      ocfs2: Provide ocfs2_xa_fill_value_buf() for external value processing
      ocfs2: Teach ocfs2_xa_loc how to do its own journal work
      ocfs2: Allocation in ocfs2_xa_prepare_entry(), values in ocfs2_xa_store_value()
      ocfs2: Gell into ocfs2_xa_set()
      ocfs2: Let ocfs2_xa_prepare_entry() do space checks.
      ocfs2: Set xattr block entries with ocfs2_xa_set()
      ocfs2: Set inline xattr entries with ocfs2_xa_set()
      ocfs2: Handle errors while setting external xattr values.
      ocfs2: Never call ocfs2_xa_fill_value_buf() for inline values.


-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
