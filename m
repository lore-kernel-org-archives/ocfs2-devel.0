From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 25 Sep 2014 14:41:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock due to wrong locking
 order
In-Reply-To: <54228584.1090107@huawei.com>
References: <1410313732-27840-1-git-send-email-junxiao.bi@oracle.com>
	<54228584.1090107@huawei.com>
Message-ID: <5423B92A.5070605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/24/2014 04:49 PM, alex chen wrote:
> Hi, Junxiao:
> 
> On 2014/9/10 9:48, Junxiao Bi wrote:
>> For commit ocfs2 journal, ocfs2 journal thread will acquire the mutex
>> osb->journal->j_trans_barrier and wake up jbd2 commit thread, then it
>> will wait until jbd2 commit thread done. In order journal mode, jbd2
>> needs flushing dirty data pages first, and this needs get page lock.
>> So osb->journal->j_trans_barrier should be got before page lock.
>>
>> But ocfs2_write_zero_page() and ocfs2_write_begin_inline() obey this
>> locking order, and this will cause deadlock and hung the whole cluster.
>>
>> One deadlock catched is the following:
>>
>> PID: 13449  TASK: ffff8802e2f08180  CPU: 31  COMMAND: "oracle"
>>  #0 [ffff8802ee3f79b0] __schedule at ffffffff8150a524
>>  #1 [ffff8802ee3f7a58] schedule at ffffffff8150acbf
>>  #2 [ffff8802ee3f7a68] rwsem_down_failed_common at ffffffff8150cb85
>>  #3 [ffff8802ee3f7ad8] rwsem_down_read_failed at ffffffff8150cc55
>>  #4 [ffff8802ee3f7ae8] call_rwsem_down_read_failed at ffffffff812617a4
>>  #5 [ffff8802ee3f7b50] ocfs2_start_trans at ffffffffa0498919 [ocfs2]
>>  #6 [ffff8802ee3f7ba0] ocfs2_zero_start_ordered_transaction at ffffffffa048b2b8 [ocfs2]
>>  #7 [ffff8802ee3f7bf0] ocfs2_write_zero_page at ffffffffa048e9bd [ocfs2]
>>  #8 [ffff8802ee3f7c80] ocfs2_zero_extend_range at ffffffffa048ec83 [ocfs2]
>>  #9 [ffff8802ee3f7ce0] ocfs2_zero_extend at ffffffffa048edfd [ocfs2]
>>  #10 [ffff8802ee3f7d50] ocfs2_extend_file at ffffffffa049079e [ocfs2]
>>  #11 [ffff8802ee3f7da0] ocfs2_setattr at ffffffffa04910ed [ocfs2]
>>  #12 [ffff8802ee3f7e70] notify_change at ffffffff81187d29
>>  #13 [ffff8802ee3f7ee0] do_truncate at ffffffff8116bbc1
>>  #14 [ffff8802ee3f7f50] sys_ftruncate at ffffffff8116bcbd
>>  #15 [ffff8802ee3f7f80] system_call_fastpath at ffffffff81515142
>>     RIP: 00007f8de750c6f7  RSP: 00007fffe786e478  RFLAGS: 00000206
>>     RAX: 000000000000004d  RBX: ffffffff81515142  RCX: 0000000000000000
>>     RDX: 0000000000000200  RSI: 0000000000028400  RDI: 000000000000000d
>>     RBP: 00007fffe786e040   R8: 0000000000000000   R9: 000000000000000d
>>     R10: 0000000000000000  R11: 0000000000000206  R12: 000000000000000d
>>     R13: 00007fffe786e710  R14: 00007f8de70f8340  R15: 0000000000028400
>>     ORIG_RAX: 000000000000004d  CS: 0033  SS: 002b
>>
>> crash64> bt
>> PID: 7610   TASK: ffff88100fd56140  CPU: 1   COMMAND: "ocfs2cmt"
>>  #0 [ffff88100f4d1c50] __schedule at ffffffff8150a524
>>  #1 [ffff88100f4d1cf8] schedule at ffffffff8150acbf
>>  #2 [ffff88100f4d1d08] jbd2_log_wait_commit at ffffffffa01274fd [jbd2]
>>  #3 [ffff88100f4d1d98] jbd2_journal_flush at ffffffffa01280b4 [jbd2]
>>  #4 [ffff88100f4d1dd8] ocfs2_commit_cache at ffffffffa0499b14 [ocfs2]
>>  #5 [ffff88100f4d1e38] ocfs2_commit_thread at ffffffffa0499d38 [ocfs2]
>>  #6 [ffff88100f4d1ee8] kthread at ffffffff81090db6
>>  #7 [ffff88100f4d1f48] kernel_thread_helper at ffffffff81516284
>>
>> crash64> bt
>> PID: 7609   TASK: ffff88100f2d4480  CPU: 0   COMMAND: "jbd2/dm-20-86"
>>  #0 [ffff88100def3920] __schedule at ffffffff8150a524
>>  #1 [ffff88100def39c8] schedule at ffffffff8150acbf
>>  #2 [ffff88100def39d8] io_schedule at ffffffff8150ad6c
>>  #3 [ffff88100def39f8] sleep_on_page at ffffffff8111069e
>>  #4 [ffff88100def3a08] __wait_on_bit_lock at ffffffff8150b30a
>>  #5 [ffff88100def3a58] __lock_page at ffffffff81110687
>>  #6 [ffff88100def3ab8] write_cache_pages at ffffffff8111b752
>>  #7 [ffff88100def3be8] generic_writepages at ffffffff8111b901
>>  #8 [ffff88100def3c48] journal_submit_data_buffers at ffffffffa0120f67 [jbd2]
>>  #9 [ffff88100def3cf8] jbd2_journal_commit_transaction at ffffffffa0121372[jbd2]
>>  #10 [ffff88100def3e68] kjournald2 at ffffffffa0127a86 [jbd2]
>>  #11 [ffff88100def3ee8] kthread at ffffffff81090db6
>>  #12 [ffff88100def3f48] kernel_thread_helper at ffffffff81516284
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>  fs/ocfs2/aops.c |   15 ++++++++-------
>>  fs/ocfs2/file.c |   52 ++++++++++++++++++++++++----------------------------
>>  2 files changed, 32 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index c04183b..c71174a 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1485,8 +1485,16 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>>  	handle_t *handle;
>>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>>  
>> +	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>>  	page = find_or_create_page(mapping, 0, GFP_NOFS);
>>  	if (!page) {
>> +		ocfs2_commit_trans(osb, handle);
>>  		ret = -ENOMEM;
>>  		mlog_errno(ret);
>>  		goto out;
>> @@ -1498,13 +1506,6 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>>  	wc->w_pages[0] = wc->w_target_page = page;
>>  	wc->w_num_pages = 1;
>>  
>> -	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>> -	if (IS_ERR(handle)) {
>> -		ret = PTR_ERR(handle);
>> -		mlog_errno(ret);
>> -		goto out;
>> -	}
>> -
>>  	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
>>  				      OCFS2_JOURNAL_ACCESS_WRITE);
>>  	if (ret) {
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 2930e23..c534cb0 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -760,7 +760,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  	struct address_space *mapping = inode->i_mapping;
>>  	struct page *page;
>>  	unsigned long index = abs_from >> PAGE_CACHE_SHIFT;
>> -	handle_t *handle = NULL;
>> +	handle_t *handle;
>>  	int ret = 0;
>>  	unsigned zero_from, zero_to, block_start, block_end;
>>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>> @@ -769,11 +769,17 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
>>  	BUG_ON(abs_from & (inode->i_blkbits - 1));
>>  
>> +	handle = ocfs2_zero_start_ordered_transaction(inode, di_bh);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		goto out;
>> +	}
>> +
> 
> In ocfs2_zero_start_ordered_transaction, the inode will be filed into
> inode list of transaction by ocfs2_jbd2_file_inode.
> The relationship between ocfs2_jbd2_file_inode and lock_page as
> follow:
> 	find_or_create_page
> 		->lock_page
> 	ocfs2_zero_start_ordered_transaction
> 		->ocfs2_jbd2_file_inode
> 	unlock_page
> 
> But in your patch, the inode will be filed into inode list before the
> lock_page, is there a problem?

