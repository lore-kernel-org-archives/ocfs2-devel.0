From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 13 Jun 2008 10:08:22 +0800
Subject: [Ocfs2-devel] [PATCH 4/8] Make extend allocation generic.v1
In-Reply-To: <20080612205914.GP28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<20080605073309.GA19782@tma-pc2.cn.oracle.com>
	<20080612205914.GP28100@wotan.suse.de>
Message-ID: <4851D696.10901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Thu, Jun 05, 2008 at 03:33:09PM +0800, Tao Ma wrote:
>
>> @@ -508,96 +508,14 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
>>  			       struct ocfs2_alloc_context *meta_ac,
>>  			       enum ocfs2_alloc_restarted *reason_ret)
> 
> I think you should rename ocfs2_do_extend_allocation to something more
> direct since it's used only for traditional inode data btrees. Maybe
> ocfs2_add_inode_data() ?
How about ocfs2_add_inode_data_in_extent? So that it means we allocate 
extent rec to store it?
> 
> 
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 1992a6a..c953796 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1973,3 +1973,106 @@ out:
>>  
>>  	return ret;
>>  }
>> +
>> +int ocfs2_do_cluster_allocation(struct ocfs2_super *osb,
> 
> Likewise, this name doesn't tell me much about the function. Also, a
> comment describing it's expected usage would be nice ;)
How about the name ocfs2_add_cluster_for_extent?
> 
> 
>> +				struct inode *inode,
>> +				u32 *logical_offset,
>> +				u32 *clusters_to_add,
> 
> This changed to a "u32 *" but you gave no explanation of why.
Yes, this is used by the *old* xattr extend allocation, so that the user 
can detect how much the clusters have been added. Now I can do it in 
another way.So I will not change it in my revised patch. Thanks.

Regards,
Tao
