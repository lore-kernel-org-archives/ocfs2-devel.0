Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F01AD3F6
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Oct 2024 08:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756945; cv=none; b=ZywcHlS1a3UrZVPdcALvv0T4Uon2SzIMmtxT/f8BquiITBaMPlNOeoqwKvmqQ6WEJ4s6w2pmmXu02WGUC55mWJ95YAv4siJDJWjDNtOIEHGBCnmCdrLio6xlfnvyB4pDihZakEEsrcqjoGPGy5q1jhCqnYnSjJDrSlSjToaPoJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756945; c=relaxed/simple;
	bh=qpOMR1q8pw0arXvHvTdJYdCW8hhLwDdbKEv7LfSOIhM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N8lJf5CvZAlrqlToCIvSKNzMmklXQyuKKz0ahLKlk6fPCLZ/uDMscuj8+00xo/uYt4zzmRAaQ+MirqleMOK8OFR7bbGIQtvQZhSamDFJOfDzSWI9HhV0eRydJJqTeRJbb8QmLtMkjIxJ18lmPvnKJk7JUzV3oqfs5/qnkF1qYX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3b2aee1a3so6405185ab.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 24 Oct 2024 01:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729756943; x=1730361743;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+eQAa/V/MnT5o4xNSk5+65D8LHOg6roAOmqiP7coYjg=;
        b=fOByFgBmj9MtI5lqZg4gm9hEfjVRfXyv2wd8GigrljK4QrcfvgCvbFyhG5fZRzIcfu
         KsH7yxiY7StxArB8JwmH46ZzTxXVoGx8ntlNQNzYEea2H2nMM32DKyyqDZeiuy/75ez9
         dn1HTYNCtBmEh94KcGEkmBznGcpUPlsvRZeUabA2OP0Kp7TWekpS3/TPXc9Sl/TqYUjK
         IV5MIQc6Shcm9jRAkz333SaCZBS37NxruOVf+bWGrCBcraS1IwxbF5E7WcMDKi39AVvl
         YmZytfieZHE0siEJIgpncdJRxpH3SHOKvK5LVLJmmrGKomYD7A+2gBUcnRSoccl56xfI
         DmDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfZYeq16TE++4F0ueHt5WOccdNLJ5VlbG8QeW7R/VL+gLkEhAuDu22fIjiPJevEJ4k16tC1ArpPiSuqQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxRmrdsrzcUPEvtMMHO59nBiG1z+te3ei55Ii+Yuf8FV2Mg0wGR
	VjT3WEzcrEXzxlaHXZAgz88Uk27zEZWA4cHW1jcEH+b0yQ+gpRNZ+yt4IiisPo9LTGORc4GG1ex
	aPWPgSAQtRGKSMig0kk0u6dE5n4raO+Ym+35cXgJHwKq2qwa5ElrgmmI=
X-Google-Smtp-Source: AGHT+IEWfx71AwnUYSROa+k69Z2LcfH3wprVRNEGD/3R9IfrNdYEOzK9yIRIHOrjep6gLcicC35qOz+XMGNVDip+R/GsXS6W4lSD
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ca:b0:3a2:74f8:675d with SMTP id
 e9e14a558f8ab-3a4d59d808emr57190205ab.20.1729756943279; Thu, 24 Oct 2024
 01:02:23 -0700 (PDT)
Date: Thu, 24 Oct 2024 01:02:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6719ff0f.050a0220.1e4b4d.00a1.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Oct 2024)
From: syzbot <syzbot+list62f8684d17ebec83082d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 18 new issues were detected and 3 were fixed.
In total, 51 issues are still open and 6 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  29174   Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  4466    Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  3721    No    possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  2419    Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  2175    Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  1681    Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<7>  962     Yes   general protection fault in ocfs2_prepare_dir_for_insert
                   https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
<8>  488     No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<9>  72      Yes   kernel BUG in ocfs2_iget
                   https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb
<10> 62      Yes   INFO: trying to register non-static key in ocfs2_dlm_shutdown
                   https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
