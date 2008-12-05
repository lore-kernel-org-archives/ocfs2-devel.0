From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 05 Dec 2008 10:35:03 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V1).
In-Reply-To: <20081204200534.GA19340@mail.oracle.com>
References: <200812041058.mB4Aw8dj032344@localhost.localdomain>
	<20081204200534.GA19340@mail.oracle.com>
Message-ID: <49389357.9000504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Joel Becker wrote:
> [snip]
>> +#define mlog_warnno(st) do {						\
>> +	int _st = (st);							\
>> +	mlog(ML_NOTICE, "status = %lld\n", (long long)_st);		\
>> +} while (0)
>> +
>>     
>
> 	I don't think we want mlog_warnno().  Really, it should just be
> an mlog(0, ...) if anything.  We don't want to print for every stale
> inode.
>
>   
yes, I'm also considering about that. STALE is normal to nfs.
will change it.
>> @@ -48,23 +50,125 @@ struct ocfs2_inode_handle
>>  static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
>>  {
>>  	struct ocfs2_inode_handle *handle = vobjp;
>> -	struct inode *inode;
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>>  	struct dentry *result;
>> -
>> +	struct inode *inode, *inode_alloc_inode;
>> +	struct buffer_head *inode_bh = NULL, *alloc_bh = NULL;
>> +	struct buffer_head *group_bh = NULL;
>> +	struct ocfs2_dinode *inode_fe, *alloc_fe;
>> +	struct ocfs2_group_desc *group;
>> +	u64 blkno = handle->ih_blkno, bg_blkno;
>> +	unsigned short suballoc_bit, suballoc_slot;
>> +	int status;
>> +	
>>  	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
>>  
>> -	if (handle->ih_blkno == 0) {
>> -		mlog_errno(-ESTALE);
>> +	if (blkno == 0) {
>> +		mlog_warnno(-ESTALE);
>>  		return ERR_PTR(-ESTALE);
>>  	}
>>  
>> +	inode = ocfs2_ilookup(sb, ino_from_blkno(sb, blkno));
>> +	/* found in-memory inode, goes to check generation */
>> +	if (inode)
>> +		goto check_gen;
>> +
>> +	/* dirty reads(hit disk) the inode to get suballoc_slot and
>> +	 * suballoc_bit 
>> +	 * */
>> +	status = ocfs2_read_block(osb, blkno, &inode_bh, 0, NULL);
>> +	if (status < 0) {
>> +		mlog_errno(status);
>> +		return ERR_PTR(status);
>> +	}
>> +
>> +	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
>> +	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
>> +		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
>> +		     (unsigned long long)blkno, 7, inode_fe->i_signature);
>> +		status = -EINVAL;
>> +		goto rls_bh;
>> +	}
>> +
>> +	suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
>> +	suballoc_bit = le16_to_cpu(inode_fe->i_suballoc_bit);
>> +
>> +	/* checks suballoc_bit in bitmap is still SET */
>> +	inode_alloc_inode =
>> +		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
>> +					    suballoc_slot);
>> +	if (!inode_alloc_inode) {
>> +		status = -EEXIST;
>> +		goto rls_bh;
>> +	}
>> +
>> +	mutex_lock(&inode_alloc_inode->i_mutex);
>> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
>> +	if (status < 0) 
>> +		goto unlock_mutex;
>> +
>> +	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
>> +	BUG_ON((suballoc_bit + 1) >
>> +			ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
>>     
>
> 	I'd rather leave ocfs2_bits_per_group() static to suballoc.c.
>
>   
I will try to do that better...
>> +
>> +	bg_blkno = ocfs2_which_suballoc_group(blkno, suballoc_bit);
>> +	status = ocfs2_read_block(osb, bg_blkno, &group_bh, OCFS2_BH_CACHED, 
>> +				  inode_alloc_inode);
>> +	if (status < 0) 
>> +		goto inode_unlock;
>> +
>> +	group = (struct ocfs2_group_desc *) group_bh->b_data;
>> +	status = ocfs2_check_group_descriptor(sb, alloc_fe, group);
>> +	if (status < 0) 
>> +		goto rls_group_bh;
>> +
>> +	/* if the bit is clear, it's a stale inode */
>> +	if (!ocfs2_test_bit(suballoc_bit, (unsigned long *)group->bg_bitmap)) {
>> +		status = -ESTALE;
>> +		goto rls_group_bh;
>> +	}
>> +
>>     
>
> 	In fact, why not make this entire logic a new function in
> suballoc.c called ocfs2_test_suballoc_bit().  You pass it a locked
> suballocator inode, the blkno, and the suballoc_bit.  It returns the
> status of the bit.
>
>   
hm, yes, good idea.
>>  	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0, 0);
>>  
>> -	if (IS_ERR(inode))
>> +	/* if suballoc slot changed since last ocfs2_read_block(), we may have
>> +	 * the lock on a wrong suballoc inode. but if so, since the inode was 
>> +	 * changed, the inode we want must be stale then. 
>> +	 * while, we don't check that here(since ocfs2_iget() doesn't bring
>> +	 * ocfs2_dinode to us, if we do check, we needs other code). instead,
>> +	 * we check on generation later. that is because if the suballoc slot
>> +	 * changed, the generation must changed(since they are in the same disk
>> +	 * sector). 
>> +	 * */ 
>>     
>
> 	inode's don't change suballoc inodes.  In fact, your call to
> ocfs2_check_group_descriptor() will crash the filesystem if it
> determines that the group descriptor and the suballoc inode don't match.
> But that can't happen in a correctly functioning filesystem.
>
>   
Ok, I see.  I will remove the comments.
>> +check_gen:
>>  	if (handle->ih_generation != inode->i_generation) {
>>  		iput(inode);
>> +		mlog_warnno(-ESTALE);
>>  		return ERR_PTR(-ESTALE);
>>  	}
>>     
>
> 	This is what I mean.  We don't want to log every stale inode.
> Stale inodes are a normal part of NFS operation.
>   
yes, will change that.
>   
>   
>> Index: fs/ocfs2/inode.c
>> ===================================================================
>> --- fs/ocfs2/inode.c	(revision 38)
>> +++ fs/ocfs2/inode.c	(working copy)
>> @@ -111,6 +111,17 @@ void ocfs2_get_inode_flags(struct ocfs2_
>>  		oi->ip_attr |= OCFS2_DIRSYNC_FL;
>>  }
>>  
>> +struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
>> +{
>> +	struct ocfs2_find_inode_args args;
>> +
>> +	args.fi_blkno = blkno;
>> +	args.fi_flags = 0;
>> +	args.fi_ino = ino_from_blkno(sb, blkno);
>> +	args.fi_sysfile_type = 0;
>> +
>> +	return ilookup5(sb, blkno, ocfs2_find_actor, &args);
>> +}
>>     
>
> 	This is good.
>
>   
>>  struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>>  			 int sysfile_type)
>>  {
>> @@ -571,6 +582,9 @@ out:
>>  	return status;
>>  }
>>  
>> +/* callers must have cluster lock inode_alloc_inode taken before calling
>> + * ocfs2_remove_inode
>> + * */
>>  static int ocfs2_remove_inode(struct inode *inode,
>>  			      struct buffer_head *di_bh,
>>  			      struct inode *orphan_dir_inode,
>> @@ -592,11 +606,12 @@ static int ocfs2_remove_inode(struct ino
>>  		goto bail;
>>  	}
>>  
>> -	mutex_lock(&inode_alloc_inode->i_mutex);
>> -	status = ocfs2_inode_lock(inode_alloc_inode, &inode_alloc_bh, 1);
>> +	status = ocfs2_read_block(OCFS2_SB(inode_alloc_inode->i_sb),
>> +				  OCFS2_I(inode_alloc_inode)->ip_blkno,
>> +				  &inode_alloc_bh,
>> +				  OCFS2_BH_CACHED,
>> +				  inode_alloc_inode);
>>     
>
> 	If you require callers to lock the alloc inode, have them pass
> in the alloc inode and bh to the function.  Then you don't have to call
> get_system_file_inode or read_block.
>
>   
Yes, I had thought so.
while, the grandparent knows the alloc inode and direct parent doesn't use
it at. so gave up.

I will consider it further..
>> Index: fs/ocfs2/dlmglue.c
>> ===================================================================
>> --- fs/ocfs2/dlmglue.c	(revision 38)
>> +++ fs/ocfs2/dlmglue.c	(working copy)
>> @@ -1940,19 +1940,25 @@ static int ocfs2_inode_lock_update(struc
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
>> +			mlog(ML_NOTICE, "Invalid dinode %llu "
>> +			     "disk generation: %u inode->i_generation: %u\n",
>> +			     (unsigned long long)oi->ip_blkno,
>> +			     le32_to_cpu(fe->i_generation),
>> +			     inode->i_generation);
>> +			status = -ESTALE;
>> +			goto bail_refresh;
>> +		}
>> +		if (le64_to_cpu(fe->i_dtime) ||
>> +		    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
>> +			mlog(ML_NOTICE,
>> +			     "Stale dinode %llu dtime: %llu flags: 0x%x\n",
>> +			     (unsigned long long)oi->ip_blkno,
>> +			     (unsigned long long)le64_to_cpu(fe->i_dtime),
>> +			     le32_to_cpu(fe->i_flags));
>> +			status = -ESTALE;
>> +			goto bail_refresh;
>>     
>
> 	Once again, we don't want to ML_NOTICE these -ESTALE conditions.
> -ESTALE is a normal thing.  Make that mlog(0, ...).
>
>   
ok.

thanks,
wengang.
