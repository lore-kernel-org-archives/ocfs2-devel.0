From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 25 Feb 2009 11:44:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <20090225020855.GB5209@mail.oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
	<20090225020855.GB5209@mail.oracle.com>
Message-ID: <49A4BE80.4010003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>> +	status = ocfs2_test_inode_bit(osb, blkno, &set);
>> +	if (status < 0) {
>> +		if (status == -EINVAL) {
>> +			/* meta block never be re-allocated as data block.
>> +			 * nfsd gives us wrong blkno */
>> +			status = -EEXIST;
>> +		} else {
>> +			mlog(ML_ERROR, "test inode bit failed %d\n", status);
>> +		}
>> +		goto unlock_nfs_sync;
>> +	}
> 
> 	This looks very nice, but it should return -ESTALE instead
> of -EEXIST; 
why? I think it's an EEXIST.
if you say nfs don't know how to deal with the EEXIST, I agree to change it.
it most likely does not exist, and nfs knows how to handle
> that error.


>> +		mlog_errno((int)result);
>> +	}
> 
> 	Use PTR_ERR(result), not (int)result.
yes:)


>> +	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
>> +		status = -EINVAL;
>> +		goto bail;
>> +	}
> 
> 	Let's add an ML_ERROR here: "invalid inode %llu requested".
Ok.

>> +	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
>> +	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots -1) {
>> +		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u"
>> +		     "this may be caused by file system crash", blkno,
>> +		     (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
>> +		status = -EINVAL;
>> +		goto bail;
>> +	}
> 
> 	Don't print "this may be caused by file system crash", as it is
> much more likely that nfs is asking for a bad block.  Let's jsut say
> "inode %llu has an invalid suballoc slot %u".
Ok.

>> +	/* lock down the suballoc lock it to cause other nodes flush disk and
>> +	 * then release it immediately to let allocation on other nodes to go
>> +	 * asap. the reason we can read the group without lock is that we just
>> +	 * want to know if the bit is clear and there can't be a concurrent
>> +	 * clearing action because we hold the nfs_sync_lock. sure that there
>> +	 * can be a concurrent setting action then. it doesn't matter, we can
>> +	 * check generation later. */
>> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
>> +	if (status < 0) {
>> +		mutex_unlock(&inode_alloc_inode->i_mutex);
>> +		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
>> +		     (u32)suballoc_slot, status);
>> +		goto bail;
>> +	}
> 
> 	You need to test the suballoc bit inside the lock.  The current
> code is unsafe because while the inode set value won't change in a way
> that matters, the structure of the alloc inode's groups may.  

sorry, i don't understand the above very well.
i know the structure of the group may change since we released the 
suballoc lock. while, the change can only be manipulating a bit from 
"clear" to "set". according to our purpose, changing from "set" to 
"clear" is dangerous, the reverse changing only leads us to generation 
check. and the gen check can tell a stale inode.
I agree as a common function, it's not good if you meant that. but if 
it's used only for stale inode checking, it's workable I think.

thanks,
wengang.
