From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 25 Feb 2009 08:58:28 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <49A54E5C.4090705@oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
	<20090225020855.GB5209@mail.oracle.com>
	<49A4BE80.4010003@oracle.com>
	<20090225112710.GB26476@ca-server1.us.oracle.com>
	<49A54E5C.4090705@oracle.com>
Message-ID: <20090225165828.GC26476@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 25, 2009 at 09:57:48PM +0800, Wengang Wang wrote:
> Joel Becker wrote:
>> On Wed, Feb 25, 2009 at 11:44:00AM +0800, Wengang Wang wrote:
>>>>> +	status = ocfs2_test_inode_bit(osb, blkno, &set);
>>>>> +	if (status < 0) {
>>>>> +		if (status == -EINVAL) {
>>>>> +			/* meta block never be re-allocated as data block.
>>>>> +			 * nfsd gives us wrong blkno */
>>>>> +			status = -EEXIST;
>>>>> +		} else {
>>>>> +			mlog(ML_ERROR, "test inode bit failed %d\n", status);
>>>>> +		}
>>>>> +		goto unlock_nfs_sync;
>>>>> +	}
>>>> 	This looks very nice, but it should return -ESTALE instead
>>>> of -EEXIST; 
>>> why? I think it's an EEXIST.
>>> if you say nfs don't know how to deal with the EEXIST, I agree to change 
>>> it.
>>> it most likely does not exist, and nfs knows how to handle
>>>> that error.
>> 	EEXIST means "the file exists", which it clearly does not.
>> I think you mean ENOENT.  
>
> Sorry, yes I meant ENOENT.
> also, the following EEXIST is wrong too(and also in some existing codes).
>
> +	inode_alloc_inode =
> +		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
> +					    suballoc_slot);
> +	if (!inode_alloc_inode) {
> +		/* the error code could be inaccurate, but we are not able to
> +		 * get the correct one. */
> +		status = -EEXIST;
>
> here, we don't have the accurate reason. I suggest we return PTR_ERR(xxx) 
> instead of NULL for ocfs2_get_system_file_inode() ( 
> _ocfs2_get_system_file_inode() actually) and change code where 
> ocfs2_get_system_file_inode() is called.

	Yeah, I noticed that we don't have an error from
ocfs2_get_system_file_inode().  But we don't have any need to fix that
right now.  That can be a later patch if we care.

>> But what is really happening here is nfs asks
>> "I used to have file XXX, is it still there?"  The correct response
>> seems to me to be "Um, not anymore - it's stale".
>
> yes, your case is the "normal" stale case.
> checking where EINVAL is returned, it's either 
> (!OCFS2_IS_VALID_DINODE(inode_fe)) or alloc slot out of range.
> in the two cases, I prefer nfs passed a wrong fh(blkno) instead of a stale 
> one, that's nfs does a buggy request.
> well, returning ESTALE is also OK. I just think ENOENT is more accurate.

	I agree with you that ENOENT is more accurate, but right now
we're playing nice with nfsd.  Actually, return -ENOENT from the test
function, but in ocfs2_get_dentry() change it to -ESTALE for nfsd.

> if my understand is correct:),
> yes, when there could be a new group added to a chain. and the chain list 
> changed(pointers). and there could be a chain 
> relink(ocfs2_relink_block_group()).
> but I don't understand why it affects the group in question.
> the group in question is gotten by reading the block which is numbered of 
> inode blkno minus alloc bit. that doesn't involve any pointer.
> so, could you tell me more detail?

	I agree it probably doesn't affect this direct block group.  At
least, unless we change the code to do some walking or whatever.  But we
want this function to be right no matter the behavior.

>> 	Also, it is a correctness issue.  Your way may happen to work
>> for the stale inode checking, but that's by sheer luck.
>
> until I got clear your idea about the groups, I persist :P.
>
>>  Putting the
>> access of the group inside the lock is definitively correct.
>
> Yes, agree.
> I just want a better performance when we are correct.

	We will never sacrifice correctness for performance.  You don't
access data outside of locks unless you have some really, really good
reason.  This won't hurt any performance - it's a standard operation we
do all the time: "take lock, do something with group descriptor, drop
lock".  If it was a performance problem it would be a problem
everywhere, and we'd solve it in a correct fashion.
	Secondly, if some later code decides to use this function, they
certainly won't expect it to be doing unsafe things.  And they won't be
inside a very specific nfs code path.

Joel

-- 

Life's Little Instruction Book #69

	"Whistle"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
