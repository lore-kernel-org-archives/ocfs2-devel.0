From: piaojun <piaojun@huawei.com>
Date: Mon, 19 Nov 2018 09:52:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix panic due to unrecovered local
 alloc
In-Reply-To: <0d2af0c9-c1a7-ed18-c661-2ad8efcfad26@oracle.com>
References: <20181116073335.5045-1-junxiao.bi@oracle.com>
	<5BF209D6.6040900@huawei.com>
	<0d2af0c9-c1a7-ed18-c661-2ad8efcfad26@oracle.com>
Message-ID: <5BF21740.5040308@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2018/11/19 9:35, Junxiao Bi wrote:
> Hi Jun,
> 
> On 11/19/18 8:54 AM, piaojun wrote:
>>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>>> index 7642b6712c39..755ec2aa2db0 100644
>>> --- a/fs/ocfs2/localalloc.c
>>> +++ b/fs/ocfs2/localalloc.c
>>> @@ -345,13 +345,18 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>>>  	if (num_used
>>>  	    || alloc->id1.bitmap1.i_used
>>>  	    || alloc->id1.bitmap1.i_total
>>> -	    || la->la_bm_off)
>>> -		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
>>> +	    || la->la_bm_off) {
>>> +		mlog(ML_ERROR, "inconsistent detected, clean journal with"
>>> +		     "unrecovered local alloc, please run fsck.ocfs2!\n"
>>>  		     "found = %u, set = %u, taken = %u, off = %u\n",
>>>  		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>>>  		     le32_to_cpu(alloc->id1.bitmap1.i_total),
>>>  		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
>>>  
>> Could we try to recover local alloc with
>> ocfs2_begin_local_alloc_recovery() automatically if it's dirty? And fsck
>> seems a little heavy.
> 
> I supposed the "dirty" here you mean local alloc.
> 
> As i have mentioned in the patch log, recover it during mount is not safe. There could be io error happened after mark journal clean, so corruption may happen to  local alloc and other metadata, run a full fsck is to avoid further corruption.
> 
> Thanks,
> 
> Junxiao.
> 
The "dirty" means local alloc. And I wonder if fsck just does the same
thing with ocfs2_begin_local_alloc_recovery()? I still think recoverying
local alloc won't do harm to it, as that only involves local alloc
metadata. But I'm glad to hear others' opinions about this problem.

Thanks,
Jun
