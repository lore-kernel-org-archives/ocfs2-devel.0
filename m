From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Mar  9 19:14:24 2004
Subject: [Ocfs2-devel] Bug in error handling
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A617804A@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Ok, could you update from latest SVN and let me know if that fixed it?
> I wasn't getting the NULL pointer error in ocfs_bh_sem_lookup 
> like you, but
> I was definitely seeing one in ocfs_inode_hash_prune_all where we were
> assuming that an inode existed on the inum when in fact it 
> didn't :) The fix
> of course, we to check for it's existence before acting on it!
> 
> Alternatively, if you don't want to update from SVN, you can 
> apply this
> patch.

I will try to give that a try.  Though I reformatted my partition so I
may not be able to reproduce.

Just a note.  I am doing this on a 2.6.3 kernel.

Where I was having it crash was on:

ocfs_bh_sem * ocfs_bh_sem_lookup(struct buffer_head *bh)
{
        int depth, bucket;
        struct list_head *head, *iter = NULL;
        ocfs_bh_sem *sem = NULL, *newsem = NULL;

        bucket = ocfs_bh_sem_hash_fn(bh);  <<<<<<<<<----



#define ocfs_bh_sem_hash_fn(_b)   \
        (_hashfn((unsigned int)BH_GET_DEVICE((_b)), (_b)->b_blocknr) &
ocfs_bh_hash_shift)


This macro is where the NULL reference occurs:

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
#define BH_GET_DEVICE(bh) ((bh->b_bdev)->bd_dev)  <<<<-------------
#else
#define BH_GET_DEVICE(bh) (bh->b_dev)
#endif
