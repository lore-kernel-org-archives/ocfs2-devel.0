Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145C53CC9F2
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990320; cv=none; b=BHL56sXLu1vbuY/g6LbFJOA97hoWURvq3/inM6WxDCtX1KrFdCjnJ6sj1q30P5ltXQSS2iFOJJohtGH4dgbnOMZnIizz6WcFcLJdTtebU6dmNOQigSS3MUshE5rLmFTJd4pZ5Q1o8Oj5zxpCpk8VWhXMaeWVFt30i3zxxFIABhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990320; c=relaxed/simple;
	bh=biQpjthCvlXeKmz1mWOxTqPWGh1TCemCQtNv7BEoYUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VJYjQXeG292vbn8JeogKqtUiMd+18UBNByQFa2SYhz2YVZT4rNcHZ77NRqT7O7bxAKUJ91f5OnzTWE+AjrQvvUBXgz08KC4U86zWE1Stxwd1C1xMyqxPZ9T6Xpt8adMwz3/hC92MJydxKbxz46IfgBrnZHXXQqSNRd0XBkOtvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Po7+BmC5; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Po7+BmC5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782990316; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aPpetkLAejI36a0NzYxY4PPmnsZ9JXsEG8/0GhVBxsU=;
	b=Po7+BmC55N4CwUK/4GTV/M4AeNNpGnId9O7Y7usYL8+CK8OWc3w8S4oYHpNhclD374dxbvA7Pei2HbRcBZutw4ahLzpz65LIHGqHkjrtLzfYsZKzpVFn68O+imEMTFMNBxBXYlm961a6tSssAoGBU8tOJIQ1d4b83X+K05Zuzko=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X6EXD3x_1782990315;
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6EXD3x_1782990315 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jul 2026 19:05:16 +0800
Message-ID: <c0498d59-fb5a-4f33-a989-5b23e38e3bd4@linux.alibaba.com>
Date: Thu, 2 Jul 2026 19:05:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate lengths in dlm_mig_lockres_handler
To: hexlabsecurity@proton.me, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 Kurt Hackel <kurt.hackel@oracle.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
 <20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/29/26 1:01 PM, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> A node receiving a DLM_MIG_LOCKRES message trusts several fields of the
> peer-supplied dlm_migratable_lockres without validation.  num_locks and
> lockname_len are bounded only on the sending side, and the message is
> never checked to actually carry num_locks migratable_lock entries.  As a
> result dlm_process_recovery_data() walks mres->ml[0..num_locks) past the
> kmalloc(data_len) copy of the message (an out-of-bounds read that ends in
> a BUG_ON panic), and dlm_init_lockres() copies lockname_len bytes into the
> fixed 32-byte o2dlm_lockname slab object (a heap out-of-bounds write).
> Both are reachable by any node in the domain.
> 
> Validate these fields right after dlm_grab(), before anything uses them --
> including the not-joined error path, which already prints mres->lockname
> with the unbounded lockname_len as a %.*s precision.  Reject the message
> unless lockname_len <= DLM_LOCKID_NAME_MAX, num_locks <=
> DLM_MAX_MIGRATABLE_LOCKS (the bound the sender already asserts), and the
> payload is large enough to hold the claimed locks.  Conforming recovery
> and migration messages are unaffected.
> 
> Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 128872bd945d..14d4c7c3eebd 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1357,6 +1357,15 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  	if (!dlm_grab(dlm))
>  		return -EINVAL;
>  
> +	if (mres->lockname_len > DLM_LOCKID_NAME_MAX ||
> +	    mres->num_locks > DLM_MAX_MIGRATABLE_LOCKS ||
> +	    be16_to_cpu(msg->data_len) < struct_size(mres, ml, mres->num_locks)) {
> +		mlog(ML_ERROR, "%s: invalid lockres migration message from %u\n",
> +		     dlm->name, mres->master);
> +		dlm_put(dlm);
> +		return -EINVAL;
> +	}
> +
>  	if (!dlm_joined(dlm)) {
>  		mlog(ML_ERROR, "Domain %s not joined! "
>  			  "lockres %.*s, master %u\n",
> 

