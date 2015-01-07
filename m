From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 07 Jan 2015 10:42:56 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix uninitialized variable
	access
In-Reply-To: <20150106160955.fd10d1aee8a0456fb6dc4846@linux-foundation.org>
References: <1419486737-16102-1-git-send-email-junxiao.bi@oracle.com>
	<20150106160955.fd10d1aee8a0456fb6dc4846@linux-foundation.org>
Message-ID: <54AC9D30.4000408@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/07/2015 08:09 AM, Andrew Morton wrote:
> On Thu, 25 Dec 2014 13:52:16 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
>> Variable "why" is not yet initialized at line 615, fix it.
>>
>> ...
>>
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -569,7 +569,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
>>  	handle_t *handle = NULL;
>>  	struct ocfs2_alloc_context *data_ac = NULL;
>>  	struct ocfs2_alloc_context *meta_ac = NULL;
>> -	enum ocfs2_alloc_restarted why;
>> +	enum ocfs2_alloc_restarted why = RESTART_NONE;
>>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>  	struct ocfs2_extent_tree et;
>>  	int did_quota = 0;
> 
> Oh geeze, are you really sure about this?  __ocfs2_extend_allocation()
> is as clear as mud.  What happens when ocfs2_add_inode_data() returns
> -EAGAIN and leaves *reason_ret unwritten to?
*reason_ret will always be written when ocfs2_add_inode_data() return.
> 
> What are the runtime effects of this bug?

I didn't see any other effects except a compile warning and an
uninitialized variable from the tracepoint.

Thanks,
Junxiao.
> 
