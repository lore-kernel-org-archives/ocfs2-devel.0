Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253750;
	b=Ka2ph83H2SeditEvgi+n0m2XcpcNsPP738O9fePhUH3llnuui7fsQKGRB8c1lVVKN/uv
	 zxgAVaVqQIzTz6m+owUCBBJvjxr7QW4EL7RBhSujlcwiuMgd+SVbmm1wKPNuU/MuHphSH
	 8C2IoBkadexH6nmgA/Oi9U8RwXXnQY9S31MxoMW/5wPsoKXA8mYc1eAll/0HH29ShsLup
	 JfuaCjmGRbEW0t9B8Bk85pa22VHbJD1tEnSo7PFwCUKx6Suov6gzjylm1sOLcpDBLSihr
	 iNrceYGPu+cRhTtcwKKX2aUZ4hlCJVBQu09bpTJkg0jC+Dq1OUNi5BzboPLkaXOvBOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253750;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=MaszquqzrzKNoBcJxBUNb8Lmnhh0W1i6uNLCQIsKc1A=;
	b=0NsglxFJN5uBqTfGnqoo0iQPoCKj/uRxC65TfGUJk4cgWkCuzMBaE76GtFqGfL02lVuy
	 fs8pTOp7HFnQjxLFHFEW6MUZgUSrX42ZBhCmBoQZllw1o3BbRup0pfyDzO4kWDRZSw0wI
	 rC6T0OZSSYHlF2hIittc1lhF/4LxqbQ1u/7xoEqxTc39o3DVeN159HprtjzFQwo4ZZ8/r
	 uCIYRNsX9FNMigG2IaKgoPBunt3QM+KPLF9O2pJyDwXYqRya+0wHfJTbK+UrPOySQbkKI
	 BjeRqgi8Ysy4pHt5uCJMbqjC3/LKD1AoI4nAPqjp5O7YA0xm87UtfFMyJpaCJ4+WW6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fj65yHa8;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A208606A31E
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 06:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A208606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fj65yHa8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793253739; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MaszquqzrzKNoBcJxBUNb8Lmnhh0W1i6uNLCQIsKc1A=;
	b=fj65yHa8F5WVX/LkBebeGn0vP7oVTrQsnAfga39vWez/Kc5Ln7uCTa1Nqfxx6OkgCO3BpDIZfqJcHBaPZa22wu1MdDNeEG2OfrAfZY89VGMJG11Ooi9Y+/zZKA7kdML+/Ob6zlcPlRLSH4+FyETlzu+59A6idm/XvM9si96+19Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDibLMD_1793253738;
Received: from 30.221.129.93(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDibLMD_1793253738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 14:02:18 +0800
Message-ID: <40009068-73c7-4a60-8789-34d32d574264@linux.alibaba.com>
Date: Thu, 29 Oct 2026 14:02:17 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: keep locking_state within the cluster
 connection lifetime
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/26 12:31 PM, Cen Zhang wrote:
> The locking_state reader calls ocfs2_dlm_lvb() through the selected
> cluster stack. Its debug-object reference keeps the tracking list alive,
> but does not keep that stack selected without a cluster connection.
> 
> DLM initialization publishes the file before establishing its connection,
> and DLM shutdown drops the connection while the file still exists. Both
> the mount error unwind in ocfs2_mount_volume() and ocfs2_dismount_volume()
> remove the debugfs subtree only after ocfs2_dlm_shutdown() has returned.
> Whenever the disconnect releases the last stack reference, which is the
> case for a failed mount and for any unmount without a pending hangup, a
> concurrent reader dereferences a NULL active_stack:
> 
>   Mount error unwind                  Debugfs reader
>   ------------------                  --------------
>   ocfs2_mount_volume(): out_dlm
>     ocfs2_dlm_shutdown()
>       disconnect last cluster
>         clear active_stack
>                                       read locking_state
>                                         ocfs2_dlm_seq_show()
>                                           ocfs2_dlm_lvb()
>                                             dereference active_stack
>   fill_super(): out_debugfs
>     remove debugfs subtree
> 
> Publish the debug files only after the connection and the mount lock
> resources are initialized, so a failed DLM initialization has no debug
> reference to drop. Remove them again in the common DLM shutdown helper
> before the connection is dropped: debugfs removal waits for readers that
> are inside the file operations, and the parent directory is still present
> at that point in every caller. This covers the mount error unwind, the
> ocfs2_fill_super() failures after a successful mount that dismount with
> mnt_err set, and unmounts whose disconnect releases the stack directly.
> 
> Only the relevant frames of the report are kept:
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:ocfs2_dlm_lvb+0x38/0xf0
> Call Trace:
>  <TASK>
>  ocfs2_dlm_seq_show+0x36a/0xb70
>  seq_read_iter+0x480/0x1110
>  seq_read+0x362/0x5a0
>  full_proxy_read+0x11f/0x180
>  vfs_read+0x1a0/0xc20
>  ksys_read+0x111/0x200
>  </TASK>
> 
> Fixes: 286eaa95c5c5 ("ocfs2: Break out stackglue into modules.")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

