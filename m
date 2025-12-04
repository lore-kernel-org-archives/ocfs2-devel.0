Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5997B2C11EB
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 23:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764889588; cv=none; b=WO39WzjPCnlUuvwMqp6JGzsdA8J+R4Gmo64Twft2pJG6LrX14IGnfAu7s8a6sMjcDk0yBY1BdZRMKN3/JplPj0+h85A7rCOy094mFDRUyOagynDxEcVKTBL7NczgG5YeJk4EKX5bo5GTfbAWyRE9tlVCZ6Rbb++kn2rZTQA6Iho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764889588; c=relaxed/simple;
	bh=ZyQslrfSh0vjdbv7yxQZJcs8TXtwHGA4dyickLuH6t0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Z/VFg7k/pYBwfnmtdwoO7LXk4eafaKjFlrda2UPsrp8ksA2x7ffxFY3Gcs0RJx8Nw1vEK561GUp8h5iIyGAhNx5YwlXg5S61dbZuJVN4E4ILp46UN6Th5QXXzWz9XF3iKn9UsUi/ukzSftU2QmbQ+HqNDklUs3S5JSPURBrGCnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4501f50b40cso1671843b6e.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 15:06:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764889586; x=1765494386;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rQ7V0W5Op1KcZh1+tjSSSxtFbnegYQ45uvJmETjaW04=;
        b=lC/M1QCVjcGDeJoXjDkJbYHnVxzxCZMZyv4kWdyLyBu9n+Bc8PxOPEZzcpNbLIGRks
         3lwoc9LuGhT0djB+/CjNFY2ZoZUhRE6Ai1pDoJ/eTaZ3SFcuaDIFm6G0ok3ZaOS5NIpy
         EwvT3pDhFjH+jsZZJk6v0RqYN9dL/1XU4rEKrqsYigUUlT0+HWb/hPHvorFJf313sOCL
         qVX/lLyFVUaVTJX1qMa0WvbBFJaFGZiu4SkeijbO51MX5cl+0eoBaRN7oOdKcrO3HUih
         i7s+7UHpx33KRIk9Od6LxyWa3HzDHdiqYybgALsNys5yitwhZLlnTb/M5FVWG77Fa20P
         RVag==
X-Forwarded-Encrypted: i=1; AJvYcCXGdahzEn9iPqSlJx1sWU03vwwmr4+uLrULQmLCuMOWV/1pHmJEFG4kQ4AqtgjEP3ymtJFIlf40MjJRqg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwNj++MsMeugC0pKryfKWQ6ZFl8BEy8G+XGyW1PBbfxj4O1+Iuc
	SuNvshvKJv4Ui4LIgK60cFl1MO0wAHL2KdkeLnKGOConHU3X2t+dWDrnUUR8EV0VNko+LJb99k0
	rTylI6Xbs1zrhjICxr7Zile8Ge0Cq+Qr741Os10u4nXAjwx8mTL7Bic+CtMk=
X-Google-Smtp-Source: AGHT+IEMpWLeleOwfAtjH1t7lzwJoMAilwhdCzWQ6VpNIuCdgLD27FjP48NNEyyJvVAF5TlRz29JhNEaL4RRehc14gGs2UUhVo1f
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a1c:b0:44f:e912:eaa3 with SMTP id
 5614622812f47-4536e5045fdmr3812652b6e.32.1764889586546; Thu, 04 Dec 2025
 15:06:26 -0800 (PST)
Date: Thu, 04 Dec 2025 15:06:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693213f2.a70a0220.d98e3.01e0.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Dec 2025)
From: syzbot <syzbot+list478ef41f6f09391cb789@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 3 new issues were detected and 0 were fixed.
In total, 59 issues are still open and 25 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  331392  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  71056   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<3>  36887   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<4>  22192   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<5>  21752   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  14418   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<7>  6408    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  5925    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<9>  3972    Yes   possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 3033    Yes   possible deadlock in ocfs2_del_inode_from_orphan
                   https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
