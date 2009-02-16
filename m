From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Feb 2009 09:36:53 +0800
Subject: [Ocfs2-devel] [PATCH 0/40] ocfs2: Detach ocfs2 metadata I/O
	from struct inode
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <4998C335.30206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	I deem that 1-3 is the same as the patch you sent to me several days 
ago. right? As I have reviewed them before, so didn't touch them this time.
	For 4~7, read them and like them. Just small comments ;)
	For 8~40, since they are just replacing parameters. Just skim them.

anyway, They are cool and relieve me from my current work. Thank you 
very much.
For all the patches, Acked-by: Tao Ma <tao.ma@oracle.com>

Regards,
Tao

Joel Becker wrote:
> The following series of patches attempts to detach metadata I/O from
> struct inode.   They are currently tied together pretty tightly.
> Metadata reads happen via the ocfs2_read_blocks() functions, writes via
> both jbd2 and ocfs2_write_blocks().
> 
> - Each inode has a cache of associated metadata blocks stored on its
>   ip_metadata_cache member.  The ocfs2_read/write_blocks() functions
>   take a struct inode to access this member.
> 
> - The journal mostly doesn't care about inodes.  It does, however, need
>   to set the transaction id on the inode so that dlmglue knows when an
>   inode needs to checkpoint.
> 
> - All the metadata I/O paths use ip_io_mutex to synchronize their
>   actions against each other.
> 
> The problem is that if someone wants to use our metadata I/O facilities,
> they have to have a struct inode.  But not everything in ocfs2 is an
> inode (even if it seems that way sometimes).  So we want to disconnect
> them.
> 
> It turns out that most of what goes on is about ocfs2_caching_info.  So
> if we move the last few relevant bits to ocfs2_caching_info, we can then
> embed ocfs2_caching_info into another structure just as easily as we do
> inside struct inode.  That's the theory, anyway.
> 
> The first three patches move the cache code to ocfs2_caching_info
> entirely.  The functions affecting the metadata cache, like
> ocfs2_set_buffer_uptodate(), etc, take a struct ocfs2_caching_info
> instead of a struct inode.  That sort of thing.  It's nice and easy.
> 
> The next three patches move the journal transaction ids to struct
> ocfs2_caching_info.  When they are done, the ocfs2_journal_access*()
> functions take a stuct ocfs2_caching_info, and the dlmglue checks the
> ocfs2_caching_info regarding checkpoints.  So it only takes us six
> patches to isolate ocfs2_caching_info in the metadata I/O API.
> 
> The remaining 34 patches slowly but surely move alloc.c to the new API.
> Our btree code is heavily invested in the idea that all btrees are
> rooted, somehow, at an inode.  Since we want to root a btree at a
> non-inode, we need to fix that.  The good news, of course, is that the
> ocfs2_extent_tree abstraction is already there to rescue us.  We attach
> the ocfs2_caching_info to a particular ocfs2_extent_tree, and we can
> then send that ocfs2_extent_tree down through the btree code.  At the
> end of this series, the generic btree code doesn't reference struct
> inode at all.
> 
> There are a lot of patches because this entire series is supposed to be
> isomorphic.  No behavior is to change, just the flexibility of our API.
> Thus, each patch tries to be readily understandable.  Thank you for your
> patience!
> 
> [View]
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=cacheme
> [Pull]
> git://oss.oracle.com/git/jlbec/linux-2.6.git cacheme
> 
> Joel Becker (40):
>       ocfs2: Make the ocfs2_caching_info structure self-contained.
>       ocfs2: Change metadata caching locks to an operations structure.
>       ocfs2: Take the inode out of the metadata read/write paths.
>       ocfs2: move ip_last_trans to struct ocfs2_caching_info
>       ocfs2: move ip_created_trans to struct ocfs2_caching_info
>       ocfs2: Pass struct ocfs2_caching_info to the journal functions.
>       ocfs2: Store the ocfs2_caching_info on ocfs2_extent_tree.
>       ocfs2: Pass ocfs2_caching_info to ocfs2_read_extent_block().
>       ocfs2: ocfs2_find_path() only needs the caching info
>       ocfs2: ocfs2_create_new_meta_bhs() doesn't need struct inode.
>       ocfs2: Pass ocfs2_extent_tree to ocfs2_unlink_path()
>       ocfs2: ocfs2_complete_edge_insert() doesn't need struct inode at all.
>       ocfs2: Get inode out of ocfs2_rotate_subtree_root_right().
>       ocfs2: Pass ocfs2_extent_tree to ocfs2_get_subtree_root()
>       ocfs2: Drop struct inode from ocfs2_extent_tree_operations.
>       ocfs2: ocfs2_rotate_tree_right() doesn't need struct inode.
>       ocfs2: ocfs2_update_edge_lengths() doesn't need struct inode.
>       ocfs2: ocfs2_rotate_subtree_left() doesn't need struct inode.
>       ocfs2: __ocfs2_rotate_tree_left() doesn't need struct inode.
>       ocfs2: ocfs2_rotate_tree_left() no longer needs struct inode.
>       ocfs2: ocfs2_merge_rec_left/right() no longer need struct inode.
>       ocfs2: ocfs2_try_to_merge_extent() doesn't need struct inode.
>       ocfs2: ocfs2_grow_branch() no longer needs struct inode.
>       ocfs2: ocfs2_append_rec_to_path() loses struct inode.
>       ocfs2: ocfs2_truncate_rec() doesn't need struct inode.
>       ocfs2: Make truncating the extent map an extent_tree_operation.
>       ocfs2: ocfs2_insert_at_leaf() doesn't need struct inode.
>       ocfs2: Give ocfs2_split_record() an extent_tree instead of an inode.
>       ocfs2: ocfs2_do_insert_extent() and ocfs2_insert_path() no longer need an 
>       ocfs2: ocfs2_extent_contig() only requires the superblock.
>       ocfs2: Swap inode for extent_tree in ocfs2_figure_merge_contig_type().
>       ocfs2: Remove inode from ocfs2_figure_extent_contig().
>       ocfs2: ocfs2_figure_insert_type() no longer needs struct inode.
>       ocfs2: Make extent map insertion an extent_tree_operation.
>       ocfs2: ocfs2_insert_extent() no longer needs struct inode.
>       ocfs2: ocfs2_add_clusters_in_btree() no longer needs struct inode.
>       ocfs2: ocfs2_remove_extent() no longer needs struct inode.
>       ocfs2: ocfs2_split_and_insert() no longer needs struct inode.
>       ocfs2: __ocfs2_mark_extent_written() doesn't need struct inode.
>       ocfs2: Pass ocfs2_caching_info into ocfs_init_*_extent_tree().
> 
>  alloc.c          |  896 ++++++++++++++++++++++++++++---------------------------
>  alloc.h          |   33 --
>  aops.c           |   10 
>  buffer_head_io.c |   47 +-
>  buffer_head_io.h |    8 
>  dir.c            |   38 +-
>  dlmglue.c        |    4 
>  extent_map.c     |   14 
>  file.c           |   21 -
>  inode.c          |   80 ++++
>  inode.h          |   20 -
>  journal.c        |   53 +--
>  journal.h        |   70 ++--
>  localalloc.c     |   12 
>  namei.c          |   37 +-
>  ocfs2.h          |   38 ++
>  quota_global.c   |    5 
>  quota_local.c    |   16 
>  resize.c         |   16 
>  slot_map.c       |   10 
>  suballoc.c       |   35 +-
>  super.c          |    5 
>  uptodate.c       |  265 +++++++++-------
>  uptodate.h       |   51 ++-
>  xattr.c          |   81 ++--
>  25 files changed, 1056 insertions(+), 809 deletions(-)
> 
> 
