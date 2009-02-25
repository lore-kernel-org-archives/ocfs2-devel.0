From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 25 Feb 2009 21:57:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <20090225112710.GB26476@ca-server1.us.oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
	<20090225020855.GB5209@mail.oracle.com>
	<49A4BE80.4010003@oracle.com>
	<20090225112710.GB26476@ca-server1.us.oracle.com>
Message-ID: <49A54E5C.4090705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Feb 25, 2009 at 11:44:00AM +0800, Wengang Wang wrote:
>>>> +	status = ocfs2_test_inode_bit(osb, blkno, &set);
>>>> +	if (status < 0) {
>>>> +		if (status == -EINVAL) {
>>>> +			/* meta block never be re-allocated as data block.
>>>> +			 * nfsd gives us wrong blkno */
>>>> +			status = -EEXIST;
>>>> +		} else {
>>>> +			mlog(ML_ERROR, "test inode bit failed %d\n", status);
>>>> +		}
>>>> +		goto unlock_nfs_sync;
>>>> +	}
>>> 	This looks very nice, but it should return -ESTALE instead
>>> of -EEXIST; 
>> why? I think it's an EEXIST.
>> if you say nfs don't know how to deal with the EEXIST, I agree to change 
>> it.
>> it most likely does not exist, and nfs knows how to handle
>>> that error.
> 
> 	EEXIST means "the file exists", which it clearly does not.
> I think you mean ENOENT.  

Sorry, yes I meant ENOENT.
also, the following EEXIST is wrong too(and also in some existing codes).

+	inode_alloc_inode =
+		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
+					    suballoc_slot);
+	if (!inode_alloc_inode) {
+		/* the error code could be inaccurate, but we are not able to
+		 * get the correct one. */
+		status = -EEXIST;

here, we don't have the accurate reason. I suggest we return 
PTR_ERR(xxx) instead of NULL for ocfs2_get_system_file_inode() ( 
_ocfs2_get_system_file_inode() actually) and change code where 
ocfs2_get_system_file_inode() is called.

> But what is really happening here is nfs asks
> "I used to have file XXX, is it still there?"  The correct response
> seems to me to be "Um, not anymore - it's stale".

yes, your case is the "normal" stale case.
checking where EINVAL is returned, it's either 
(!OCFS2_IS_VALID_DINODE(inode_fe)) or alloc slot out of range.
in the two cases, I prefer nfs passed a wrong fh(blkno) instead of a 
stale one, that's nfs does a buggy request.
well, returning ESTALE is also OK. I just think ENOENT is more accurate.

>>>> +	/* lock down the suballoc lock it to cause other nodes flush disk and
>>>> +	 * then release it immediately to let allocation on other nodes to go
>>>> +	 * asap. the reason we can read the group without lock is that we just
>>>> +	 * want to know if the bit is clear and there can't be a concurrent
>>>> +	 * clearing action because we hold the nfs_sync_lock. sure that there
>>>> +	 * can be a concurrent setting action then. it doesn't matter, we can
>>>> +	 * check generation later. */
>>>> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
>>>> +	if (status < 0) {
>>>> +		mutex_unlock(&inode_alloc_inode->i_mutex);
>>>> +		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
>>>> +		     (u32)suballoc_slot, status);
>>>> +		goto bail;
>>>> +	}
>>> 	You need to test the suballoc bit inside the lock.  The current
>>> code is unsafe because while the inode set value won't change in a way
>>> that matters, the structure of the alloc inode's groups may.  
>> sorry, i don't understand the above very well.
>> i know the structure of the group may change since we released the suballoc 
>> lock. while, the change can only be manipulating a bit from "clear" to 
>> "set". according to our purpose, changing from "set" to "clear" is 
>> dangerous, the reverse changing only leads us to generation check. and the 
>> gen check can tell a stale inode.
>> I agree as a common function, it's not good if you meant that. but if it's 
>> used only for stale inode checking, it's workable I think.
> 
> 	The issue is not the clear<->set transition.  Remember, we're
> only blocking out deletes with the nfs sync lock.  Other nodes can do a
> create (the clear->set), but they also might do that on other group
> descriptors.  This means the layout of groups, including their pointers,
> might be changing beneath us.

if my understand is correct:),
yes, when there could be a new group added to a chain. and the chain 
list changed(pointers). and there could be a chain 
relink(ocfs2_relink_block_group()).
but I don't understand why it affects the group in question.
the group in question is gotten by reading the block which is numbered 
of inode blkno minus alloc bit. that doesn't involve any pointer.
so, could you tell me more detail?

> 	Also, it is a correctness issue.  Your way may happen to work
> for the stale inode checking, but that's by sheer luck.

until I got clear your idea about the groups, I persist :P.

>  Putting the
> access of the group inside the lock is definitively correct.

Yes, agree.
I just want a better performance when we are correct.

thanks,
wengang.
