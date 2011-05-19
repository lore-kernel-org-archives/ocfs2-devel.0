From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 19 May 2011 10:45:28 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
In-Reply-To: <4DD4DF4C.501@oracle.com>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
	<1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
	<4DD4DF4C.501@oracle.com>
Message-ID: <4DD55738.3080405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tristan Ye <tristan.ye@oracle.com>
Cc: josef@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk, ocfs2-devel@oss.oracle.com

On 05/19/2011 02:13 AM, Tristan Ye wrote:
>> +	if (inode->i_size == 0 || *offset>= inode->i_size) {
>> +		ret = -ENXIO;
>> +		goto out_unlock;
>> +	}
> Why not using if (*offset>= inode->i_size) directly?

duh!

> +			BUG_ON(cpos<  le32_to_cpu(rec.e_cpos));
> A same assert has already been performed inside ocfs2_get_clusters_nocache(),
> does it make sense to do it again here?

good catch

>> +
>> +		if ((!is_data&&  origin == SEEK_HOLE) ||
>> +		    (is_data&&  origin == SEEK_DATA)) {
>> +			if (extoff>  *offset)
>> +				*offset = extoff;
>> +			goto out_unlock;
> Seems above logic is going to stop at the first time we find a hole.
>
> How about the offset was within the range of a hole already when we doing
> SEEK_HOLE, shouldn't we proceed detecting until the next hole gets found, whose
> start_offset was greater than supplied offset, according to semantics described
> by the the header of this patch, should it be like following?
>
> 			if (extoff>  *offset) {
> 				*offset = extoff;
> 				goto out_unlock;
> 			}

So if the offset is in a hole, then we set the file pointer to it. Same for
data. The file pointer is set to the region asked at an offset that is equal
to or greater than the supplied offset.

>> +	if (origin == SEEK_HOLE) {
>> +		extoff = cpos;
>> +		extoff<<= cs_bits;
> extoff already has been assigned properly above in while loop?

To handle the case when supplied cpos == cend.

As always, excellent review.

Thanks
Sunil
