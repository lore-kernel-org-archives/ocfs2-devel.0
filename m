From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 11 Mar 2015 14:16:53 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix warning 'ocfs2_orphan_del'
 uses dynamic stack allocation
In-Reply-To: <20150126143813.35453f9f3091e038c57a1f94@linux-foundation.org>
References: <54C5B28F.8030704@huawei.com>
	<20150126143813.35453f9f3091e038c57a1f94@linux-foundation.org>
Message-ID: <54FFDDD5.8000908@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2015/1/27 6:38, Andrew Morton wrote:
> On Mon, 26 Jan 2015 11:20:47 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>> In ocfs2_orphan_del it uses dynamic stack allocation for orphan entry
>> name. Fix it by using dynamic heap allocation.
>>
>> ...
>>
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2298,18 +2298,22 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>>  {
>>  	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
>>  			OCFS2_ORPHAN_NAMELEN;
>> -	char name[namelen + 1];
>> +	char *name;
>>  	struct ocfs2_dinode *orphan_fe;
>>  	int status = 0;
>>  	struct ocfs2_dir_lookup_result lookup = { NULL, };
>>
>> +	name = kmalloc(namelen + 1, GFP_NOFS);
>> +	if (!name)
>> +		goto leave;
>> +
>>  	if (dio) {
>>  		status = snprintf(name, OCFS2_DIO_ORPHAN_PREFIX_LEN + 1, "%s",
>>  				OCFS2_DIO_ORPHAN_PREFIX);
>>  		if (status != OCFS2_DIO_ORPHAN_PREFIX_LEN) {
>>  			status = -EINVAL;
>>  			mlog_errno(status);
>> -			return status;
>> +			goto leave;
>>  		}
>>
>>  		status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno,
>> @@ -2357,6 +2361,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>>  	ocfs2_journal_dirty(handle, orphan_dir_bh);
>>
>>  leave:
>> +	kfree(name);
>>  	ocfs2_free_dir_lookup_result(&lookup);
>>
>>  	if (status)
> 
> I think I prefer my fix:
> 
> --- a/fs/ocfs2/namei.c~ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix
> +++ a/fs/ocfs2/namei.c
> @@ -2296,8 +2296,7 @@ int ocfs2_orphan_del(struct ocfs2_super
>  		     struct buffer_head *orphan_dir_bh,
>  		     bool dio)
>  {
> -	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
> -			OCFS2_ORPHAN_NAMELEN;
> +	const int namelen = OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN;
>  	char name[namelen + 1];
>  	struct ocfs2_dinode *orphan_fe;
>  	int status = 0;
> 
> It means we use 20 bytes of stack all the time, instead of
> sometimes-20, sometimes-16.
> 
> .
> 
If so, the namelen being passed to ocfs2_find_entry should be the
actual name length. Otherwise, it will fail because of mismatch.
I'll send a patch to fix this.
