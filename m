From: Changwei Ge <chge@linux.alibaba.com>
Date: Mon, 5 Aug 2019 11:08:20 +0800
Subject: [Ocfs2-devel] [PATCH 1/3 v2] fs: ocfs2: Fix possible
 null-pointer dereferences in ocfs2_xa_prepare_entry()
In-Reply-To: <d56d61b1-d468-f967-4aaf-bb419c139bc3@linux.alibaba.com>
References: <20190726101447.9153-1-baijiaju1990@gmail.com>
	<d56d61b1-d468-f967-4aaf-bb419c139bc3@linux.alibaba.com>
Message-ID: <2b0fa21a-3351-0e3c-4355-54f22559a772@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Jia-Ju,


Please checkout my comments inline.


On 2019/7/27 8:49 ??, Joseph Qi wrote:
>
> On 19/7/26 18:14, Jia-Ju Bai wrote:
>> In ocfs2_xa_prepare_entry(), there is an if statement on line 2136 to
>> check whether loc->xl_entry is NULL:
>>      if (loc->xl_entry)
>>
>> When loc->xl_entry is NULL, it is used on line 2158:
>>      ocfs2_xa_add_entry(loc, name_hash);

This won't deference a NULL ->xl_entry because ->xlo_add_entry() is 
already called to whether ocfs2_xa_block_add_entry() or 
ocfs2_xa_bucket_add_entry()

 From the function name we can tell the intention it wants to add entry 
so of course it should be NULL before calling it.


Thanks,

Changwei


>>          loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
>>          loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
>> and line 2164:
>>      ocfs2_xa_add_namevalue(loc, xi);
>>          loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
>>          loc->xl_entry->xe_name_len = xi->xi_name_len;
>>
>> Thus, possible null-pointer dereferences may occur.
>>
>> To fix these bugs, if loc-xl_entry is NULL, ocfs2_xa_prepare_entry()
>> abnormally returns with -EINVAL.
>>
>> These bugs are found by a static analysis tool STCheck written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>> v2:
>> * Directly return -EINVAL if loc-xl_entry is NULL.
>>    Thank Joseph for helpful advice.
>>
>> ---
>>   fs/ocfs2/xattr.c | 44 +++++++++++++++++++++++---------------------
>>   1 file changed, 23 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 385f3aaa2448..4b876c82a35c 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -2133,29 +2133,31 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
>>   	if (rc)
>>   		goto out;
>>   
>> -	if (loc->xl_entry) {
>> -		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
>> -			orig_value_size = loc->xl_entry->xe_value_size;
>> -			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
>> -			if (rc)
>> -				goto out;
>> -			goto alloc_value;
>> -		}
>> +	if (!loc->xl_entry) {
>> +		rc = -EINVAL;
>> +		goto out;
>> +	}
>>   
>> -		if (!ocfs2_xattr_is_local(loc->xl_entry)) {
>> -			orig_clusters = ocfs2_xa_value_clusters(loc);
>> -			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
>> -			if (rc) {
>> -				mlog_errno(rc);
>> -				ocfs2_xa_cleanup_value_truncate(loc,
>> -								"overwriting",
>> -								orig_clusters);
>> -				goto out;
>> -			}
>> +	if (ocfs2_xa_can_reuse_entry(loc, xi)) {
>> +		orig_value_size = loc->xl_entry->xe_value_size;
>> +		rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
>> +		if (rc)
>> +			goto out;
>> +		goto alloc_value;
>> +	}
>> +
>> +	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
>> +		orig_clusters = ocfs2_xa_value_clusters(loc);
>> +		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
>> +		if (rc) {
>> +			mlog_errno(rc);
>> +			ocfs2_xa_cleanup_value_truncate(loc,
>> +							"overwriting",
>> +							orig_clusters);
>> +			goto out;
>>   		}
>> -		ocfs2_xa_wipe_namevalue(loc);
>> -	} else
>> -		ocfs2_xa_add_entry(loc, name_hash);
>> +	}
>> +	ocfs2_xa_wipe_namevalue(loc);
>>   
>>   	/*
>>   	 * If we get here, we have a blank entry.  Fill it.  We grow our
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
