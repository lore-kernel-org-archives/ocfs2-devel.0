From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 10 Feb 2009 09:33:28 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V2).
In-Reply-To: <20090130011115.GF12502@mail.oracle.com>
References: <200812120900.mBC90imR012722@localhost.localdomain>
	<20090130011115.GF12502@mail.oracle.com>
Message-ID: <4990D968.1050703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> On Fri, Dec 12, 2008 at 05:00:44PM +0800, wengang wang wrote:
>> Changes from V1:
>> 1) separate lines into sub-functions.
>> 2) use mlog(0, .. instead of mlog(ML_NOTICE, .. for stale error.
> 
> Wengang,
> 	Sorry it took me so long to review this.  You're going to be
> slightly amused - we're going to be using some of your original ideas,
> though with modification.

very good :)

> 
>> Index: fs/ocfs2/export.c
>> ===================================================================
>> --- fs/ocfs2/export.c	(revision 38)
>> +++ fs/ocfs2/export.c	(working copy)
>> @@ -38,6 +38,8 @@
>>  #include "inode.h"
>>  
>>  #include "buffer_head_io.h"
>> +#include "sysfile.h"
>> +#include "suballoc.h"
>>  
>>  struct ocfs2_inode_handle
>>  {
>> @@ -48,24 +50,92 @@ struct ocfs2_inode_handle
>>  static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
>>  {
>>  	struct ocfs2_inode_handle *handle = vobjp;
>> -	struct inode *inode;
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>>  	struct dentry *result;
>> -
>> +	struct inode *inode, *inode_alloc_inode;
>> +	struct buffer_head *alloc_bh = NULL;
>> +	u64 blkno = handle->ih_blkno;
>> +	unsigned short suballoc_bit, suballoc_slot;
>> +	int status, set;
>> +	
>>  	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
>>  
>> -	if (handle->ih_blkno == 0) {
>> -		mlog_errno(-ESTALE);
>> -		return ERR_PTR(-ESTALE);
>> +	if (blkno == 0) {
>> +		mlog(0, "nfs wants inode with blkno: 0\n");
>> +		result = ERR_PTR(-ESTALE);
>> +		goto bail;
>> +	}
>> +
>> +	inode = ocfs2_ilookup(sb, ino_from_blkno(sb, blkno));
> 
> 	You need to call ocfs2_ilookup() with the real blkno, not the
> ino_from_blkno() value.  You'll find that ocfs2_ilookup() is doing
> ino_from_blkno for args.fi_ino.
> 	Otherwise, your changes to ocfs2_get_dentry() fit your patch
> nicely.
> 
>> @@ -933,6 +927,40 @@ void ocfs2_delete_inode(struct inode *in
>>  		goto bail;
>>  	}
>>  
>> +	/* lock the suballoc inode first before locking against inode
>> +	 * its self 
>> +	 * */
>> +
>> +	/* here we don't have cluster locked against inode, so we may
>> +	 * reads out non-up2date contents.
>> +	 * but because suballoc_slot never changes, reading out non-up2date
>> +	 * contents is no problem.
>> +	 * */
>> +	status = ocfs2_get_suballoc_slot_bit(OCFS2_SB(inode->i_sb),
>> +					     OCFS2_I(inode)->ip_blkno,
>> +					     &suballoc_slot, NULL, 0);
>> +	if (status < 0) {
>> +		mlog_errno(status);
>> +		goto bail_sigmask;
>> +	}
>> +
>> +	inode_alloc_inode =
>> +		ocfs2_get_system_file_inode(OCFS2_SB(inode->i_sb),
>> +					    INODE_ALLOC_SYSTEM_INODE,
>> +					    suballoc_slot);
>> +	if (!inode_alloc_inode) {
>> +		status = -EEXIST;
>> +		mlog_errno(status);
>> +		goto bail_sigmask;
>> +	}
>> +	
>> +	mutex_lock(&inode_alloc_inode->i_mutex);
>> +	status = ocfs2_inode_lock(inode_alloc_inode, &suballoc_bh, 1);
>> +	if (status < 0) {
>> +		mlog_errno(status);
>> +		goto bail_mutex;
>> +	}
>> +
> 
> 	Here is where the current patch runs into problems.  You moved
> the locking of the alloc inode up to the top of ocfs2_delete_inode() in
> order to avoid the ABBA deadlock with ocfs2_get_dentry().  Unfortunately,
> this is a performance disaster.
> 	When a node closes a file that needs deletion, it gets the inode
> lock and checks to see if it can wipe.  Only the last closer can wipe -
> the others do nothing.  But with this change, even nodes that will skip
> wiping have to lock the alloc inode.  Thus, the alloc inode lock is
> pinged around the cluster for every delete.  This will really hurt.
> 	What we'd like to do is keep the lock of the alloc_inode inside
> ocfs2_remove_inode(), and yet avoid the ABBA deadlock.  Mark proposed the
> answer, which is a little bit like your original solution.
> 	If you recall, you originally wanted to add a dealloc lock to
> every inode.  This isn't workable, because it's extra work for the
> "normal" case of deletion, and it adds space usage for every inode.  In
> addition, your old code forced a checkpoint for every deletion,
> regardless of whether it was needed.
> 	Now, the change to ocfs2_get_dentry() to get the suballoc lock
> provides the appropriate journal flushing.  It only happens when
> ocfs2_get_dentry() is caled, and doesn't hurt the "normal" case.  But
> what about the deadlock?
> 	We'd like you to add a lock on the ocfs2_super, the
> "nfs_sync_lock".  This will be a new lock type, and there is only one
> per filesystem.  During ocfs2_delete_inode(), we hold this lock as a PR.
> This means all nodes can do ocfs2_delete_inode() concurrently.  In fact,
> due to lock caching, all nodes will acquire the lock once and never
> release it unless ocfs2_get_dentry() is called.  Thus, the normal case
> has no performance impact.
> 	In ocfs2_get_dentry(), if ocfs2_ilookup() fails, we take the
> nfs_sync_lock in EX mode before we take the alloc_inode lock.  Because
> the nfs_sync_lock blocks out ocfs2_delete_inode(), there is no ordering
> concern with the alloc_inode and inode locks.  There can be no ABBA
> deadlock.  Becasue we only take the lock when ocfs2_ilookup() fails, we
> only will slow down when the inode is not in cache.  That only happens
> when an NFS server reboots or a client is silent for a long time.  Thus,
> the normal NFS case is not impacted by this change either.
> 
I see. thanks for your patience and detail!

one thing is that, the "nfs_sync_lock" will be one in count or more than 
one?
I think having lots of this kind of lock(one for each meta block) will 
bring us least performance impact for deletions.
well so much locks eat memory. for balancing, how about setting up 16(or 
32) such locks? different inode goes to different lock according to its 
block number. and 16(or 32) such locks won't take much memory. --just 
like the idea in my original patch.


>> Index: fs/ocfs2/dlmglue.c
>> ===================================================================
>> --- fs/ocfs2/dlmglue.c	(revision 38)
>> +++ fs/ocfs2/dlmglue.c	(working copy)
>> @@ -1940,19 +1940,24 @@ static int ocfs2_inode_lock_update(struc
>>  			status = -EIO;
>>  			goto bail_refresh;
>>  		}
>> -		mlog_bug_on_msg(inode->i_generation !=
>> -				le32_to_cpu(fe->i_generation),
>> -				"Invalid dinode %llu disk generation: %u "
>> -				"inode->i_generation: %u\n",
>> -				(unsigned long long)oi->ip_blkno,
>> -				le32_to_cpu(fe->i_generation),
>> -				inode->i_generation);
>> -		mlog_bug_on_msg(le64_to_cpu(fe->i_dtime) ||
>> -				!(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL)),
>> -				"Stale dinode %llu dtime: %llu flags: 0x%x\n",
>> -				(unsigned long long)oi->ip_blkno,
>> -				(unsigned long long)le64_to_cpu(fe->i_dtime),
>> -				le32_to_cpu(fe->i_flags));
>> +		if (inode->i_generation != le32_to_cpu(fe->i_generation)) {
>> +			mlog(0, "Stale inode %llu disk generation: %u "
>> +			     "inode generation: %u\n",
>> +			     (unsigned long long)oi->ip_blkno,
>> +			     le32_to_cpu(fe->i_generation),
>> +			     inode->i_generation);
>> +			status = -ESTALE;
>> +			goto bail_refresh;
>> +		}
>> +		if (le64_to_cpu(fe->i_dtime) ||
>> +		    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
>> +			mlog(0, "Stale inode %llu dtime: %llu flags: 0x%x\n",
>> +			     (unsigned long long)oi->ip_blkno,
>> +			     (unsigned long long)le64_to_cpu(fe->i_dtime),
>> +			     le32_to_cpu(fe->i_flags));
>> +			status = -ESTALE;
>> +			goto bail_refresh;
>> +		}
> 
> 	I don't think we need this change anymore.  Because you called
> ilookup(), we know that the inode is not in the inode cache.  We'll
> create it new when you call iget.

for now I'm not very sure about this. I will do as you suggested until I 
find out it's not true :P

thanks
wengang.
