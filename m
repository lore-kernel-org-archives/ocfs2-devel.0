Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883701D6DB5
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 02:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761187686; cv=none; b=KLLHOWPiDlHJ2ZnkmymSMFqijiX2DMERmdmuzhAfvLm9UeLgedCUdfuw6J3tihsTcF0gjL1MCTVrlaHP2/VcXkV5HtJOl00gPAhWvxe2MKke/BlSA37Q/5WwZVr6NsTg9nZURNSpRm1HXo1gymOo1iKl0Uc4rHxtKQO+Mg72R2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761187686; c=relaxed/simple;
	bh=WytSf4RnllgWJA9B49OflhvndVQxEvceLx57e9ZL9ic=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=D795FoKmErVdz02XuOQjVWrkt44zZFF+iQxEW6jjaykjWjK71izAijYiyQZuA6v8enET6jbPXwvrsQ39tPXL16I1FBLfo0ZFnUJG1hsoGcfe/ZYUMcvbCGZ2KO/PSu+lsJinjgEen2glC7PXKy8VKBkvMTT7AH2fGpEAMoom+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430ce62d138so4400895ab.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 19:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761187683; x=1761792483;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUQfr+6NTZqF59qYLAwvtXIMgq3M6hKMUwzUvKz4xY0=;
        b=lbfuMyKQp52IAZjg8UrnQIjfZ6y0rHyuILUkwFfC+6YvhZxxGimeGZ8ci5FEeJJ154
         0wmfSZeQFI/btKEvGUlWi0D8d+onzk5cO05xxJNFyYKb/OSdaNdEVCV10JR7pXVtXWBw
         BFnvccG+7kxCfRjSR5FFnyKqVifXGwuiv/NDG67iNxecDUovIjjpfUOTCG3VX+xOxeFe
         tYroHo25lRs01pqwaCxSSCeWTRA8ql+6UBezDshsMxyn+SLeA0PKB0QFKAtDfYIY1N3Q
         XMSokc5osMUqiyE0hRKzbKmZ6ch923QehD2KNPvmTtAbwPLdSTffpYp8HFU/x7ABbzLk
         XfTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoHHiWnhwmkkTHPynYmNxunwwQhZjbnmANjk7fA7tGORFy8lCb+3cyY+tAbEHi3g1EqkAAWTMuZ0lMjg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx01Of6lXSKsY06heOn+z7/xB3K5gxCLApZu2XCZGhrqadf8BL
	Ks78BY1unPTLsm+2bplYje22kuZ4jSvHOh/DiKRPS+rA8MV+jSHSpsKIPuVBJKDTx22ZXarV6l+
	gJO7gVD65buEHuxQw9pHhNW4FC2aKIqV7UydNMna2VKfAlLXswnqRj6IE0qA=
X-Google-Smtp-Source: AGHT+IFlyTmDauS4Q1UmTdsrJFojonqSbz37uPOqjpsgxt0JZoG9k/HALOGFTQpf/Livmh3rL3ZljO1n7nGE7d8NCzD7Ui4ORXJV
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188a:b0:42f:9b0c:cd84 with SMTP id
 e9e14a558f8ab-430c52048e1mr323859175ab.3.1761187683617; Wed, 22 Oct 2025
 19:48:03 -0700 (PDT)
Date: Wed, 22 Oct 2025 19:48:03 -0700
In-Reply-To: <00000000000093a1ca0621e8d336@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f99763.050a0220.346f24.006e.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_page_mkwrite
From: syzbot <syzbot+2e6495950edcf7fbfccf@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, elic@nvidia.com, jasowang@redhat.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark.tinguely@oracle.com, mark@fasheh.com, mst@redhat.com, 
	ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, parav@nvidia.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 04100f775c2ea501927f508f17ad824ad1f23c8d
Author: Mark Tinguely <mark.tinguely@oracle.com>
Date:   Fri Aug 29 15:18:15 2025 +0000

    ocfs2: fix recursive semaphore deadlock in fiemap call

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1357e3e2580000
start commit:   b5a24181e461 Merge tag 'trace-ringbuffer-v6.12-rc7-2' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1503500c6f615d24
dashboard link: https://syzkaller.appspot.com/bug?extid=2e6495950edcf7fbfccf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f252e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ecd2c0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: fix recursive semaphore deadlock in fiemap call

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
