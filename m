From: Changwei Ge <chge@linux.alibaba.com>
Date: Mon, 5 Aug 2019 10:38:55 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] fs: ocfs2: Fix a possible
 null-pointer dereference in ocfs2_write_end_nolock()
In-Reply-To: <cdec8b79-a854-e9b0-21af-897c7eedc454@linux.alibaba.com>
References: <20190726033705.32307-1-baijiaju1990@gmail.com>
	<cdec8b79-a854-e9b0-21af-897c7eedc454@linux.alibaba.com>
Message-ID: <20d02767-6e14-c04f-4fcf-11ed2cbd63a2@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>

Hi Jia-ju,


Could you please point out how ->w_handle can be NULL if we are changing 
disk inode?

I just checked the ocfs2 code but can't find any clue ...

In my opinion, it's impossible to change disk inode without an existed 
journal transaction. If truly so, it's a another problem.


Thanks,

Changwei


On 2019/7/26 5:38 ??, Joseph Qi wrote:
>
> On 19/7/26 11:37, Jia-Ju Bai wrote:
>> In ocfs2_write_end_nolock(), there are an if statement on lines 1976,
>> 2047 and 2058, to check whether handle is NULL:
>>      if (handle)
>>
>> When handle is NULL, it is used on line 2045:
>> 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
>>          oi->i_sync_tid = handle->h_transaction->t_tid;
>>
>> Thus, a possible null-pointer dereference may occur.
>>
>> To fix this bug, handle is checked before calling
>> ocfs2_update_inode_fsync_trans().
>>
>> This bug is found by a static analysis tool STCheck written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Looks good.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>
>> ---
>>   fs/ocfs2/aops.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index a4c905d6b575..5473bd99043e 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2042,7 +2042,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>>   		inode->i_mtime = inode->i_ctime = current_time(inode);
>>   		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>>   		di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>> -		ocfs2_update_inode_fsync_trans(handle, inode, 1);
>> +		if (handle)
>> +			ocfs2_update_inode_fsync_trans(handle, inode, 1);
>>   	}
>>   	if (handle)
>>   		ocfs2_journal_dirty(handle, wc->w_di_bh);
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
