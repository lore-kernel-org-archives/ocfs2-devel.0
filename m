Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9918C008
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Jul 2025 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752547910; cv=none; b=TZz2BwJk/PPVovBhSlicF//+GVwRNvWbkrSUOhv8u1ESHMxp90JJ9ZrzGkfc+uxf+1CuBVFgkXj286wxgGl4lt33Puf/17hbUHZiTWBUkfdgLLZMROiYCyJVYGe59vnrGfJaQA3ETeDjhQhDzi7bykER4xLDGLip0DmaxZEsJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752547910; c=relaxed/simple;
	bh=iobXdl27H6ZJuLcQAu76AzTvRyaj+23LsNAAF1/ti9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7y5LzQN9k9A4NaAzN5d3nMyjgEsJ2h/IU8diSjahoHumXdqWqcstWLFSxSE1oH76U7N5qlL5Wd/U/pyVvrTqaXtG3JbwNgUPWz2TeALQUZ0YYajITpNhs/2iBUxbLDIqkj/xOQOQTf+4Bl2enU4Vbq+YhCiqmg8f0KPUgwFoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 56F2pIgl034051;
	Tue, 15 Jul 2025 11:51:18 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 56F2pH3W034048
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 15 Jul 2025 11:51:18 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5957f94d-2521-43d4-ba0b-7b98576167a4@I-love.SAKURA.ne.jp>
Date: Tue, 15 Jul 2025 11:51:17 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix lock acquisition order in refcounttree
To: Diogo Jahchan Koike <djahchankoike@gmail.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com,
        ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250714221552.4853-1-djahchankoike@gmail.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20250714221552.4853-1-djahchankoike@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav102.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/07/15 7:15, Diogo Jahchan Koike wrote:
> Acquiring the locks in refcounttree should follow
> the ip_alloc --> ip_xattr ordering, as done by multiple
> code paths in ocfs2; otherwise, we risk an ABBA deadlock
> (i.e in the start transaction path).

I noticed that ocfs2_reflink() in the same file wants similar change.

	down_write(&OCFS2_I(inode)->ip_xattr_sem);
	down_write(&OCFS2_I(inode)->ip_alloc_sem);
	error = __ocfs2_reflink(old_dentry, old_bh,
				new_orphan_inode, preserve);
	up_write(&OCFS2_I(inode)->ip_alloc_sem);
	up_write(&OCFS2_I(inode)->ip_xattr_sem);

