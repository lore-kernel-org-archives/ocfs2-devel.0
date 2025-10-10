Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E98616EB42
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 07:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079707; cv=none; b=nFZBlgRAyIgg1C3cZevYVrW+tCw/OWz/FB5LwnWIl9x7ITEt68d9fsa3ZjvHdKWxh0j4ePBCmogKoeh74Ag9ypkn5mDNWNH9dTp+exiFB7bcAUh/LLbPI9EFRngZlnLJ9RvEQPCilLwiYpNABa6UKYbpL/cFmY9t26hJyTZ+O6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079707; c=relaxed/simple;
	bh=b2ErG0qvqA8tQoCTvxi8yHD4lca11UqlJtk09ljmaYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Emxm+TBWFREvwSJgJJLTb+wA5AKO2Zo3jFHtluE+sAjHQBKHogC6ea+g4e2xQV6m6HPsJmUF95+JeaU1FhpcFuE+0RvWU/ERQBvESzQFh/hLyZSDYbDGCYEKniGqJxUaQRm2EqTu5vY2cKwXF+g4m7dovRBqirxnNNXPWC9EO5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aHuJW31D; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aHuJW31D"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760079697; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mXKmbyFX3FA0cJsrVAYB0qCaQXErnYlYAHAHM5ZoNdY=;
	b=aHuJW31DGDK3WBNLcCdauhwuLHg6ojd0PauDMJ9lnqUI0xCJaNi+IYYzan5+tpckqD7EH2/+YelCOMEXpbrlQRlAE7d7i6+x2lAdU5qC9wWovMN86dwZz60O0JY1jo489jkTec8zirSi81awnOLLdnlqTP3tuot7dP7etB4yGy4=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpsVtab_1760079696 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Oct 2025 15:01:36 +0800
Message-ID: <7e7bf269-1e9a-45c5-b8c1-7ead30490956@linux.alibaba.com>
Date: Fri, 10 Oct 2025 15:01:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: annotate flexible array members with
 __counted_by_le()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20251007123526.213150-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251007123526.213150-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/7 20:35, Dmitry Antipov wrote:
> Annotate flexible array members of 'struct ocfs2_extent_list',
> 'struct ocfs2_chain_list', 'struct ocfs2_truncate_log',
> 'struct ocfs2_dx_entry_list', 'ocfs2_refcount_list' and
> 'struct ocfs2_xattr_header' with  '__counted_by_le()'
> attribute to improve array bounds checking when
> CONFIG_UBSAN_BOUNDS is enabled.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/ocfs2_fs.h | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index ae0e44e5f2ad..f7763da5c4a2 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -468,7 +468,8 @@ struct ocfs2_extent_list {
>  	__le16 l_reserved1;
>  	__le64 l_reserved2;		/* Pad to
>  					   sizeof(ocfs2_extent_rec) */
> -/*10*/	struct ocfs2_extent_rec l_recs[];	/* Extent records */
> +					/* Extent records */
> +/*10*/	struct ocfs2_extent_rec l_recs[] __counted_by_le(l_count);
>  };
>  
>  /*
> @@ -482,7 +483,8 @@ struct ocfs2_chain_list {
>  	__le16 cl_count;		/* Total chains in this list */
>  	__le16 cl_next_free_rec;	/* Next unused chain slot */
>  	__le64 cl_reserved1;
> -/*10*/	struct ocfs2_chain_rec cl_recs[];	/* Chain records */
> +					/* Chain records */
> +/*10*/	struct ocfs2_chain_rec cl_recs[] __counted_by_le(cl_count);
>  };
>  
>  /*
> @@ -494,7 +496,8 @@ struct ocfs2_truncate_log {
>  /*00*/	__le16 tl_count;		/* Total records in this log */
>  	__le16 tl_used;			/* Number of records in use */
>  	__le32 tl_reserved1;
> -/*08*/	struct ocfs2_truncate_rec tl_recs[];	/* Truncate records */
> +					/* Truncate records */
> +/*08*/	struct ocfs2_truncate_rec tl_recs[] __counted_by_le(tl_count);
>  };
>  
>  /*
> @@ -796,9 +799,10 @@ struct ocfs2_dx_entry_list {
>  					 * possible in de_entries */
>  	__le16		de_num_used;	/* Current number of
>  					 * de_entries entries */
> -	struct	ocfs2_dx_entry		de_entries[];	/* Indexed dir entries
> -							 * in a packed array of
> -							 * length de_num_used */
> +					/* Indexed dir entries in a packed
> +					 * array of length de_num_used.
> +					 */
> +	struct	ocfs2_dx_entry		de_entries[] __counted_by_le(de_count);
>  };
>  
>  #define OCFS2_DX_FLAG_INLINE	0x01
> @@ -934,7 +938,8 @@ struct ocfs2_refcount_list {
>  	__le16 rl_used;		/* Current number of used records */
>  	__le32 rl_reserved2;
>  	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
> -/*10*/	struct ocfs2_refcount_rec rl_recs[];	/* Refcount records */
> +				/* Refcount records */
> +/*10*/	struct ocfs2_refcount_rec rl_recs[] __counted_by_le(rl_count);
>  };
>  
>  
> @@ -1020,7 +1025,8 @@ struct ocfs2_xattr_header {
>  						    buckets.  A block uses
>  						    xb_check and sets
>  						    this field to zero.) */
> -	struct ocfs2_xattr_entry xh_entries[]; /* xattr entry list. */
> +						/* xattr entry list. */
> +	struct ocfs2_xattr_entry xh_entries[] __counted_by_le(xh_count);
>  };
>  
>  /*

