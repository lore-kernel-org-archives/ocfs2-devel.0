Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205EC72602
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 04:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765515273; cv=none; b=kKp1en8yTpPUPMmdw8YoLh8lBnAfJ90Y0OZvHopUANE4oTK3vr4vbiPLjJEpZ/i9UtBNTKXSZmDIk6KfmukpgvRd+qteNaPy6xIzugO/4FfXkQZG9v8Ic9KIcktl+NJX6EPBH4E2oK8DaQT88JoGP4z9/sEx+Fqt48s5+Vuu8so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765515273; c=relaxed/simple;
	bh=dALrwtfmab6iLzkwQeH0zAqpKOKJ42GU/ttYzEsyiqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTqbjygkOZsfFrDRnY02mad+0pb1r5rnY9wuTWVFth9Udq1WXfpQ7citdYRwT9LdBiQ+Azq4bKY6WhN1QTbiIdhbUHFZAPZaOWei8jOGe8BDlipSv+niuQ0mw8pdG9NSkj+ZShnAAZPesMiM7DnTiI0ZD7BXEwdOiWn+EZG1/K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jz5oADD+; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jz5oADD+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765515262; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Bp0oQevPMDV/RcaTqN7YfDKIn2BiFXa7m5+nDHZtJ8s=;
	b=jz5oADD+oywdb6rRDsoo0hZjkEthpR+lSfOeKeUmH91uEfI2wKEzncsN9YS9kQvL2MwCmhUYjqziV+Dk1EhDbCIqF+sb46hPV+jg4Pard0tCkUU9JDRuNHYTQ97YT0iN4xaPESbfo4PmSMf4R9rQZimN3FNe1HUi0CGo9l8Pzg4=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wucwrau_1765514945 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 12:49:05 +0800
Message-ID: <b3f7d236-0879-445f-8f46-09045f37ec99@linux.alibaba.com>
Date: Fri, 12 Dec 2025 12:49:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate inline data i_size during inode read
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
References: <20251212040400.6377-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251212040400.6377-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 12:04, Deepanshu Kartikey wrote:
> When reading an inode from disk, ocfs2_validate_inode_block() performs
> various sanity checks but does not validate the size of inline data.
> If the filesystem is corrupted, an inode's i_size can exceed the actual
> inline data capacity (id_count).
> 
> This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline
> data buffer, triggering a use-after-free when accessing directory
> entries from freed memory.
> 
> In the syzbot report:
>   - i_size was 1099511627576 bytes (~1TB)
>   - Actual inline data capacity (id_count) is typically <256 bytes
>   - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
>   - This triggered a UAF in ocfs2_check_dir_entry()
> 
> Fix by adding a validation check in ocfs2_validate_inode_block() to
> ensure inodes with inline data have i_size <= id_count. This catches
> the corruption early during inode read and prevents all downstream
> code from operating on invalid data.
> 
> Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
> Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v2:
>   - Removed unnecessary S_ISDIR() check since OCFS2_INLINE_DATA_FL
>     applies to both directories and regular files (Heming Zhao)
>   - Fixed checkpatch.pl warnings
>   - Updated commit message to say "inline data" instead of
>     "inline directory"
> ---
>  fs/ocfs2/inode.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 8340525e5589..1fac457cb04a 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1521,6 +1521,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	/*
> +	 * Validate inline data size. If the inode has inline data,
> +	 * i_size must not exceed the inline data capacity.
> +	 */
> +	if (di->i_dyn_features & cpu_to_le16(OCFS2_INLINE_DATA_FL)) {

Since we've already have a branch to checking OCFS2_INLINE_DATA_FL, why not
fold them together?

Thanks,
Joseph

> +		struct ocfs2_inline_data *data = &di->id2.i_data;
> +
> +		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)le64_to_cpu(di->i_size),
> +					 le16_to_cpu(data->id_count));
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:

