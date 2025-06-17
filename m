Received: from mail-108-mta187.mxroute.com (mail-108-mta187.mxroute.com [136.175.108.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FD03BBF2
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Jun 2025 02:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750126234; cv=none; b=SmExNW8SXFcJ03rriZoArWyHz5o4MVMnbbgYxUIyqjgnBrWB598CUrUI6OB8XTrcCBiR/jEzThU2OxhHCimeagi2ywolNRVr++eQB9/kx5WFRSOg5zMiCk88GdroYpUvnnEDAmXPVh/jVOqqueeykfkH/aPRghdKjLCvOuZdvBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750126234; c=relaxed/simple;
	bh=/a46r7Mu9WXNJHqQ3QS7z08DmrHsMwu8VrLm5BDG4iI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Wesm9b9a+1WxerKRsZVUKZq7BUu27Uu95iwefQmHep5D7hIj75nYetFqBGmkH7Z3YiQkLAqVZBiqKo2ApZWZtpd8L1z9WECRjQ948mRYP5dkMrRImFmBu6+jzBBcSimiLfxrfcX2DTRHYqJxbLwTVAP35pmAwVDRiwnh+NxtIwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=LQSIL0mb; arc=none smtp.client-ip=136.175.108.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="LQSIL0mb"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta187.mxroute.com (ZoneMTA) with ESMTPSA id 1977ba244da0008631.007
 for <ocfs2-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 17 Jun 2025 02:05:21 +0000
X-Zone-Loop: 5e3437f2a263862f93df6fbff2a67c69d7b3474f42cb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:
	From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=BdQV0BPArgBNN0b2VqLsIkjqYBvc0CBsoE7fNjAbCMw=; b=LQSIL0mbjOel
	sBA2SZ1EKT9mLJFyJ3/GaxLHKSS3KHN4F8Q3c6fnSfO3VnTkp1qybfhDrJsmreAr34u0/9LTjsW6j
	bZJ135NZi6MCfRk0P8txIJFv50tbQY5efAMC0C9+dU83tjH+9LDUPvDyJ8V68UzU3x2SN5ErXNs0g
	gpWg2nlDhkVEpCIE7itdMlGRRGQcO8Nl0cyqWC7nSA5sFchyNG+Rv51lk1fZqeesJD6nJcczZ/v1w
	NTOOvqTqU0QCEuYmLNBkn7OxpAl09RpqPKLamMoy3vQ5E8YCI2tsz/cEGGtgRhyriIIwosLa0j1ct
	YGSTJjExsIZllayGExOoug==;
From: Su Yue <l@damenly.org>
To: Long Li <leo.lilong@huawei.com>
Cc: <mark@fasheh.com>,  <jlbec@evilplan.org>,
  <joseph.qi@linux.alibaba.com>,  <ocfs2-devel@lists.linux.dev>,
  <yangerkun@huawei.com>,  <lonuxli.64@gmail.com>
Subject: Re: [PATCH] ocfs2: remove redundant NULL check in rename path
In-Reply-To: <20250617012534.3458669-1-leo.lilong@huawei.com> (Long Li's
	message of "Tue, 17 Jun 2025 09:25:34 +0800")
References: <20250617012534.3458669-1-leo.lilong@huawei.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Tue, 17 Jun 2025 10:05:11 +0800
Message-ID: <qzzjxgvc.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Tue 17 Jun 2025 at 09:25, Long Li <leo.lilong@huawei.com> 
wrote:

> The code checks newfe_bh for NULL after it has already been 
> dereferenced
> to access b_data. This NULL check is unnecessary for two 
> reasons:
>
> 1. If ocfs2_inode_lock() succeeds (returns >= 0), newfe_bh is 
> guaranteed
>    to be valid.
> 2. We've already dereferenced newfe_bh to access b_data, so it 
> must be
>    non-NULL at this point.
>
> Remove the redundant NULL check in the 
> trace_ocfs2_rename_over_existing()
> call to improve code clarity.
>
> Signed-off-by: Long Li <leo.lilong@huawei.com>
>

Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>  fs/ocfs2/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 99278c8f0e24..26bc59c3a813 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1452,8 +1452,8 @@ static int ocfs2_rename(struct mnt_idmap 
> *idmap,
>  		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
>
>  		trace_ocfs2_rename_over_existing(
> -		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
> -		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
> +		     (unsigned long long)newfe_blkno, newfe_bh,
> +		     (unsigned long long)newfe_bh->b_blocknr);
>
>  		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 
>  1)) {
>  			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
