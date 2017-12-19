From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 19 Dec 2017 03:00:13 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fall back to buffer IO when append
 dio is disabled with file hole existing
References: <63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com>
	<20171218135358.cee63b6019681cd7cfc569ee@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5CD0B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2017/12/19 5:54, Andrew Morton wrote:
> On Mon, 18 Dec 2017 12:06:21 +0000 Changwei Ge <ge.changwei@h3c.com> wrote:
> 
>> Before ocfs2 supporting allocating clusters while doing append-dio, all append
>> dio will fall back to buffer io to allocate clusters firstly. Also, when it
>> steps on a file hole, it will fall back to buffer io, too. But for current
>> code, writing to file hole will leverage dio to allocate clusters. This is not
>> right, since whether append-io is enabled tells the capability whether ocfs2 can
>> allocate space while doing dio.
>> So introduce file hole check function back into ocfs2.
>> Once ocfs2 is doing dio upon a file hole with append-dio disabled, it will fall
>> back to buffer IO to allocate clusters.
>>
> 
> hm, that's a bit hard to understand.  Hopefully reviewers will know
> what's going on ;)
Hi Andrew,
Sorry for mess up the changelog.
I will enrich the changelog and elaborate my intention further in the next version
of this patch.


> 
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2414,6 +2414,44 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>>    	return ret;
>>    }
>>    
>> +/*
>> + * Will look for holes and unwritten extents in the range starting at
>> + * pos for count bytes (inclusive).
>> + */
>> +static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
>> +				       size_t count)
>> +{
>> +	int ret = 0;
>> +	unsigned int extent_flags;
>> +	u32 cpos, clusters, extent_len, phys_cpos;
>> +	struct super_block *sb = inode->i_sb;
>> +
>> +	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
>> +	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
>> +
>> +	while (clusters) {
>> +		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
>> +					 &extent_flags);
>> +		if (ret < 0) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
>> +			ret = 1;
>> +			break;
>> +		}
>> +
>> +		if (extent_len > clusters)
>> +			extent_len = clusters;
>> +
>> +		clusters -= extent_len;
>> +		cpos += extent_len;
>> +	}
>> +out:
>> +	return ret;
>> +}
> 
> A few thoughts:
> 
> - a function which does "check_foo" isn't well named.  Because the
>    reader cannot determine whether the return value means "foo is true"
>    or "foo is false".

Very true.

> 
>    So a better name for this function is ocfs2_range_has_holes(), so
>    the reader immediately understand what its return value *means".
> 
>    Also a bool return value is more logical.

I prefer int value.
It's my fault here since I didn't check the return value for other exception
scenario.

> 
> - Mixing "goto out" with "break" as above is a bit odd.

Agree.

> 
> So...
> 
> 
> --- a/fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
> +++ a/fs/ocfs2/aops.c
> @@ -2469,10 +2469,9 @@ static int ocfs2_dio_end_io(struct kiocb
>    * Will look for holes and unwritten extents in the range starting at
>    * pos for count bytes (inclusive).
>    */
> -static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
> -				       size_t count)
> +static bool ocfs2_range_has_holes(struct inode *inode, loff_t pos, size_t count)
>   {
> -	int ret = 0;
> +	bool ret = false;
>   	unsigned int extent_flags;
>   	u32 cpos, clusters, extent_len, phys_cpos;
>   	struct super_block *sb = inode->i_sb;
> @@ -2489,8 +2488,8 @@ static int ocfs2_check_range_for_holes(s
>   		}
>   
>   		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
> -			ret = 1;
> -			break;
> +			ret = true;
> +			goto out;
>   		}

Ok, I will take this into account.

Thanks,
Changwei

>   
>   		if (extent_len > clusters)
> _
> 
> 
