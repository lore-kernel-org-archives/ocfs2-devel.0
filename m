Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA32391855
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jun 2026 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781229540; cv=none; b=Ymux4eKyy+RCjTPhp8oWjA265adSu9ocxjVBnh/SkIzSmNKans5QfDYHLmnM8bwtWdbXAg8lhee2krL+gVOR8pwop2aWzfuWK1VjveRZ82PtquO04KTadXn1eqNVMI55IYfiq3roAVEbGeIWP7/dTowMYsykDmYf0zXSL47Lzfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781229540; c=relaxed/simple;
	bh=c6hISeHvjvxPr3utueM+m1NEq8bBe3UK7xyKJp024NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gP5yOkAvaak8zedaEnvesqN0FxSE3lS+MMSoRzEfTpn7n/j++8ZGs//b9sOyp6x7LOQ1XHLmuwtf+T4F9s8PG5bsm6BZUt0Bg8Fd3D/cE8Krgm16TzCxTSSYApSgTkdnK5Ziibh9j6KeKgiha3RbHBFnG26Q+NkDXiZ5rLLtXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V7PKlT/a; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V7PKlT/a"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781229531; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1fvoNI4kS4/YczOHdz2YUa16gfFvN7cmANWFGP2/GvE=;
	b=V7PKlT/a6Jv9km5ZWL9y5bmP8k+d4TUtG/wz7z9zhVKZ+aj0WgReUpTH7KqMfHU0+nt3WqkwaTXhIJzYMfBDTVER5WJRl4HP50uvAjzfzWOSfIsN1QcI8nr9tzESiI2qCU6w4u4Fb54jHZ/mDN8XWZcYTIq4x8awk3ZPL2GqXCU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X4fKLdT_1781229528;
Received: from 30.221.145.30(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4fKLdT_1781229528 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 09:58:49 +0800
Message-ID: <ccb62980-f0a7-4233-900e-98a57b7cb49b@linux.alibaba.com>
Date: Fri, 12 Jun 2026 09:58:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: avoid moving extents to occupied clusters
To: Kyle Zeng <kylebot@openai.com>, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, outbounddisclosures@openai.com,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260611213510.16956-1-kylebot@openai.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260611213510.16956-1-kylebot@openai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/12/26 5:35 AM, Kyle Zeng wrote:
> For non-auto OCFS2_IOC_MOVE_EXT operations, userspace supplies a
> physical me_goal.  ocfs2_move_extent() initializes new_phys_cpos from
> that goal and expects ocfs2_probe_alloc_group() to replace it with a
> free run in the target block group.
> 
> The probe currently leaves *phys_cpos unchanged if the scan reaches the
> end of the group without finding a free run.  An occupied goal at the
> last bit can therefore survive the probe and be passed to
> __ocfs2_move_extent(), which copies file data into a cluster still owned
> by another inode before the bitmap is updated.
> 
> When the probe does find a free run, it also subtracts move_len from the
> ending bit.  The start of an N-bit run ending at i is i - N + 1, so the
> current calculation can report the bit immediately before the free run.
> 
> Clear *phys_cpos before scanning and use the correct free-run start.
> Callers already treat a zero result as -ENOSPC, so failed probes no
> longer continue with an occupied caller-controlled goal.
> 
> Fixes: e6b5859cccfa ("Ocfs2/move_extents: helper to probe a proper region to move in an alloc group.")
> Fixes: 236b9254f8d1 ("ocfs2: fix non-auto defrag path not working issue")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/move_extents.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index c53de4439d93..ad1678ee7cc4 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -534,6 +534,8 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
>  	u32 base_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
>  						 le64_to_cpu(gd->bg_blkno));
>  
> +	*phys_cpos = 0;
> +
>  	for (i = base_bit; i < le16_to_cpu(gd->bg_bits); i++) {
>  
>  		used = ocfs2_test_bit(i, (unsigned long *)gd->bg_bitmap);
> @@ -555,7 +557,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
>  			last_free_bits++;
>  
>  		if (last_free_bits == move_len) {
> -			i -= move_len;
> +			i = i - move_len + 1;
>  			*goal_bit = i;
>  			*phys_cpos = base_cpos + i;
>  			break;

