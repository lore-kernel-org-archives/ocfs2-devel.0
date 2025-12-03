Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E542D4807
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 08:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764750341; cv=none; b=ACmQo8xPnX1dypBdm+hle9HMVWK8DWc+I2+ox0+ThAfleOa6fx7/vlK5ryRZ3jKoNw2Nmgo7cKnP7eH2TFVklpwOMcUbNg9gQ3z8MC/f6hjGm21/QMDalb3c2VD6y/rAXCcL+rPzBs7Jve90WxWyDjYLivvnlMLb9htZghy7QTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764750341; c=relaxed/simple;
	bh=nuBpsrJWkZQHd3tXLeIT/+k2AqpTN1kBFcBdcQ2dTCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWLXi6Gy1FGGQxWxrs8A5nYSWMvGcRUdZTYxEeqLgihpM7lh0vwMjg159f4+dic3XXy8WDxg5FPdCByJD+JQ0Vz1YBONIRmoe2GNBtP9QxP4TlCdkx1xCWeGzOrEuFWOlidHSWavKDkzBSAHvyCwCrf+W5Ob43lolxmIotd/3yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=neXBC9gM; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="neXBC9gM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764750331; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lVoWbQOh35MC5sTCdeKx6He6jasgmR1Hybu/2i4gRF8=;
	b=neXBC9gMpnoKmcg6SsbmKY4SQKDzYSNetp/id+LjiElUFoglr9pHpbCKI1B0kLfzvE1oZHgcI0phwSIT7KO0JYiKU9quzpUQySvQtDrgBqHhY2z7HwRWYtaKxDDk86MY1h74MY6ne4gxbftbDaMexUnUPHVY0OhLCavqX9s0JhM=
Received: from 30.221.128.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wu-bw.E_1764750330 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 16:25:30 +0800
Message-ID: <ff4cfa59-f5f1-47dd-8ee4-606e7201bc4e@linux.alibaba.com>
Date: Wed, 3 Dec 2025 16:25:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ocfs2: Add ocfs2_emergency_state helper and apply
 to setattr
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 Heming Zhao <heming.zhao@suse.com>,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <cover.1764728893.git.eraykrdg1@gmail.com>
 <e9e975bcaaff8dbc155b70fbc1b2798a2e36e96f.1764728893.git.eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <e9e975bcaaff8dbc155b70fbc1b2798a2e36e96f.1764728893.git.eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/3 11:34, Ahmet Eray Karadag wrote:
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
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2:
>  - Introducing new function `ocfs2_is_readonly` to lower the cost
>  - Using unlikely for status check
> ---
> v3:
>  - Fix compilation error (missing semicolon).
> ---
> v4:
>  - Fix code alignment
> ---
>  fs/ocfs2/file.c  |  6 ++++++
>  fs/ocfs2/ocfs2.h | 18 ++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 21d797ccccd0..ddca292944d7 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1136,6 +1136,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  				attr->ia_valid & ATTR_GID ?
>  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
>  
> +	status = ocfs2_emergency_state(osb);
> +	if (unlikely(status)) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	/* ensuring we don't even attempt to truncate a symlink */
>  	if (S_ISLNK(inode->i_mode))
>  		attr->ia_valid &= ~ATTR_SIZE;
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 6aaa94c554c1..7b50e03dfa66 100644
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
> +	if (ocfs2_is_readonly(osb))
> +		return -EROFS;
> +
> +	return 0;
> +}
> +
>  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
>  {
>  	return (osb->s_feature_incompat &

