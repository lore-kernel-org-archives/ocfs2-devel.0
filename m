Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C05A21FF2A
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 01:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779068185; cv=none; b=sE4l837ItEF3oIE73GIDavqjsRMed7E1XUcojLL4tYXC0VBGxcKsdafLwVrvfCVSXTReHfAhhAR+mDHzSPeqZOPwSxHduY+rY0elM1ZA1rw1yO55E+n4SlrDRlbvhr9PO3VQQQZ95gfOLfwyuY7n0IS6Ots/+v38TwKV69+iOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779068185; c=relaxed/simple;
	bh=FbYl9M6eWLcSgbjWMfgKB/pCsDcWa1SAWdbuNihsjzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HobBuWS6VR9xs0EsmyD2pOtZmgtlCI1sq/XhGsmwgLJFh2XVieev5+4f/KlmF+sWfugu4ffGeLu3RZe1UNLJVmh94hSMROS8PnIm7coZUArBwlxTD7yJPzxOy1iMIid1BFdkg89Vc5fO04bcyLnvQes7y+zgpkhL9y1oqLFG5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vQDQqg5R; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vQDQqg5R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779068181; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AxgQyJ8Yko2JghoAfrC4dM+Ndui7Eu/mYBppVRP2RqA=;
	b=vQDQqg5R12tC2JwhMyYftYovSpwgfAVCSLSD9Ej5FZgDDmHyFfACKa4d5s8dag6hqFpwM/s72OWlK8I7YbFUZvyK99lT7FXLbH1Gl02Omx6DJDCuugWO1wrdQt9mZ5oVW/9yrknOXJZ9zIiohnfk5YmAkZ+nmYzk2wTv2MLLRks=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X32gCfm_1779068178;
Received: from 30.221.129.172(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X32gCfm_1779068178 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 09:36:19 +0800
Message-ID: <318beeb0-0f44-4d39-b2d3-dd0dd570ef0f@linux.alibaba.com>
Date: Mon, 18 May 2026 09:36:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ocfs2: reject dinodes with non-canonical i_mode type
 or stray bits
To: Michael Bommarito <michael.bommarito@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
 <20260517111015.3187935-2-michael.bommarito@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260517111015.3187935-2-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/17/26 7:10 PM, Michael Bommarito wrote:
> ocfs2_validate_inode_block() currently accepts any 16-bit i_mode
> value as long as i_mode is non-zero.  ocfs2_populate_inode() then
> copies that mode verbatim into inode->i_mode and dispatches on
> i_mode & S_IFMT to the file/dir/symlink/special_file iops; any
> unrecognised type falls through to ocfs2_special_file_iops and
> init_special_inode(), which interprets id1.dev1.i_rdev as a
> device number.
> 
> The result is that anything able to forge or corrupt an inode
> block (a hostile cluster peer with raw write access to the
> shared LUN, a privileged user mounting an attacker-supplied
> image, on-disk corruption) can publish an in-core inode whose
> type bits do not name a POSIX file type, or whose permission
> bits carry bytes outside S_IFMT|07777.  Both shapes propagate
> into VFS-visible state that downstream code paths assume is
> well-formed.
> 
> Reject early in the validator:
> 
>   - mode bits outside S_IFMT|07777
>   - S_IFMT values that are not one of S_IFREG, S_IFDIR, S_IFLNK,
>     S_IFCHR, S_IFBLK, S_IFIFO, S_IFSOCK
> 
> mkfs.ocfs2 and the kernel only ever produce these seven types
> plus the standard permission, setuid/setgid/sticky bits; an
> on-disk i_mode outside this envelope is structurally malformed
> regardless of how it got there.
> 
> Validated against the existing inline_data, refcount, and
> chain-list checks: this hardening fires before any of them and
> does not perturb their behaviour for well-formed inodes.
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index a510a0eb1adcc..fb592bf3e5f31 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1494,6 +1494,45 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Reject dinodes whose i_mode does not name one of the seven
> +	 * canonical POSIX file types, or whose mode carries bits outside
> +	 * S_IFMT | 07777.  ocfs2_populate_inode() copies i_mode verbatim
> +	 * into inode->i_mode and then dispatches via switch (mode & S_IFMT)
> +	 * to file/dir/symlink/special_file iops; an unrecognised type
> +	 * falls into ocfs2_special_file_iops with init_special_inode(),
> +	 * which interprets i_rdev.  Constrain the type byte here so the
> +	 * dispatch only ever sees a value mkfs.ocfs2 / VFS can produce.
> +	 */
> +	{
> +		u16 mode = le16_to_cpu(di->i_mode);
> +
> +		if (mode & ~(S_IFMT | 07777)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: mode 0%o has bits outside S_IFMT|07777\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 mode);
> +			goto bail;
> +		}
> +
> +		switch (mode & S_IFMT) {
> +		case S_IFREG:
> +		case S_IFDIR:
> +		case S_IFLNK:
> +		case S_IFCHR:
> +		case S_IFBLK:
> +		case S_IFIFO:
> +		case S_IFSOCK:
> +			break;
> +		default:
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 mode);
> +			goto bail;
> +		}
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  

