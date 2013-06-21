From: Younger Liu <younger.liu@huawei.com>
Date: Fri, 21 Jun 2013 21:29:31 +0800
Subject: [Ocfs2-devel] [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
In-Reply-To: <20130620155555.GE28309@thunk.org>
References: <51C1381A.2@huawei.com> <20130620155555.GE28309@thunk.org>
Message-ID: <51C4553B.7010809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>, Li Zefan <lizefan@huawei.com>, jack@suse.cz

Hi Ted,

On 2013/6/20 23:55, Theodore Ts'o wrote:
> [ LKML and linux-fsdevel BCC'ed ]
> 
> On Wed, Jun 19, 2013 at 12:48:26PM +0800, Younger Liu wrote:
>> jbd2_journal_restart() would restart a handle. In this function, it
>> calls start_this_handle(). Before calling start_this_handle()?subtract
>> 1 from transaction->t_updates.
>> If start_this_handle() succeeds, transaction->t_updates increases by 1
>> in it. But if start_this_handle() fails, transaction->t_updates does
>> not increase.
>> So, when commit the handle's transaction in jbd2_journal_stop(), the
>> assertion is false, and then trigger a bug.
>> The assertion is as follows:
>> J_ASSERT(atomic_read(&transaction->t_updates) > 0) 
>>
>> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> 
> Thanks for pointing out this potential problem.  Your fix isn't quite
> the right one, however.
> 
> The problem is once we get to this point, the transaction pointer may
> no longer be valid, since once we decrement t_updates, the transaction
> could start commiting, and so we should not actually dereference the
> transaction pointer after we unlock transaction->t_handle_lock.  (We
> are referencing t_tid two lines later, and technically that's a bug.
> We've just been getting lucky.)
> 
> The real issue is that by the time we call start_this_handle() in
> jbd2__journal_restart, the handle is not attached to any transaction.
> So if jbd2_journal_restart() fails, the handle has to be considered
> invalid, and the calling code should not try to use the handle at all,
> including calling jbd2_journal_stop().
> 
> Jan Kara is I believe currently on vacation but I'd really like him to
> chime in with his opinion about the best way to fix this, since he's
> also quite familiar with the jbd2 code.
> 
> Also, Jan has recently submitted changes to implement reserved handles
> (to be submitted in the next merge window), and in these new
> functions, if start_this_handle() fails when called from
> jbd2_journal_start_reserved(), the handle is left invalidated, and the
> caller of jbd2_journal_start_reserved() must not touch the handle
> again, including calling jbd2_journal_stop() --- in fact, because
> jbd2_journal_start_reserved() clears current->journal_info on failure,
> an attempt to call jbd2_journal_stop() will result in the kernel oops
> due to an assertion failure.
> 
> My inclination is to fix this in the same way, but it will require
> changing the current code paths that use jbd2_journal_restart(), and
> in some cases passing back the state that the handle is now invalid
> and should not be released via jbd2_journal_stop() is going to be
> tricky indeed.
> 
> 
> Another possible fix is to set the handle to be aborted, via
> jbd2_journal_abort_handle().  This function isn't used at all at the
> moment, but from what I can tell this should do the right thing.  The
> one unfortunate thing about this is that when jbd2_journal_stop() gets
> called, it will return EROFS, which is a misleading error code.  I'm
> guessing you're seeing this because start_this_handle() returned
> ENOMEM, correct?  We could hack around this by stashing the real error
> in the handle, and then change jbd2_journal_stop() to return that
> error instead of EROFS if it is set.
> 
> This second solution is hacky all-around, and it's also inconsistent
> with how we are doing things with jbd2_journal_start_reserved().  So
> I'm not so happy with this solution.  But it would require a lot less
> work because the fix would be isolated in the jbd2 layer.  OTOH, right
> now if the code calls jbd2_journal_stop() on the handle after a
> failure in jbd2_journal_start_reserved(), they are crashing anyway, so
> changing the code so it changes with an assertion failure doesn't make
> things any worse, and then we fix things in ext4 and ocfs2 without any
> patch interdependencies --- and this is a problem which appears to
> happen very rarely in practice.
> 
> (How did you manage to trigger this, BTW?  Was this something you
> noticed by manual code inspection?  Or are you instrumenting the
> kernel's memory allocators to occasionally fail to test our error
> paths?  Or were you running in a system with very heavy memory
> pressure?)
> 
> 						- Ted
> 

This bug was triggered by the following scenario:
In ocfs2 file system, allocate a very large disk space for a small file
with ocfs2_fallocate(), while the journal file size is 32M. 

Because there are much many journal blocks needed by jbd2_journal_restart(), 
so that nblocks is greater than journal->j_max_transaction_buffers 
in start_this_handle(), and then return -ENOSPC.

In start_this_handle():
	if (nblocks > journal->j_max_transaction_buffers) {
		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
		       current->comm, nblocks,
		       journal->j_max_transaction_buffers);
		return -ENOSPC;
	}

Dump stack:
       <ffffffffa0b04620>{jbd2:jbd2_journal_stop+0x50}
       <ffffffffa0b671a3>{ocfs2:ocfs2_commit_trans+0x23}
       <ffffffffa0b5c8ce>{ocfs2:__ocfs2_extend_allocation+0x66e}
       <ffffffffa0b5cc55>{ocfs2:ocfs2_allocate_unwritten_extents+0xc5}
       <ffffffffa0b5d315>{ocfs2:__ocfs2_change_file_space+0x3f5}
       <ffffffffa0b5d67a>{ocfs2:ocfs2_fallocate+0x7a}
       <ffffffff80127689>{do_fallocate+0x129}
       <ffffffff801276d6>{sys_fallocate+0x46}
       <ffffffff803fd423>{system_call_fastpath+0x16}
       [<00007f7283b25030>]

This problem may be because jbd2_journal_restart() was called incorrectly 
in __ocfs2_extend_allocation() which was called by ocfs2_fallocate(). 

Although I solved this question by modifing __ocfs2_extend_allocation(), 
there is also a risk in jbd2_journal_restart() for jbd2 system.
So I put this potential risk to see if there is a better ideas.

> 
> 
>> ---
>>  fs/jbd2/transaction.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index 325bc01..9ddb444 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -530,6 +530,8 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
>>  	lock_map_release(&handle->h_lockdep_map);
>>  	handle->h_buffer_credits = nblocks;
>>  	ret = start_this_handle(journal, handle, gfp_mask);
>> +	if (ret < 0)
>> +		atomic_inc(&transaction->t_updates);
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(jbd2__journal_restart);
>> -- 
>> 1.7.9.7
>>
> 
> .
> 
