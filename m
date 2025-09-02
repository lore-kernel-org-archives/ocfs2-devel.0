Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6753827466D
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Sep 2025 09:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756804835; cv=none; b=cdNIhbt1C+rXA9i4RRyAnONvZIFUT849pCyxDRPxNCTRmPLtJsyQ6uCeYeZaDgBDpdwF3UBwCGgd4dFwYCTgrwcx6QygiTMgrFlAhGJAtword1h3NrK51QTnh79B6TbjKmqFW1mCqxR+ox9RPj2S/I4yhVRS5PVZTLnukB0Yptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756804835; c=relaxed/simple;
	bh=mQnQcZJzzChhwa42vQX6qHNqh3y9IAYb2KRNG0sxE7U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ml79fGrSXRFhuEade1KiesSB4Qe2UmEhbKXUvFeahez7iZQaV2wor7ekM9sdITkqvZg0Auh5XXLDIxpgS3jeXEizOkJZvItMwPCYOzG4DejrpaMvEvVwouNLR70auAPbbK+jfVWK/H11SxAa5/O81pW+n/zNexfgYr3C6/DMieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ed0f07fca2so59723525ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Sep 2025 02:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804833; x=1757409633;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yUdz8oHchSa5vXVdHhjJpdXTNdE8QIc3MfmWSmfINcU=;
        b=NYdVchIznheE+pzVP3H38BgDDYDnIKY+f1qNW4s/nbpULJGLCS97jVePx8RdckMnet
         rSIxJcnwPMF23Fy3YgzWpVbVIiAteQNEwFC6R/+KWcbq/JS1LBEz0M1YGEuOaQcrw8k0
         6lNCJBz/FjX1BwefXvwIoTtombTYThoYUgwySSg0obKT8+YByjY5jy17iozhV5aXjSAk
         7akP3+z8uDFYxs3JJIzLaJw3d9rNsEOBvZXQXRrgiM3mbz+FffJx9cO8gCvr6OdxnnOJ
         G6CjhcGTvbqKYKVnd+Osml67j7JkUzz1Ol88I6JYFMIGOD9j7NSQwRXLb6fGp6I5icgO
         4l7g==
X-Forwarded-Encrypted: i=1; AJvYcCXVSI4dmYpA4+CNOPm1aK4NJNWw9j/JD5x0omAuQxoNQQMPZ01gmJ1Fw+f7groIHn5hACGEgE8NuXE/qQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLiDABDwAtNVPQIX+DWYsm6Qk2iPiaBv3Lg8L2leDPTLzEmwRr
	uXhpCb2yvUsLKRXNuNAo1BHFnWJWc6EIrFXtAZqgkM7ysL0H/n1PFTKFkjyM+bSwew27fCqrDiQ
	NgxXt0iCbXAIJIZfjX7MNS+AW3Wbyc2LlpgtuNpfpjKWgf9vTwn5RW8uvJvg=
X-Google-Smtp-Source: AGHT+IGp4gW6lu9OTBIir25xzwV0vJJpI3xHKndejQnwd4XWVixRqyu5RHHt1Y1Pr6TEV8Wo0dit6GkabjBRTZz71lGmZQwgj0Jf
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c7:b0:3ee:1aca:3162 with SMTP id
 e9e14a558f8ab-3f4021bfd90mr180808315ab.26.1756804833545; Tue, 02 Sep 2025
 02:20:33 -0700 (PDT)
Date: Tue, 02 Sep 2025 02:20:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b6b6e1.050a0220.3db4df.01cc.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Sep 2025)
From: syzbot <syzbot+listce5ab545f249d56dc0c5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 6 new issues were detected and 0 were fixed.
In total, 71 issues are still open and 20 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  261241  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  78886   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  55588   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  27349   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  17511   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<6>  16645   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<7>  10439   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<8>  4269    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<9>  2938    No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 2336    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
