From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 25 Feb 2009 03:27:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <49A4BE80.4010003@oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
	<20090225020855.GB5209@mail.oracle.com>
	<49A4BE80.4010003@oracle.com>
Message-ID: <20090225112710.GB26476@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 25, 2009 at 11:44:00AM +0800, Wengang Wang wrote:
>>> +	status = ocfs2_test_inode_bit(osb, blkno, &set);
>>> +	if (status < 0) {
>>> +		if (status == -EINVAL) {
>>> +			/* meta block never be re-allocated as data block.
>>> +			 * nfsd gives us wrong blkno */
>>> +			status = -EEXIST;
>>> +		} else {
>>> +			mlog(ML_ERROR, "test inode bit failed %d\n", status);
>>> +		}
>>> +		goto unlock_nfs_sync;
>>> +	}
>> 	This looks very nice, but it should return -ESTALE instead
>> of -EEXIST; 
> why? I think it's an EEXIST.
> if you say nfs don't know how to deal with the EEXIST, I agree to change 
> it.
> it most likely does not exist, and nfs knows how to handle
>> that error.

	EEXIST means "the file exists", which it clearly does not.
I think you mean ENOENT.  But what is really happening here is nfs asks
"I used to have file XXX, is it still there?"  The correct response
seems to me to be "Um, not anymore - it's stale".

>>> +	/* lock down the suballoc lock it to cause other nodes flush disk and
>>> +	 * then release it immediately to let allocation on other nodes to go
>>> +	 * asap. the reason we can read the group without lock is that we just
>>> +	 * want to know if the bit is clear and there can't be a concurrent
>>> +	 * clearing action because we hold the nfs_sync_lock. sure that there
>>> +	 * can be a concurrent setting action then. it doesn't matter, we can
>>> +	 * check generation later. */
>>> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
>>> +	if (status < 0) {
>>> +		mutex_unlock(&inode_alloc_inode->i_mutex);
>>> +		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
>>> +		     (u32)suballoc_slot, status);
>>> +		goto bail;
>>> +	}
>> 	You need to test the suballoc bit inside the lock.  The current
>> code is unsafe because while the inode set value won't change in a way
>> that matters, the structure of the alloc inode's groups may.  
>
> sorry, i don't understand the above very well.
> i know the structure of the group may change since we released the suballoc 
> lock. while, the change can only be manipulating a bit from "clear" to 
> "set". according to our purpose, changing from "set" to "clear" is 
> dangerous, the reverse changing only leads us to generation check. and the 
> gen check can tell a stale inode.
> I agree as a common function, it's not good if you meant that. but if it's 
> used only for stale inode checking, it's workable I think.

	The issue is not the clear<->set transition.  Remember, we're
only blocking out deletes with the nfs sync lock.  Other nodes can do a
create (the clear->set), but they also might do that on other group
descriptors.  This means the layout of groups, including their pointers,
might be changing beneath us.
	Also, it is a correctness issue.  Your way may happen to work
for the stale inode checking, but that's by sheer luck.  Putting the
access of the group inside the lock is definitively correct.

Joel

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
