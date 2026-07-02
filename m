Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C27B23EA94
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990190; cv=none; b=LXdB45LYYJVzVRoISmrb/O24zccKAl3T4nvHjKE2ii6hufBAI6miyhL6E/e6jxvSVo/IvbihLd1SYS6SctYKuCOh6r1VQCN6NzvIaE2Bn2U5vfGKFAJDzPdL3NCcaFzbLsAthq1boIqba16OA6DnyQzjJyaU6uGMIBe6DxMx1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990190; c=relaxed/simple;
	bh=r/xC86ceC0IQtBG74gWu/g4wbDKnLatgAano1UzIH0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n56HeXuL18k3Kcxz4dwtaoM4K0BKDuXmvBW3EhQ3rrJgQ2XG9pmBlIFhRAQH6A2+o3R12hTxXOIwRcEoZgPhQqwiP/UUTyBNTwt0bDs5lsftcV0xIou0tKOM4lKiWHPk5JECi/kabCl9+CG+xW9tsZ7pgPk4mBnGlf4RlVjmzfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=h+DWZn45; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="h+DWZn45"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782990184; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=40gJcu0DvjRLYPCCKrXgN782eNAaaueahems5RWfVuw=;
	b=h+DWZn45ZQyhG7wdMBdJx0AJIt+Eslb8nSV31226fB2CH+oLM/v1LIUi4vIKBS4SjDgc1Sg+nxcOi+thJDffBZhEnyUNWcB0MEPau0RBn3QTsVoEaghfyD8Pc3Z19Ar6Nz1mxVnnt1tFp5s7xBw+LPHv+KGFvHSW+tPyLVMytIo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X6EWqRr_1782990183;
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6EWqRr_1782990183 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jul 2026 19:03:03 +0800
Message-ID: <4b25d8e7-7348-482c-81cf-df7c4d0bb365@linux.alibaba.com>
Date: Thu, 2 Jul 2026 19:03:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: bound namelen in dlm_migrate_request_handler
To: hexlabsecurity@proton.me, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 Kurt Hackel <kurt.hackel@oracle.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
 <20260629-b4-disp-94fb6521-v1-1-6953bcc0421f@proton.me>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260629-b4-disp-94fb6521-v1-1-6953bcc0421f@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/29/26 1:01 PM, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> A node receiving a DLM_MIGRATE_REQUEST message trusts the peer-supplied
> name length (migrate->namelen) without bounding it.  dlm_init_mle() then
> copies that many bytes into the fixed DLM_LOCKID_NAME_MAX-byte mname[]
> array of an o2dlm_mle slab object, so a malformed message from a cluster
> peer overflows the slab object by up to ~215 bytes: a heap out-of-bounds
> write of attacker-controlled data, reachable by any node in the domain.
> 
> Reject an oversized name, the way dlm_master_request_handler() and the
> other o2dlm receive handlers already do; the migration handler omits the
> check entirely.  Conforming messages are unaffected.
> 
> Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 93eff38fdadd..bd7623cc6e77 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -3100,6 +3100,12 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
>  
>  	name = migrate->name;
>  	namelen = migrate->namelen;
> +	if (namelen > DLM_LOCKID_NAME_MAX) {
> +		mlog(ML_ERROR, "%s: invalid name length %u in migrate request\n",
> +		     dlm->name, namelen);
> +		ret = -EINVAL;
> +		goto leave;
> +	}
>  	hash = dlm_lockid_hash(name, namelen);
>  
>  	/* preallocate.. if this fails, abort */
> 

