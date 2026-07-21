Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09513F787E
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784596880; cv=none; b=hfm9DkHSjSm0ATsVKDSCvmvQtDvdt4ZTMnY5vSvS7yyDO2jtTEZvaH5ahQUem7i1OaPzHv+EZ7HmMokZvTQ3u9Q85Y+MJ1jDl/mXEAY/uqc4fhLW9mtP09o5Wf5nbyOBSOVcfkOilMNnH6AymIXJcmK8glKG+T1yGnwPGLXrIe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784596880; c=relaxed/simple;
	bh=8Q8fqsyTCEqD9MESI2Y/A3SJA3tbjLoggsSGBUsD63o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iqzoQsKj0Kpq1eonoYHlKKmU4RZ6xOT0iTC/5aMZWKdeZh5xdQg8NEljXn3mjbyi0HaZxk3WoSTUqnYioghfPB/0i0Zm+V6VlKWJe4vAygYbTxnLkMCzNWD6h0XL42LuPOrQVqN46n36maYaH/lg+zqzfh2D8+VO5L1QrupGWR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MlhkMr+q; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MlhkMr+q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784596875; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JREDA355EKdg2msjjt4j2FAsP9SQxUVaQtiB7ZcuRn0=;
	b=MlhkMr+qpEAxPFfyjxW7Xdl0qxnx3DRnxq0dZQ3Tll46UamYgHYSsDSywbsa62XiymJsXPm3hCCJM9aLwYLzf8eSsp6ZEE7fhtS/VBAyNfV/KUFCduglybEGXJ9RuKINKmCRUc4DE6A3BkE7wR12t25mq4OfIUZbgDbTmyzANhw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7XxEiR_1784596873;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7XxEiR_1784596873 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 09:21:14 +0800
Message-ID: <b5657937-3c3a-4d85-9df6-80ebb6feeb24@linux.alibaba.com>
Date: Tue, 21 Jul 2026 09:21:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlm: validate lockname_len in
 dlm_mig_lockres_handler()
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260720170828.11476-1-security@auditcode.ai>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260720170828.11476-1-security@auditcode.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This has been posted before in:
https://lore.kernel.org/ocfs2-devel/20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me/

And it is now queued in mm-tree.

On 7/21/26 1:08 AM, Ibrahim Hashimov wrote:
> dlm_mig_lockres_handler() handles an incoming DLM_MIG_LOCKRES_MSG o2net
> message from a remote DLM domain node and copies the migratable lockres
> straight out of the wire buffer:
> 
>     struct dlm_migratable_lockres *mres =
>         (struct dlm_migratable_lockres *)msg->buf;
>     ...
>     res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);
> 
> mres->lockname_len is a raw u8 field taken verbatim from the network
> message (dlmcommon.h), so it can be anywhere in [0, 255].
> dlm_new_lockres() forwards it unchanged into dlm_init_lockres():
> 
>     qname = (char *) res->lockname.name;
>     memcpy(qname, name, namelen);
> 
> res->lockname.name is allocated from dlm_lockname_cache, a dedicated
> kmem_cache sized exactly DLM_LOCKID_NAME_MAX (32) bytes
> (dlm_init_master_caches(), dlmmaster.c). Any lockname_len above 32
> therefore makes memcpy() write past the end of that 32-byte slab object;
> the maximum attacker-controlled value of 255 yields a 223-byte
> slab-out-of-bounds write (CWE-787) with fully attacker-controlled content
> (the bytes are mres->lockname itself).
> 
> The o2net receive path only bounds-checks the whole payload against
> nh_max_len (cluster/tcp.c); it has no notion of the lockname_len
> sub-field and cannot catch this. Every other DLM message handler that
> consumes an attacker-supplied name length already guards it against
> DLM_LOCKID_NAME_MAX right after pulling it out of the wire structure:
> dlm_master_request_handler(), dlm_assert_master_handler(),
> dlm_deref_lockres_handler() and dlm_deref_lockres_done_handler()
> (dlmmaster.c), and the equivalent check in dlmconvert.c / dlmast.c.
> dlm_mig_lockres_handler() is simply missing the same check -- present
> since the file's introduction and never covered because exercising it
> requires two heartbeating o2cb cluster nodes and a joined DLM domain,
> i.e. it is invisible to single-node testing and to fuzzers that don't
> speak the o2net/o2cb protocol.
> 
> The attacker is any node it fully controls (or is on-path and can spoof)
> that is heartbeating in the same o2cb cluster and has been permitted to
> join the DLM domain. o2net authentication is limited to cluster
> membership (nodes list + heartbeat), not per-message payload validation,
> so a single rogue or compromised cluster member, or an on-path attacker
> able to inject on the unauthenticated o2net TCP stream, can send one
> crafted DLM_MIG_LOCKRES_MSG frame with lockname_len = 255 to any other
> domain member and corrupt adjacent dlm_lockname_cache slab objects,
> leading to memory corruption and, depending on slab layout, a crash or
> worse.
> 
> Reject the message before it reaches dlm_new_lockres() /
> __dlm_lookup_lockres_full() if mres->lockname_len exceeds
> DLM_LOCKID_NAME_MAX, mirroring the validation idiom already used by the
> sibling handlers above. The check is placed immediately after the
> existing dlm_joined() gate, before any use of mres->lockname /
> mres->lockname_len, and follows this function's own early-return style
> (dlm_put(dlm); return -EINVAL;) rather than the later "leave:" label,
> since at this point buf/item are still NULL and no refs have been taken.
> This is the smallest possible fix: one bounds check, no change to wire
> format, on-disk format, or any other code path.
> 
> Reproduced on a v6.19 KASAN-instrumented kernel with an in-kernel
> injector that calls dlm_mig_lockres_handler() directly (bypassing the
> o2net accept/heartbeat gate that otherwise requires a second heartbeating
> cluster node) against a live single-node OCFS2/o2cb DLM domain. A control
> frame with lockname_len = 8 completed cleanly; an otherwise-identical
> frame differing only in lockname_len = 255 reliably produced
> "KASAN: slab-out-of-bounds in dlm_new_lockres", deterministically and
> with no dependence on timing or allocator state. Full network delivery
> over a real two-node o2cb cluster was not exercised: the injector proves
> handler-reachability and the write is deterministic once the handler
> runs, but the o2net wire path itself was not verified end-to-end.
> 
> Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07
> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 9b97bf73df22..ec7edffc8ca8 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1366,6 +1366,12 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  		return -EINVAL;
>  	}
>  
> +	if (mres->lockname_len > DLM_LOCKID_NAME_MAX) {
> +		mlog(ML_ERROR, "Invalid name length!");
> +		dlm_put(dlm);
> +		return -EINVAL;
> +	}
> +
>  	BUG_ON(!(mres->flags & (DLM_MRES_RECOVERY|DLM_MRES_MIGRATION)));
>  
>  	real_master = mres->master;

