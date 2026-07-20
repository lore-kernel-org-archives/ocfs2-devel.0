Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDAB395AC1
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 03:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784518207; cv=none; b=XtbDOA0I12UCkHwIiAAsvB5kufNWJyEEOoThwhGycNiorV3nlWdUWE83zRWJ8MFS5VqzV62Juyrmu0/q/pyaLugmzeDwDd6hMVphfkKDkaDwuN+6xECZgWMlC8WZk4rwhxM8RZ2uxRV6p9tNVI6AkDFNCNSs5tVdd9bvQGnx9HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784518207; c=relaxed/simple;
	bh=WBwR1x/AgySTRGoCs7cqNEMzr0STGf9y+8WbKYg/8TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEjvZxIOzNk5/xbypNmvGMeLR+OOtXqfs0xNRHGlJDG9cQgCs2xcQJmrAl+VrX14FyEcXAgOw+2tHhVxmzm+sjoTb5VHMe45zEem5TQpTXI7CitQY2r3MLnLJDrHvEhzRLiN+H3LeMZ6TqlZLNkuWmbwdf+588he8KNgHK1gli8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Mhu8Vx/d; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Mhu8Vx/d"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784518197; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iVIJn8TH8YnLTF6YzCMiEtQHIk6NR7odP5UPUmkVhZA=;
	b=Mhu8Vx/d8b+cA00ivNpaMrGTa/FreNSTe7hrmJ0A3bWLOZb0HdleRgLKTyLu/n0vmhAY5Ka08d4AGpdgLDSS3bficUsMgz1J1XWfvuX+9H+jzZk2taITIwKEr+0qtBco4sNaYSw87TYRkzNwft0Dj3CmLh2FcYulGRZJqgFTA6w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7NMv8L_1784518195;
Received: from 30.166.0.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7NMv8L_1784518195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 11:29:56 +0800
Message-ID: <30393fd0-6e0a-41c0-a1df-41bfee16dc07@linux.alibaba.com>
Date: Mon, 20 Jul 2026 11:29:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate directory-index entry counts when reading
 metadata
To: Doruk Tan Ozturk <doruk@0sec.ai>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Kees Cook <kees@kernel.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20260713205625.92391-1-doruk@0sec.ai>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260713205625.92391-1-doruk@0sec.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/14/26 4:56 AM, Doruk Tan Ozturk wrote:
> ocfs2_validate_dx_leaf() and ocfs2_validate_dx_root() check the ECC and
> signature of an indexed-directory block before it reaches higher-level
> callers, but neither validator bounds the ocfs2_dx_entry_list counts
> against the capacity of the block that holds them.
> 
> ocfs2_dx_dir_search() then walks
> 
> 	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++)
> 		dx_entry = &entry_list->de_entries[i];
> 
> over de_num_used entries with no bounds check.  entry_list is either
> dx_leaf->dl_list (from ocfs2_read_dx_leaf) or, for an inline root,
> dx_root->dr_entries.  A crafted on-disk image can set de_num_used (and
> de_count, which is the __counted_by_le() bound of de_entries) to 0xffff
> and make the walk read far past the end of the 4KB metadata block, giving
> a slab out-of-bounds read reachable from any path lookup, stat() or open()
> on an indexed directory once the image is mounted.
> 
> Commit 775c17386a6f ("ocfs2: validate dx_root extent list fields during
> block read") already bounds dr_list for the non-inline dx_root, but left
> the inline dr_entries path and the dx_leaf dl_list unchecked.  Add the
> same read-time validation for both entry lists: de_count must equal the
> capacity of the block (ocfs2_dx_entries_per_leaf()/per_root()) and
> de_num_used must not exceed de_count, rejecting corrupted metadata with
> -EFSCORRUPTED before ocfs2_dx_dir_search() can walk an out-of-range entry
> array.
> 
> de_count is always written as exactly the block capacity when a leaf or
> inline root is formatted, so the equality check does not reject any
> valid image.
> 
> Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
> Fixes: 4ed8a6bb083b ("ocfs2: Store dir index records inline")
> Cc: stable@vger.kernel.org
> Found by 0sec automated security-research tooling (https://0sec.ai).
> Assisted-by: 0sec:claude-opus-4-8
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dir.c | 45 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index baf3eca7b4e4..fcc3721cbe34 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -624,6 +624,28 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
>  					  le16_to_cpu(el->l_count));
>  			goto bail;
>  		}
> +	} else {
> +		struct ocfs2_dx_entry_list *dl_list = &dx_root->dr_entries;
> +
> +		if (le16_to_cpu(dl_list->de_count) !=
> +		    ocfs2_dx_entries_per_root(sb)) {
> +			ret = ocfs2_error(sb,
> +					  "Dir Index Root # %llu has invalid de_count %u (expected %u)\n",
> +					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
> +					  le16_to_cpu(dl_list->de_count),
> +					  ocfs2_dx_entries_per_root(sb));
> +			goto bail;
> +		}
> +
> +		if (le16_to_cpu(dl_list->de_num_used) >
> +		    le16_to_cpu(dl_list->de_count)) {
> +			ret = ocfs2_error(sb,
> +					  "Dir Index Root # %llu has invalid de_num_used %u (de_count %u)\n",
> +					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
> +					  le16_to_cpu(dl_list->de_num_used),
> +					  le16_to_cpu(dl_list->de_count));
> +			goto bail;
> +		}
>  	}
>  
>  bail:
> @@ -663,10 +685,25 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
>  		return ret;
>  	}
>  
> -	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
> -		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
> -				  7, dx_leaf->dl_signature);
> -	}
> +	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf))
> +		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
> +				   7, dx_leaf->dl_signature);
> +
> +	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
> +	    ocfs2_dx_entries_per_leaf(sb))
> +		return ocfs2_error(sb,
> +				   "Dir Index Leaf # %llu has invalid de_count %u (expected %u)\n",
> +				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
> +				   le16_to_cpu(dx_leaf->dl_list.de_count),
> +				   ocfs2_dx_entries_per_leaf(sb));
> +
> +	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >
> +	    le16_to_cpu(dx_leaf->dl_list.de_count))
> +		return ocfs2_error(sb,
> +				   "Dir Index Leaf # %llu has invalid de_num_used %u (de_count %u)\n",
> +				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
> +				   le16_to_cpu(dx_leaf->dl_list.de_num_used),
> +				   le16_to_cpu(dx_leaf->dl_list.de_count));
>  
>  	return ret;
>  }

