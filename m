Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369AB1E2616
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243149; cv=none; b=Bt4917W21meMtpB1YF/9ZNwjhoZGGz+VvSQNUJZsKJPInapgo8JSL7eJJ+GFy95VYsh4yP1tiIYlJBBVW9m2C3XjEaQN40QqmaFabF8FxTHXldpf99acN0edsIoMHBtr03oCAyemTDP/YJ5IjA5s6/gknyzwIfQmDgVmPZkHtmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243149; c=relaxed/simple;
	bh=X3aXrFF7GksVfYHMfE5hPT7U/m5rgFrJX3hmALPtkc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=A/zPdeqZxQZDaabNeFainUtc8+QV0XMcvGPd8LNwJG0L8GkWzZOXBYapuCP0Lg6ovgdU6wIWo2hOtOUQirjJpRn1hVtx+37NuQ+JKHKzzzS3ivhiWFCr8c5nrYJIq8NfH8nsr+PTK/B1qMi/DCb2DS3JDFi7Ac4R91XJJHYcetA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=D/8Kct6r; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="D/8Kct6r"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736243141; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hbH6rsC0+5ZYtPmL20ZBcKaqnRgdlkKnheT3CVonFgY=;
	b=D/8Kct6r2pEs0kjlKnA20fnYZtbcx3vX4XdDzXVpOHCr/OZgUGuhRKQ8EpLNdTrG3129uoI3cPSD5Pi4xbvYOBe2qmsrjm9pZaAYN9rtHGMNuov37hHf1GSjqwT9gLXtZlpd4djEKqQtJ7Te/wryBaGLD92qOPjEcmWMsmbFXeU=
Received: from 30.221.129.26(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNAF05Q_1736243140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 17:45:40 +0800
Message-ID: <f73c1db0-0199-4fc0-a513-2274a1884038@linux.alibaba.com>
Date: Tue, 7 Jan 2025 17:45:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: mark dquot as inactive if failed to start trans
 while releasing dquot
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev
References: <20250106140653.92292-1-glass.su@suse.com>
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

