From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 20 Nov 2018 07:35:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix panic due to unrecovered
 local alloc
In-Reply-To: <4c0c7083-0e09-7bb3-48c7-7c9862bd6ba2@gmail.com>
References: <20181119080725.13059-1-junxiao.bi@oracle.com>
	<4c0c7083-0e09-7bb3-48c7-7c9862bd6ba2@gmail.com>
Message-ID: <88b6c0bf-b59a-7b09-e83d-16b1ba46e5a0@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 11/19/18 8:25 PM, Joseph Qi wrote:
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index 857bbbcd39f3..ea3493734ac6 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -345,13 +345,18 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>>   	if (num_used
>>   	    || alloc->id1.bitmap1.i_used
>>   	    || alloc->id1.bitmap1.i_total
>> -	    || la->la_bm_off)
>> -		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
>> +	    || la->la_bm_off) {
>> +		mlog(ML_ERROR, "inconsistent detected, clean journal with"
> Better to leave a blank space between "with" and "unrecovered" for readability.
> Other looks good.

Thanks. Will fix this.

Thanks,

Junxiao.

>
> With the above comments addressed,
> Acked-by: Joseph Qi<jiangqi903@gmail.com>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20181120/109f4fbf/attachment.html 
