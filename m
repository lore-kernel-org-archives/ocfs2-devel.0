From: alex chen <alex.chen@huawei.com>
Date: Fri, 28 Mar 2014 09:33:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not put bh when buffer_uptodate
 failed
In-Reply-To: <20140327022207.GA5215@localhost>
References: <53312AD6.4080607@huawei.com> <20140327022207.GA5215@localhost>
Message-ID: <5334D16F.9000704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/3/27 10:22, Joel Becker wrote:
> On Tue, Mar 25, 2014 at 03:05:58PM +0800, alex chen wrote:
>> Do not put bh when buffer_uptodate failed in ocfs2_write_block and
>> ocfs2_write_super_or_backup, because it will put bh in b_end_io.
>> Otherwise it will hit a warning "VFS: brelse: Trying to free free
>> buffer".
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> 
> Good catch.  Can you tell me what testing or workload found this issue?
> Just for future reference.
> 
> Acked-by: Joel Becker <jlbec@evilplan.org>
> 

This issue was found when resizing volume. During the resize, storage
link was not steady and continuing up and down. Uptodate buffer failed
because of EIO in ocfs2_write_super_or_backup and then this warning
occurs.

>> ---
>>  fs/ocfs2/buffer_head_io.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>> index 5b704c6..1edcb14 100644
>> --- a/fs/ocfs2/buffer_head_io.c
>> +++ b/fs/ocfs2/buffer_head_io.c
>> @@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>>  		 * information for this bh as it's not marked locally
>>  		 * uptodate. */
>>  		ret = -EIO;
>> -		put_bh(bh);
>>  		mlog_errno(ret);
>>  	}
>>
>> @@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>>
>>  	if (!buffer_uptodate(bh)) {
>>  		ret = -EIO;
>> -		put_bh(bh);
>>  		mlog_errno(ret);
>>  	}
>>
>> -- 
>> 1.8.4.3
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
