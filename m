Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A325632;
	Mon, 16 Sep 2024 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726503413; cv=none; b=SZELmhEIiP2eHY7JHUTDF6ccOwxlG7GAJzpH65lNaZOMoqdEzdmRPcUwnBhFpo0MluCJT/wMrvWaIKPrrN7TOqgvueBYddyOWNniQEKwa72orWNfvtJ1YM4/44BXpMCx1f80zn0VJb1vlLwK65Ryv9jS/DzH11RAJ/CMoaRqRJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726503413; c=relaxed/simple;
	bh=2dsZBfxZCUqU/13rLMlr/WEcj9x8SDSF+0rUunk94SA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=I26aFXYYg6m57TrPV+apDpQiX3GDTnhJ9wZ1hVm4gPvBHbFz6KrlS1Ytv9W+yk97Ifk8CHmYdZxjWoXnxdXV/bAoj1bhJoerIkoOshffMQ+/WFods07pfTW0A106Pq/pCDLJVDIPTQo7umKaT8Wlm+TnFeV7hqPnA1Pwn0S589k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fF3GdZ9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fF3GdZ9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D052AC4CEC4;
	Mon, 16 Sep 2024 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726503412;
	bh=2dsZBfxZCUqU/13rLMlr/WEcj9x8SDSF+0rUunk94SA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fF3GdZ9VPlwX4lesAiC7ZTq+3jJVRReGiVPIE5MBjJjMuHp9YbwAPzXF2tTkLFElo
	 TJgqOzPMiGiU97WBpr6fxBRv+DHZ2o1/XXWoLwJR+lgADYSfBC58Xff6kkpwVK6KyW
	 2mwInN+pTnD6WfCSXT+gQ8kDot3Qefo6x5a7LMAY=
Date: Mon, 16 Sep 2024 09:16:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Cc: joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, ocfs2-devel@lists.linux.dev,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC V4 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Message-Id: <20240916091647.dbcca9d29f081c7a4c5cd2ea@linux-foundation.org>
In-Reply-To: <20240912064720.898600-1-gautham.ananthakrishna@oracle.com>
References: <20240912064720.898600-1-gautham.ananthakrishna@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Sep 2024 06:47:20 +0000 Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com> wrote:

> One of our customers reported a crash and a corrupted ocfs2 filesystem.
> +++ b/fs/ocfs2/refcounttree.c
> @@ -25,6 +25,7 @@
>  #include "namei.h"
>  #include "ocfs2_trace.h"
>  #include "file.h"
> +#include "symlink.h"
>  
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> @@ -4155,8 +4156,9 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>  	int ret;
>  	struct inode *inode = d_inode(old_dentry);
>  	struct buffer_head *new_bh = NULL;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  
> -	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
> +	if (oi->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
>  		ret = -EINVAL;
>  		mlog_errno(ret);
>  		goto out;
> @@ -4182,6 +4184,26 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>  		goto out_unlock;
>  	}
>  
> +	if ((oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) &&
> +	    (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> +		/*
> +		 * Adjust extent record count to reserve space for extended attribute.
> +		 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> +		 */
> +		struct ocfs2_inode_info *new_oi = OCFS2_I(new_inode);
> +
> +		if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> +		    !(ocfs2_inode_is_fast_symlink(new_inode))) {
> +			struct ocfs2_dinode *new_di = new_bh->b_data;
> +			struct ocfs2_dinode *old_di = old_bh->b_data;

fs/ocfs2/refcounttree.c: In function '__ocfs2_reflink':
fs/ocfs2/refcounttree.c:4190:55: error: initialization of 'struct ocfs2_dinode *' from incompatible pointer type 'char *' [-Werror=incompatible-pointer-types]
 4190 |                         struct ocfs2_dinode *new_di = new_bh->b_data;
      |                                                       ^~~~~~
fs/ocfs2/refcounttree.c:4191:55: error: initialization of 'struct ocfs2_dinode *' from incompatible pointer type 'char *' [-Werror=incompatible-pointer-types]
 4191 |                         struct ocfs2_dinode *old_di = old_bh->b_data;
      |                                                       ^~~~~~
cc1: all warnings being treated as errors

I could just add the typecasts, but that doesn't give me a tested patch :(

