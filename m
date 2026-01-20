Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D8D1D9A5F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 01:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768873361; cv=none; b=Ydd8tCpTuae1lfFt/c1LDGjga6wjKTeR5lLBMlpJe1w71I8vpD9MtpHMytPPORGID36ZZ5VvKXt3sf1CzfwhuLvkekC35CUdVobVxqgLZ0WxIZ/RItZePZHHV/Nrh4v1zoJKZWHXo2LNWxdU30ZJErL4fJQjowqkAwU8Ag1LVLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768873361; c=relaxed/simple;
	bh=uMZae6jhobpNdRhasC4AlGF+B39G9a89jNBIiuh7WVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIxHcoCbsLG2Gc+N6XAZQLvTc4pK3Sl5y8mU5vlxvcdB8MQ6uaY0jBPRvRyiECOyGZD9xd7YiSD1SwPbnwydPaB1OxDcGQP09m7tuuWFsciOQNATc13ITPGPXvXT7kT8q9HZjj4LdsSNQij2bv1+q4NT2sIZuXqmhNurDvXWhzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e2htccZx; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e2htccZx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768873357; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ij6PeTL2GxSCqUEaiQKCiP8hhw53Aq8hRVNhTOS4LB0=;
	b=e2htccZxpVnvT0QSN74YwW9GBGNyzskp890gSA93jx3zzs8PlAL8qzQquFpA1N7R3S6ku0ACWhl52NPsm98m6+ciRmnwvnaj1zd/HeKJkq1g662n1CNwT73wLvkbsR7ZoyUZPrhIyyUSd1cx4oL77+aEZivTzMguoKhQnzZub8k=
Received: from 30.221.129.88(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WxSJW-l_1768873038 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 09:37:18 +0800
Message-ID: <0a2eab22-95ee-4172-9052-aefcbc5bf227@linux.alibaba.com>
Date: Tue, 20 Jan 2026 09:37:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_acquire_dquot
To: Szymon Wilczek <swilczek.lx@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot+51244a05705883616c95@syzkaller.appspotmail.com,
 akpm <akpm@linux-foundation.org>
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
 <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com>
 <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
 <25d90176-743e-4638-9643-861bd5792eed@linux.alibaba.com>
 <CAJRoVwgxBKXcMSU-CMH8gC1TLnWFdMHiaFGOyFrkDZqzfpN8Ng@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAJRoVwgxBKXcMSU-CMH8gC1TLnWFdMHiaFGOyFrkDZqzfpN8Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 10:02 AM, Szymon Wilczek wrote:
> Hi Joseph,
> 
> Thank you for pointing to the designed order in quota_global.c.
> 
> I looked at the locking documentation. I see that
> "Acquire dquot for the first time" specifies:
>   ocfs2_lock_global_qf -> start_trans
> 

Ummm... When sync and release also is
  ocfs2_lock_global_qf -> start_trans

> However, I believe the v2 patch is still necessary because lockdep
> detected a real circular dependency:
> 
> sb_internal -> sysfile_lock_key -> ip_alloc_sem
> 
> Since ocfs2_lock_global_qf takes ip_alloc_sem, and start_trans takes
> sb_internal (via sb_start_intwrite), the documented order inverts the
> chain above, creating an ABBA deadlock with freeze/dismount paths.
> 
From the report link, start_trans is called during
ocfs2_shutdown_local_alloc(), but ocfs2_disable_quotas() is fnished now.
So how it happens?

Thanks,
Joseph

> The designed order may have been correct before sb_start_intwrite
> became part of ocfs2_start_trans, but now this sequence conflicts
> with the VFS freeze mechanism.
> 
> My patch ensures sb_internal is acquired before ip_alloc_sem, which
> matches the expected freeze ordering. Perhaps the documentation in
> quota_global.c should be updated to reflect this change?
> 
> If you see a problem with this approach, I'm happy to adjust.
> What would you suggest?
> 
> Thanks,
> Szymon

