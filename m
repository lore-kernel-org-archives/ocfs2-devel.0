Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F451282F3A
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779679603; cv=none; b=FLvP0Ua5GAF/0Gn30y4IffHX6o+sZQNdnIQ+VGBLuv8f+xKVWZtOB1HrPfek6ww8V+hROQCq7yfQElwY9YuVE+lDZ2ajGwEczkHyrVd2je2HEJllAYAUIO0iR9Lnfob/VB1MomRq+TvrLdN8clYJB4PBViiOF1naQ/3NrgFOXdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779679603; c=relaxed/simple;
	bh=JJuMHBL6HK6FlEAuLoZ2ze6AbUk2IzDt7MlH3E7hYeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THiZH2W+9c78isoahImBf+UzdLLvfY2GuxNLscZhIK+zzRxCx650H5gCmMXlRLHOJrBJemW0LOWNIwXkKbXDduCxxnVb4+0tImGTb4Ecut7HOKzDJWhY8dnqfveSYtZBFUqpyXkfNuBpcWiJk/QhjmUH0clEJaFGXGADRT6TmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MobTBfFW; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MobTBfFW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779679598; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vd2YpzNXD0c1l9Y8LUW9vTWPL43dVZfichQkJkcrAs8=;
	b=MobTBfFWzLfR+WQzWIVfA153x7Mnxb2DfZsD/1lU3hEwd2JN2dikuKf/OJR2qEzg/zH9Nv8Jx43mCopSyLlexYVTV9uu8jO54nbbiwGPjT1fK7OHf3qzZ73QpItdVtphhq7OfbITDjPe3dtCcNB0V9bNEQcBWF2xIul6M0fRjx8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3U4UNV_1779679596;
Received: from 30.221.145.59(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3U4UNV_1779679596 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 11:26:37 +0800
Message-ID: <5095d804-41e9-4803-bc81-21197750161e@linux.alibaba.com>
Date: Mon, 25 May 2026 11:26:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: rebase copied fsdlm LVB pointers in
 locking_state
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260524110749.1416771-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260524110749.1416771-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/24/26 7:07 PM, Zhang Cen wrote:
> value under ocfs2_dlm_tracking_lock and later formats that copy in

Seens it is cut off at the beginning?

> ocfs2_dlm_seq_show(). That is fine for the inline fields, but the
> userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr. Once
> the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
> points into the original lockres owner, so teardown can free that
> 

This is also incomplete.

> Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
> LVB. The seq snapshot already carries the inline LVB storage reserved in
> without borrowing the original lockres lifetime.
> 
> The buggy scenario involves two paths, with each column showing the order
> within that path:
> 
> locking_state reader:                  lockres teardown:
> 1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
>    copies struct ocfs2_lock_res           teardown reaches
> 2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
>    the copied row                      2. the lockres is removed from the
> 3. ocfs2_dlm_lvb() follows the            tracking list
>    copied sb_lvbptr                   3. the owner frees the original
>                                           lockres container
> 
> Validation reproduced this kernel report:
> KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
> RIP: 0033:0x7f8ec4b1e29d
> The buggy address belongs to the object at ffff88810a1e0800 which belongs
> 

And here.

Thanks,
Joseph

> Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> v2:
> Document the introducing fsdlm stackglue commit.
> 
>  fs/ocfs2/dlmglue.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7283bb2c5a31..a23dd8f86c89 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3134,6 +3134,22 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>   *	- Add last pr/ex unlock times and first lock wait time in usecs
>   */
>  #define OCFS2_DLM_DEBUG_STR_VERSION 4
> +
> +/*
> + * The debug iterator snapshots lockres by value, so a userspace-stack LVB
> + * pointer copied from the original lockres must be rebased to the copied
> + * lksb before the dump walks the raw bytes.
> + */
> +static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
> +{
> +	if (!ocfs2_stack_supports_plocks())
> +		return;
> +
> +	if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
> +		lockres->l_lksb.lksb_fsdlm.sb_lvbptr =
> +			(char *)&lockres->l_lksb + sizeof(struct dlm_lksb);
> +}
> +
>  static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
>  {
>  	int i;
> @@ -3191,6 +3207,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
>  		   lockres->l_blocking);
>  
>  	/* Dump the raw LVB */
> +	ocfs2_dlm_seq_rebase_lvb(lockres);
>  	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>  	for(i = 0; i < DLM_LVB_LEN; i++)
>  		seq_printf(m, "0x%x\t", lvb[i]);

