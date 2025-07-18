Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A68130A54
	for <ocfs2-devel@lists.linux.dev>; Fri, 18 Jul 2025 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752846884; cv=none; b=aU5CJl4OGn4ZCEFmjxHKsoFXs0wF7BkOh5hx6vQ0BjZprpCi/MjjtGhFP3LbyuUjasaaaJuNj0OBJWqCDWiyFMRiDIhVKF4PGU7oQc1xxXpzu+S01ntATkjd1HmuQSFA8WbhErhF92lBhOIwRgibI56bg5IzeKOgJN/lUTfzfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752846884; c=relaxed/simple;
	bh=MsPSlzRRWS8Xh46eLLLIXmFa2M88MKKvTyEFzIVA95o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XN/ltD0+VZWxdRhas9sdZwh1x/buIxZ8n9SvFR+27sKwvOKaoUuqQBoiYs3jHRR+hgqygM29llZeGUwF1Y7Gr4df7RIE2Me5sNHncy0sBC7iQxT0souP451yiC7QVvGqQEfBVeatEsro8sZAbPxVeUpFIyB2Fdd0B4wvFGs9P2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 56IDsFQF032692;
	Fri, 18 Jul 2025 22:54:15 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 56IDsFxI032687
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 18 Jul 2025 22:54:15 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <6e49d04a-4069-4cce-9f49-fd63983ae658@I-love.SAKURA.ne.jp>
Date: Fri, 18 Jul 2025 22:54:15 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix lock acquisition order in refcounttree
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Diogo Jahchan Koike <djahchankoike@gmail.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com,
        ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250714221552.4853-1-djahchankoike@gmail.com>
 <5957f94d-2521-43d4-ba0b-7b98576167a4@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <5957f94d-2521-43d4-ba0b-7b98576167a4@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav102.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/07/15 11:51, Tetsuo Handa wrote:
> On 2025/07/15 7:15, Diogo Jahchan Koike wrote:
>> Acquiring the locks in refcounttree should follow
>> the ip_alloc --> ip_xattr ordering, as done by multiple
>> code paths in ocfs2; otherwise, we risk an ABBA deadlock
>> (i.e in the start transaction path).
> 
> I noticed that ocfs2_reflink() in the same file wants similar change.
> 
> 	down_write(&OCFS2_I(inode)->ip_xattr_sem);
> 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
> 	error = __ocfs2_reflink(old_dentry, old_bh,
> 				new_orphan_inode, preserve);
> 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
> 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
> 

Moreover, I noticed that e.g. ocfs2_xattr_set_handle() firstly acquires
ip_xatr_sem and then ocfs2_xattr_ibody_find() might acquire ip_alloc_sem.

Diogo, where do you see the ip_alloc --> ip_xattr ordering?

Unless we unify to either ip_alloc --> ip_xattr ordering or
ip_xattr --> ip_alloc ordering (or replace ip_xattr with ip_alloc),
this patch simply changes the location of lockdep warning?

