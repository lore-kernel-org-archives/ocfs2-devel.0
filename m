From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 18:09:12 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/xattr: Merge xattr
	set	transaction.
In-Reply-To: <49011A69.9040003@oracle.com>
References: <48F81730.9020809@oracle.com>
	<1224218678-32196-2-git-send-email-tao.ma@oracle.com>
	<20081023214036.GC12751@mail.oracle.com>
	<49011A69.9040003@oracle.com>
Message-ID: <20081024010912.GG12751@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 08:44:25AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>>>  fs/ocfs2/xattr.c |  889 +++++++++++++++++++++++++++++++-----------------------
>>>  1 files changed, 514 insertions(+), 375 deletions(-)
>>
>> 	I'm trying to think of a way you could break this patch up.
>> It's huge.
> Actually, most of the modification are just changing ocfs2_start_trans  
> to ocfs2_extend_trans and passing 'handle_t *' to the function. So  
> although the patch is a little large, but I think it is easy to review,  
> does it? ;)

	No, I found it incredibly hard to wade through, because I'd get
to a point where I'd lost track of where I was, and I would look and see
I'd only viewed 44% of the patch :-)
	There's a lot going on in here.  You're moving the transaction
calculations around, moving locks, reorganizing the calls to the various
set handlers, and that's just for starters.

>>>   static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
>>> +					     handle_t *handle,
>>>  					     struct ocfs2_xattr_info *xi,
>>> -					     struct ocfs2_xattr_search *xs);
>>> +					     struct ocfs2_xattr_search *xs,
>>> +					     struct ocfs2_xattr_set_ctxt *ctxt);
>>
>> 	You pass 'handle' and 'ctxt' to all the same functions.  Why not
>> put the handle on the ctxt?
> Most functions doesn't need 'ctxt' actually, only the functions which  
> use cluster/metadata allocation/free use it. So I'd like to separate 
> them.

	Almost every function I saw that took 'handle' also took 'ctxt'.
But that's not such a big deal.

>>> +			clusters_to_add) + handle->h_buffer_credits;
>>> +	status = ocfs2_extend_trans(handle, credits);
>>
>> 	Um, you just made 'credits' be double the existing transaction +
>> the result of ocfs2_calc_extend_credits().  Did you mean that?
>> ocfs2_extend_trans() takes the additional credits, not the total.  Later
>> you do an eocfs2_extend_trans() with merely the new credits, so I wonder
>> if you meant this here?
> Yes, I do this intentionally. Because ocfs2_extend_trans sometimes  
> doesn't work like its name. ;) If the first extension fails, it will  
> commit the dirty blocks and then extend it, that make the credits which  
> isn't used lost. In some cases it is OK(see some of my following  
> modification), while in other cases when some metadata will be updated  
> after this function, it will fails because of no credits. I have once  
> meet with a bug for this. And actually tree operation do the same thing  
> as I do. See  ocfs2_extend_rotate_transaction.

	Ok, so the basic thought is that we're going to need
h_buffer_credits after we return from this function in other places -
we're not done with them just because we commit inside
ocfs2_extend_trans().
	The big concern here is that:

1) ocfs2_extend_trans() commits the half-completed work so it can
   free up some space in the journal.
2) The system crashes.
3) jbd2 replays the half-completed work.
4) We mount again, and our code can't handle the half-completed work.

	The alloc.c code is written to handle this half-completed state
of our trees.  Actually, our trees almost never end up in half-completed
states.  They are always valid trees at the point we might extend/commit
a transaction.   I'm not worried about the xattr trees (index or value)
in this regard.  I'm worried about any fields we've updated that get
written due to these unexpected commits.
	For example, when setting an xattr you try ibody_set() first.
If that succeeds, you then go ahead and clear the same xattr out of the
external block/tree.  So if there is an extend_trans() somewhere in
there, and it commits a change, you could crash and have the xattr in
both the ibody and the external block/tree.  The same with the reverse
(set in external, commit, clear in ibody, crash).  We need to make sure
we either don't actually have these cases happen or handle them
gracefully.

>>> +	credits = ocfs2_calc_xattr_set_credits(inode, &xi, &xis, &xbs);
>>
>> 	You recalculate this inside __ocfs2_xattr_set_handle().  Why do
>> you need to calculate it twice?
> I calculate twice because the situation has been changed. If the xattr  
> is in inode, the ocfs2_xattr_set will only search inode, so the first  
> calc will get 1(for inode update). While if the __ocfs2_xattr_set_handle  
> can update the xattr successfully it will try to move it to bucket, then  
> we have to calc again since we are going to update a bucket.

	Makes sense.

Joel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
