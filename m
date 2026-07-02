Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85CD35202A
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782971774; cv=none; b=Fqu4sIq2jrtsD6hsuqHKOy0t24wfdYdDw5S1YKUCyZZfkGe8GUuRXKH+KHCb4VNWUlkeymHY+BXviU3byyTos9K1QJjTuR6HbWsotLI9s4huRCaF+JBLAdbU1y5/v/3wM/VumYFY3Hb6aqRcR6gbH/g36zLXrXKf8IWM2lrPZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782971774; c=relaxed/simple;
	bh=y8csPfOTDV+ejr6ImS3rer+muAMZtpp5fbMD7BWj4A4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eji7HwIF9drzUKlUO+ax+LZQmACWIxvXg36DDqilb1QgV5jf2NBwKZBLKfqEjYWWt7/CnVagmTkXVnh6RFnNHzNk+sJQYZz0AAojFYEymKfCcqiV71rlAvdwxVozxkY4eiMgwsEFSi3BNAB2m3pF0URj3LDiU62bHT7RJOa9zjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AE+Qrvu6; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AE+Qrvu6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782971763; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZUQVdbQsORwvGzYHBOrTKleR5KY3WCdlubwyldafMxE=;
	b=AE+Qrvu6zq4S6w7sDZKEu60e2KE4c9NYnMrYgPYd7avgV4WZEBm2Cs7jNuhDPZCxBRLuxKAsH/70CjQfLZLLIM+eMo7GO7pBLtukU9oloHEMJ4oYORxM4KWMP8gXq8uuy9UnLizsv8nTcL2t8j0gmilfkBHCcxpuuTAjh/9bLtI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X6D4dnH_1782971762;
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6D4dnH_1782971762 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jul 2026 13:56:03 +0800
Message-ID: <18449469-291f-4f39-be62-faec1513645a@linux.alibaba.com>
Date: Thu, 2 Jul 2026 13:56:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ocfs2/dlm: bound peer-controlled lengths in the o2dlm
 receive path
To: hexlabsecurity@proton.me, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Kurt Hackel <kurt.hackel@oracle.com>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ocfs2 is always deployed in trusted network, so how to trigger this
issue in real environment?

In a properly administered ocfs2 cluster with trusted nodes and no
compromised machines, this looks essentially unreachable.

IMO, the patches are reasonable as a belt hardening against future bugs
or operational accidents, but not overstate the risk by framing it as a
security vulnerability.

Thanks,
Joseph

On 6/29/26 1:01 PM, Bryam Vargas via B4 Relay wrote:
> The o2dlm receive handlers trust u8 length and count fields from the wire
> without bounding them, so a node in a DLM domain can corrupt or panic any
> other node with a malformed message. Three defects:
> 
>   - dlm_migrate_request_handler() passes migrate->namelen unchecked to
>     dlm_init_mle(), which memcpy()s it into the 32-byte mname[] of an
>     o2dlm_mle slab object: a heap out-of-bounds write of up to ~215
>     attacker-controlled bytes.
> 
>   - dlm_mig_lockres_handler() passes mres->lockname_len unchecked to
>     dlm_init_lockres(), which memcpy()s it into the 32-byte o2dlm_lockname
>     slab object: a heap out-of-bounds write of up to ~223 bytes.
> 
>   - the same handler trusts mres->num_locks without checking that the
>     message is large enough to hold that many entries, so
>     dlm_process_recovery_data() walks mres->ml[] past the kmalloc(data_len)
>     copy and trips a BUG_ON (an out-of-bounds read ending in a panic).
> 
> The other o2dlm receive handlers already reject an oversized name; the
> migration and recovery handlers have omitted it since the DLM was added (see
> the Fixes tags). Patch 1 bounds namelen; patch 2 validates lockname_len,
> num_locks, and the payload size. Conforming recovery and migration traffic is
> unaffected.
> 
> o2net authenticates peers only by the DLM domain key, so any node that has
> joined the domain -- including a compromised or malicious member -- can send
> these messages. There is no local trigger; the attacker must already be a
> member of the cluster.
> 
> Each sink was confirmed under KASAN with an out-of-tree module mirroring it
> exactly -- a kmem_cache/kmalloc of the real destination size, then the same
> unclamped memcpy/loop: slab-out-of-bounds Write for the two writes, Read for
> the recovery walk, and a panic. A userspace AddressSanitizer build faults
> identically under -m32 and -m64. Scrubbed logs are available on request.
> 
> I reported this privately to security@kernel.org and the ocfs2 maintainers on
> 2026-06-20; with no response after the standard embargo period I am posting
> the fix publicly. I have no embargo requirement.
> 
> Bryam Vargas (2):
>   ocfs2: bound namelen in dlm_migrate_request_handler
>   ocfs2: validate lengths in dlm_mig_lockres_handler
> 
> fs/ocfs2/dlm/dlmmaster.c   | 6 ++++++
>  fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> ---
> Bryam Vargas (2):
>       ocfs2: bound namelen in dlm_migrate_request_handler
>       ocfs2: validate lengths in dlm_mig_lockres_handler
> 
>  fs/ocfs2/dlm/dlmmaster.c   | 6 ++++++
>  fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
>  2 files changed, 15 insertions(+)
> ---
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> change-id: 20260629-b4-disp-94fb6521-0afa227d464c
> 
> Best regards,

