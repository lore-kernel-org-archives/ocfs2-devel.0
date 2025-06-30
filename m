Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1991C246BB0
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751280009; cv=none; b=PN3QE7TOzhsUZ7rHxBYa7Y9c4OT+A/SZcpBtRDSyy1W4Rvx6MUkx1ihPMDB4o/XLqJRhskFdZpkL9p8cR0ChmkhY43xII/dGRtyIQ0Qv4APvSFxCNfXlnuMukDu0WI7dfjBz+hgc/blGj/yxFXs/58Y2HmM8fyqftQPCBcrsht0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751280009; c=relaxed/simple;
	bh=ag/DlPi/GiUzdTGiYeoSQM0mRQHdDoRF+vlZgdiAFeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=RHJvDcYlKX9U6obIUquUHJ8uAX4akppmo2CeMFZt/zKnDGSUBDS34ckpVZ/VuW1Bt0VwbulHtY2ULWinbYucP+iXyQvhHrk2III5JCFnVqQF+RPyhw/kIMR6yqPQz3mfvHXbCfWNILS8a5chUO+PdZkc3+rjt4RSNmU7TtvvkIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55UAdp6B053479;
	Mon, 30 Jun 2025 19:39:51 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55UAdpXZ053475
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 30 Jun 2025 19:39:51 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d54a0eb8-5899-4ea7-bc86-7a0d56c190d2@I-love.SAKURA.ne.jp>
Date: Mon, 30 Jun 2025 19:39:50 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key
 names
To: Heming Zhao <heming.zhao@suse.com>
References: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
 <d490a3ad-6309-42f3-9774-91871fbf7330@linux.alibaba.com>
 <d76672e5-0d69-42b1-a9d3-b70439c194b5@suse.com>
Content-Language: en-US
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <d76672e5-0d69-42b1-a9d3-b70439c194b5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp

On 2025/06/30 11:42, Heming Zhao wrote:
> I am not familiar with lockdep, and just have two questions regarding
> the lockdep in ocfs2.
> 
> 1>
> there are three global "static struct lock_class_key" definitions:
> - fs/ocfs2/inode.c  : ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES]
> - fs/ocfs2/dlmglue.c: lockdep_keys[OCFS2_NUM_LOCK_TYPES]
> - fs/ocfs2/sysfile.c: ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES]
> 
> why did you env only trigger the ocfs2_sysfile_lock_key[] warning?

Because syzbot is reporting lockdep warning on ocfs2_sysfile_lock_key
at https://syzkaller.appspot.com/bug?extid=68c788938ba0326046a9 and
I couldn't find which lock_class_key syzbot is reporting.

Unless you want me to update all keys within this patch, you can submit
similar changes on lockdep_keys and ocfs2_sysfile_cluster_lock_key as
separate patches.

> 
> 2>
> It seems the existing CONFIG_DEBUG_LOCK_ALLOC is incorrect, it should be
> replaced with CONFIG_LOCKDEP.

I couldn't catch what you mean. There are many modules which declare
"struct lock_class_key" under CONFIG_DEBUG_LOCK_ALLOC=y.

