Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0119A23AE62
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 07:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660731; cv=none; b=LiSPsKrJaXzctaeGRt1T6d1gByUW726zbGPDy4pmSKYtu8rPiUUVgEu79K8VWUABt3YAD3m4ngsraUMAmgwDcCq+6IiUrJkTTmQB5/ylE5P5QoO+MtMHOQvJWmbvaQiQpZwnVycBxYdqmyOxgkOmo2X1bFzVWjKkCiVDGGWi9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660731; c=relaxed/simple;
	bh=2R/pKEUIjIouidFuVR2duANV00+r9efanAYO5E8DPOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSm3nQHG1ZODtu4ToZdvMOIPgrAS9r4Qs1ezQNERmdV91RVY+rs2K0NdtGmkPEbhZXEUBEBSb9bccTzwmk4o4mTeeT4rlF01BV/vdJrrXP9taa3hVjcO/NqLKU9J/Jp1hud25kKKEEqi2d2yPSQkctKohwQGaCuv5IhGcxV7LEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iMkNOHWd; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iMkNOHWd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764660716; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Wgv2YhtikMTuW2K0T9pavHrQqsGtCuP/RL4oQz63OdM=;
	b=iMkNOHWdKSTcY1S2oAcdgXbhH6uKzzNCehvVE90KbK+oYKk45f1TdoQC2UvsnFv405Pby81WH8LDx0dEQQl/NRzg/C9jrV3Ys++F90yT8ZRVF/iZV+svWpFW8A4uo7qd1K9ChvJoMm1jAxzmp9HHSZpeHAQRiLkpvGiATX4xEXI=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtvWYIg_1764660715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:31:56 +0800
Message-ID: <250d0d54-a6b0-42b2-a8d3-ebd806316a5c@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:31:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ocfs2: Add ocfs2_emergency_state helper and apply
 to setattr
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 Heming Zhao <heming.zhao@suse.com>,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <8a26b007729e3f3f813f754eda6eed59431502e1.1764643790.git.eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <8a26b007729e3f3f813f754eda6eed59431502e1.1764643790.git.eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 10:54, Ahmet Eray Karadag wrote:
> To centralize error checking, follow the pattern of other filesystems
> like ext4 (which uses `ext4_emergency_state()`), and prepare for
> future enhancements, this patch introduces a new helper function:
> `ocfs2_emergency_state()`.
> 
> The purpose of this helper is to provide a single, unified location
> for checking all filesystem-level emergency conditions. In this
> initial implementation, the function only checks for the existing
> hard and soft read-only modes, returning -EROFS if either is set.
> 
> This provides a foundation where future checks (e.g., for fatal error
> states returning -EIO, or shutdown states) can be easily added in
> one place.
> 
> This patch also adds this new check to the beginning of
> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> (which triggered the original BUG) fail-fast with -EROFS when the
> filesystem is already in a read-only state.
> 
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> ---
> v2:
>  - Introducing new function `ocfs2_is_readonly` to lower the cost
>  - Using unlikely for status check
> ---
> v3:
>  - Fix compilation error (missing semicolon).
> ---
>  fs/ocfs2/file.c  |  6 ++++++
>  fs/ocfs2/ocfs2.h | 18 ++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 21d797ccccd0..253b4f300127 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
>  
>  	/* ensuring we don't even attempt to truncate a symlink */

The above comments is for "if (S_ISLNK(inode->i_mode))".
So it should be move down just before symlink check.

> +	status = ocfs2_emergency_state(osb);
> +	if (unlikely(status)) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	if (S_ISLNK(inode->i_mode))
>  		attr->ia_valid &= ~ATTR_SIZE;
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 6aaa94c554c1..91a861babf74 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -680,6 +680,24 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
>  	return ret;
>  }
>  
> +static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
> +{
> +	int ret;
> +	spin_lock(&osb->osb_lock);
> +	ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
> +	spin_unlock(&osb->osb_lock);
> +
> +	return ret;
> +}
> +
> +static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
> +{
> +	if (ocfs2_is_readonly(osb)) {

The '{' can be eliminated.

Joseph

> +		return -EROFS;
> +	}
> +	return 0;
> +}
> +
>  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
>  {
>  	return (osb->s_feature_incompat &

