From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 06 Nov 2008 14:08:52 +0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Add clusters free in
	dealloc_ctxt.v2
In-Reply-To: <20081105222520.GA15200@mail.oracle.com>
References: <20081104011652.GH22137@mail.oracle.com>
	<1225841123-3998-1-git-send-email-tao.ma@oracle.com>
	<20081105222520.GA15200@mail.oracle.com>
Message-ID: <491289F4.9020709@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Wed, Nov 05, 2008 at 07:25:23AM +0800, Tao Ma wrote:
>> Modification from V1 to V2:
>> 1. Some typo fix from Joel.
>> 2. Adjust ocfs2_free_cached_clusters to handle the situation of
>>    truncate log full. Most of codes are copied from 
>>    ocfs2_complete_truncate_log_recovery.
> 
> 	Looking good, one comment.
> 
>> @@ -5920,6 +6001,15 @@ int ocfs2_run_deallocs(struct ocfs2_super *osb,
>>  		kfree(fl);
>>  	}
>>  
>> +	if (ctxt->c_global_allocator) {
>> +		ret2 = ocfs2_free_cached_clusters(osb,
>> +						  ctxt->c_global_allocator);
>> +		if (ret2)
>> +			mlog_errno(ret2);
>> +		if (!ret)
>> +			ret = ret2;
> 
> 	Be sure to set ctxt->c_global_allocator to NULL here;  The block
> free list ends in a NULL, so c_first_suballocator ends up as NULL.  This
> cluster list should be set NULL too after free_cached_clusters()
> returns.
> 	Otherwise, this patch is good to go.
no problem. I will modify it in my own box. It will show up when Tiger 
sent his next round of acl. Thanks.

Regards,
Tao
