From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 14 May 2013 12:57:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock rw lock if inode lock failed
In-Reply-To: <20130508123858.f22b8a5157f09f9014e34e25@linux-foundation.org>
References: <5187C19B.4040708@huawei.com>
	<20130508123858.f22b8a5157f09f9014e34e25@linux-foundation.org>
Message-ID: <5191C42F.6050507@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/5/9 3:38, Andrew Morton wrote:
> On Mon, 6 May 2013 22:43:39 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>> In ocfs2_file_aio_write, it does ocfs2_rw_lock first and then
>> ocfs2_inode_lock. But if ocfs2_inode_lock failed, it goes to out_sems
>> without unlocking rw lock. This will cause a bug in ocfs2_lock_res_free
>> when testing res->l_ex_holders, which is increased in
>> __ocfs2_cluster_lock and decreased in __ocfs2_cluster_unlock.
>>
>> ...
>>
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2290,7 +2290,7 @@ relock:
>>  		ret = ocfs2_inode_lock(inode, NULL, 1);
>>  		if (ret < 0) {
>>  			mlog_errno(ret);
>> -			goto out_sems;
>> +			goto out;
>>  		}
>>
>>  		ocfs2_inode_unlock(inode, 1);
> 
> That seems like a fairly serious bug.  How long has it been there and
> what userspace actions are required to trigger it?
> 
> (I'm trying to work out which kernel versions we should merge the
> fix into, but the changelog didn't give me enough info to determine
> this)
> 
> .
> 
Sorry for the delayed reply.
The reproducible case is lots of write IOs plus storage link down and
then restore.
And my kernel is 3.0.13.
