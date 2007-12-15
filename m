From: Tao Ma <tao.ma@oracle.com>
Date: Sat Dec 15 00:44:13 2007
Subject: [Ocfs2-devel] [PATCH 4/4] Implement "GROUP_ADD" for
	online	resize.take 3
In-Reply-To: <20071215000739.GD7300@mail.oracle.com>
References: <20071214073744.GA26638@tma-pc1.cn.oracle.com>
	<20071214075641.GA26713@tma-pc1.cn.oracle.com>
	<20071215000739.GD7300@mail.oracle.com>
Message-ID: <47639382.80704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker Wrote:
> On Fri, Dec 14, 2007 at 03:56:41PM +0800, Tao Ma wrote:
>   
>> 2. For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
>>    to add them one by one. The new group descriptor is initialized
>>    in userspace, we only check it in the kernel and update the
>>    global_bitap, super blocks etc.
>>     
>
> 	I like the patches overall.  They are clean and straightforward.
>
>   
>> +	if (cluster < total_clusters)
>> +		mlog(0, "add a group which is in the current volume.\n");
>> +	else if (input->chain >= cl_count)
>> +		mlog(0, "input chain exceeds the limit.\n");
>> +	else if (next_free != cl_count && next_free != input->chain)
>> +		mlog(0, "the add group should be in chain %u\n", next_free);
>> +	else if (total_clusters + input->clusters < total_clusters)
>> +		mlog(0, "add group's clusters overflow.\n");
>> +	else if (input->clusters > cl_cpg)
>> +		mlog(0, "the cluster exceeds the maximum of a group\n");
>> +	else if (input->frees > input->clusters)
>> +		mlog(0, "the free cluster exceeds the total clusters\n");
>> +	else if (total_clusters % cl_cpg != 0)
>> +		mlog(0, "the last group isn't full. Use group extend first.\n");
>> +	else if (input->group != ocfs2_which_cluster_group(inode, cluster))
>> +		mlog(0, "group blkno is invalid\n");
>> +	else if ((ret = ocfs2_check_new_group(inode, di, input, group_bh)))
>> +		mlog(0, "group descriptor check failed.\n");
>> +	else
>> +		ret = 0;
>>     
>
> 	These are some great errors, but the user will never see them.
> tunefs.ocfs2 will just report "Invalid argument", which isn't very
> helpful.  The same goes for the errors in the group check function,
> which returns -EIO.  I'd love to see a way for the user to see them.
> Either targeted errno values that tunefs can translate into strings, or
> mlogs in dmesg so that tunefs can say "see dmesg for more info".
> Something like that.  Mark points out that this should only be for real
> errors, not things that are "normal operation" like ENOSPC.
>   
Yeah, so maybe I need to use mlog(ML_ERROR,...) so that the user can see 
it in dmesg and let tunefs.ocfs2 print out "see dmesg for more details".
Thanks for your review.
