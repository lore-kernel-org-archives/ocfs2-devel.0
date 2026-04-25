Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FBF384239
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Apr 2026 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777156221; cv=none; b=ohWsgfVttyrW2+6BFEf31CS4XxYxIlpxwePH5QEyLKKBdhzaJppzpAQp3pW2cBZBzMRXyzSpYavEzdeFl3vgv/zAB1ErlWZVT3zunDJeLzPr5GAocjOI4TL4aG3mFkrht+0mJ6HLI5P+p9MxBiPDK2OcRnRTJnvmtDJpGpVAW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777156221; c=relaxed/simple;
	bh=MQYbilgcDRxH0mQmmF9ARQ6Ft3dPsB7J7pypz8/HVs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiQ7NDrbBOHKcVjTctXDnSoAt35yydaUnPFSPYDYwwl+dKFuuu0nGlX39lynKMEtjZ8H3vOrleGJuYNyT1HnNUpLyIVRlbfVZSvUtYeXUzjWL0ODC2+tXyW6D5UJ35OOf7Vv2f/dp3Vv97QzIb91+Gg12WtH7p8Ln2LTIPiYQQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 63PMU2ui022175;
	Sun, 26 Apr 2026 07:30:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 63PMU2AH022168
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 26 Apr 2026 07:30:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ea43bd73-eb68-46e7-bed7-a0e2f16336b0@I-love.SAKURA.ne.jp>
Date: Sun, 26 Apr 2026 07:30:02 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix lock acquisition order in refcounttree
To: Andrew Morton <akpm@linux-foundation.org>,
        Diogo Jahchan Koike <djahchankoike@gmail.com>,
        ocfs2-devel@lists.linux.dev, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
References: <20250714221552.4853-1-djahchankoike@gmail.com>
 <20260425142635.2ad0300d02ddea1bed94d6e2@linux-foundation.org>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260425142635.2ad0300d02ddea1bed94d6e2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav103.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/04/26 6:26, Andrew Morton wrote:
> But ocfs2_reflink() does
> 
> 	down_write(&OCFS2_I(inode)->ip_xattr_sem);
> 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
> 
> 

Yes, we know. We are waiting for response from OCFS2 people on the below message.

-------- Forwarded Message --------
Message-ID: <dee1a0fe-7846-466a-a08b-4967929b5f6e@I-love.SAKURA.ne.jp>
Date: Mon, 21 Jul 2025 19:40:58 +0900
Subject: Re: [PATCH] ocfs2: fix lock acquisition order in refcounttree
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Diogo Jahchan Koike <djahchankoike@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com, linux-kernel@vger.kernel.org
References: <20250714221552.4853-1-djahchankoike@gmail.com> <5957f94d-2521-43d4-ba0b-7b98576167a4@I-love.SAKURA.ne.jp> <6e49d04a-4069-4cce-9f49-fd63983ae658@I-love.SAKURA.ne.jp>
In-Reply-To: <6e49d04a-4069-4cce-9f49-fd63983ae658@I-love.SAKURA.ne.jp>

On 2025/07/18 22:54, Tetsuo Handa wrote:
> On 2025/07/15 11:51, Tetsuo Handa wrote:
>> On 2025/07/15 7:15, Diogo Jahchan Koike wrote:
>>> Acquiring the locks in refcounttree should follow
>>> the ip_alloc --> ip_xattr ordering, as done by multiple
>>> code paths in ocfs2; otherwise, we risk an ABBA deadlock
>>> (i.e in the start transaction path).
>>
>> I noticed that ocfs2_reflink() in the same file wants similar change.
>>
>> 	down_write(&OCFS2_I(inode)->ip_xattr_sem);
>> 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>> 	error = __ocfs2_reflink(old_dentry, old_bh,
>> 				new_orphan_inode, preserve);
>> 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>> 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
>>
> 
> Moreover, I noticed that e.g. ocfs2_xattr_set_handle() firstly acquires
> ip_xatr_sem and then ocfs2_xattr_ibody_find() might acquire ip_alloc_sem.
> 
> Diogo, where do you see the ip_alloc --> ip_xattr ordering?
> 
> Unless we unify to either ip_alloc --> ip_xattr ordering or
> ip_xattr --> ip_alloc ordering (or replace ip_xattr with ip_alloc),
> this patch simply changes the location of lockdep warning?
> 

Since I couldn't find direct ip_alloc --> ip_xattr ordering,
I tried effectively replacing ip_xattr with ip_alloc at
https://lkml.kernel.org/r/687be24a.a70a0220.693ce.0092.GAE@google.com
and got sb_internal --> ip_alloc v.s. ip_alloc --> sb_internal
ordering problem, as with other lockdep reports in ocfs2 subsystem
at https://syzkaller.appspot.com/upstream/s/ocfs2 .

In the team network driver, this kind of ordering issues has been
addressed by simplifying locking dependency at
https://lkml.kernel.org/r/20250623153147.3413631-1-sdf@fomichev.me .

ocfs2 developers, can you simplify locking dependency in ocfs2, by
killing several locks and reordering the locks?