Could you detail more about what harm will be after changing the order?

Thanks,
Junxiao.
> 
> Thanks.
> 	--Alex
> 
>>  	page = find_or_create_page(mapping, index, GFP_NOFS);
>>  	if (!page) {
>>  		ret = -ENOMEM;
>>  		mlog_errno(ret);
>> -		goto out;
>> +		goto out_commit_trans;
>>  	}
>>  
>>  	/* Get the offsets within the page that we want to zero */
>> @@ -805,15 +811,6 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  			goto out_unlock;
>>  		}
>>  
>> -		if (!handle) {
>> -			handle = ocfs2_zero_start_ordered_transaction(inode,
>> -								      di_bh);
>> -			if (IS_ERR(handle)) {
>> -				ret = PTR_ERR(handle);
>> -				handle = NULL;
>> -				break;
>> -			}
>> -		}
>>  
>>  		/* must not update i_size! */
>>  		ret = block_commit_write(page, block_start + 1,
>> @@ -824,27 +821,26 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>>  			ret = 0;
>>  	}
>>  
>> -	if (handle) {
>> -		/*
>> -		 * fs-writeback will release the dirty pages without page lock
>> -		 * whose offset are over inode size, the release happens at
>> -		 * block_write_full_page().
>> -		 */
>> -		i_size_write(inode, abs_to);
>> -		inode->i_blocks = ocfs2_inode_sector_count(inode);
>> -		di->i_size = cpu_to_le64((u64)i_size_read(inode));
>> -		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>> -		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>> -		di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>> -		di->i_mtime_nsec = di->i_ctime_nsec;
>> -		ocfs2_journal_dirty(handle, di_bh);
>> -		ocfs2_update_inode_fsync_trans(handle, inode, 1);
>> -		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
>> -	}
>> +	/*
>> +	 * fs-writeback will release the dirty pages without page lock
>> +	 * whose offset are over inode size, the release happens at
>> +	 * block_write_full_page().
>> +	 */
>> +	i_size_write(inode, abs_to);
>> +	inode->i_blocks = ocfs2_inode_sector_count(inode);
>> +	di->i_size = cpu_to_le64((u64)i_size_read(inode));
>> +	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>> +	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>> +	di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>> +	di->i_mtime_nsec = di->i_ctime_nsec;
>> +	ocfs2_journal_dirty(handle, di_bh);
>> +	ocfs2_update_inode_fsync_trans(handle, inode, 1);
>>  
>>  out_unlock:
>>  	unlock_page(page);
>>  	page_cache_release(page);
>> +out_commit_trans:
>> +	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
>>  out:
>>  	return ret;
>>  }
>>
> 
