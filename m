Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555701E491C
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 09:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243227; cv=none; b=UV/G6qI/hbiePVzyqbXGmAf719VJLUgvxG69KB1breXp56QOHFS4+zea2VtNQJ6NQEBZ1SgcRWmEqxRLHcX8ecF5sDIf9XmWvv5eVi+X+7dZ2Rkyg7UKeCWK+PfJEiHXA24aBv6eSXqZGTq6+zsLv3yEh+SSIsj9sNCt7rtSPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243227; c=relaxed/simple;
	bh=X3aXrFF7GksVfYHMfE5hPT7U/m5rgFrJX3hmALPtkc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=mPCek5wLeOkJbgLgg1iiPHdpIMEglZHy9IZjdSxDeYxNdMOwxy9j45pWAZwbDLTxBo600oUXy0gMwpyfcxOpvKIjIxOb2T+UFhuM7ZEh0laYpOgJFR8T7ooiJsKTuSTY+550dNAiqXDGt0KlbgM/vQNBtkNh+lzArJQDb7ejHp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NP1MWjhf; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NP1MWjhf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736243214; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hbH6rsC0+5ZYtPmL20ZBcKaqnRgdlkKnheT3CVonFgY=;
	b=NP1MWjhfTmUPIu5DA8ssZYFM+rcikToryUWxXGnmpCvLpCVAV28uY0xPLw0cC2/SzRCJAo4GjIp+yC4NijmFyCvVmvT3ZSZWIbNW1L/FFIVf0I2lDxvl5uwSTOCCFQvJWFXc3mWOj6QtyZ2/8LR+usRCYHEkmSTwp/yd7JkbOAA=
Received: from 30.221.129.26(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNAF0TB_1736243213 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 17:46:54 +0800
Message-ID: <c68084d8-8925-4782-8d40-d6d74a415f97@linux.alibaba.com>
Date: Tue, 7 Jan 2025 17:46:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: mark dquot as inactive if failed to start trans
 while releasing dquot
To: Su Yue <glass.su@suse.com>, akpm <akpm@linux-foundation.org>
References: <20250106140653.92292-1-glass.su@suse.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250106140653.92292-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/6 22:06, Su Yue wrote:
> While running fstests generic/329, the kernel workqueue
> quota_release_workfn is dead looping in calling ocfs2_release_dquot().
> The ocfs2 state is already readonly but ocfs2_release_dquot wants to
> start a transaction but fails and returns.
> 
> =====================================================================
> [ 2918.123602 ][  T275 ] On-disk corruption discovered. Please run
> fsck.ocfs2 once the filesystem is unmounted.
> [ 2918.124034 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:765
> ERROR: status = -30
> [ 2918.124452 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:795
> ERROR: status = -30
> [ 2918.124883 ][  T275 ] (kworker/u135:1,275,11):ocfs2_start_trans:357
> ERROR: status = -30
> [ 2918.125276 ][  T275 ] OCFS2: abort (device dm-0): ocfs2_start_trans:
> Detected aborted journal
> [ 2918.125710 ][  T275 ] On-disk corruption discovered. Please run
> fsck.ocfs2 once the filesystem is unmounted.
> =====================================================================
> 
> The function, ocfs2_release_dquot is much like dquot_release(), which is
> called by ext4 to handle similar situation. So here fix it by marking
> the dquot as inactive like what dquot_release() does.
> 
> Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks sane.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/quota_global.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 2b0daced98eb..2c42966cea20 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -761,6 +761,11 @@ static int ocfs2_release_dquot(struct dquot *dquot)
>  	handle = ocfs2_start_trans(osb,
>  		ocfs2_calc_qdel_credits(dquot->dq_sb, dquot->dq_id.type));
>  	if (IS_ERR(handle)) {
> +		/*
> +		 * Mark dquot as inactive to avoid endless cycle in
> +		 * quota_release_workfn().
> +		 */
> +		clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
>  		status = PTR_ERR(handle);
>  		mlog_errno(status);
>  		goto out_ilock;

