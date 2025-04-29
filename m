Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747592C375C
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Apr 2025 12:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745930852; cv=none; b=Phb5x9A7mRJoHksWXQBVd5TitX4nOY7Eiqeor2oqTpyMn18/c/t5rmzQdyvHzADNfGsc1ZONPJdev6lFN1VA6kBb8P0yyGHYYb1gfgX2a4fsmdWt79m+hwzxnbMSRrrDzHdbUzZG8RkoJFnU2CvIpADIjlWuM6wMdF5yqG8uNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745930852; c=relaxed/simple;
	bh=cFF6VU1FyugaAJfxTA/LO9ddZ+pDnBgTgMqHrjX799U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Bys0zeo9QF7CDyHHLzuc8EY3/YMfAaloX014a/YHoOZPSawvLYezei3vs2a6Ky/Dv+Sd/Bq8DCEXqbz497qr1eW6GoB84dDr65Pau2aWIccY3gsiG6sjui24zOM7Dn7xbXKieS2CNWaelsT3Uti4tQOdNl956N3xYr+B13sOc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-861d6e340e2so560338239f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Apr 2025 05:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745930850; x=1746535650;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1lBvDxpT3qeCElgQSmEgjirhy8ts7wnaWc0xcs/cQkA=;
        b=G+Ye6Ji3gYcdgOLlMrE04PYtuPCk0IO6ggaC32ig8luA5iJcdUEfAUuAIPRFF7XK41
         qoWy/0/z2e/t9/WH+hgUVkhb/BOMzX9vDxa/MZVragzANC4HISC2mQ4xofn+sgsu78iL
         TUpkLDMeGDc7RcE7OivRJbXJfoFdSXXHAB78+z5htkdkyYCaNiTV4uQLCNV5Ts3nOTT/
         ED+LbwRQyutJ1XF7FLtpWq2fjIXPbr0JTe9LXvOAgvFFWm/n5zzj+QkwMq6WUblrht9l
         rhRbWyZ02DYBzYNe0jR8tF5ub+Uq04sZJp7rSKQm3eEVwcbF0bhj6pE5UYFkglceWQf9
         iCzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfwpgwScpoyOQh3ewNUWYzvzoj5Jh257gTS1utjm4wqMcRtpcJ5NPd2pfBcDm1fLu3wIDIGzFsuYG7Dg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9RU67sqqVsasqkVfeGMN6qj2j9ffXrM4ekiRUKYWMOPhQGVu+
	RwVvd8NBU/CUMhMSd+ungi55POKoyS+uJ0J/BVGge+U91CsV/7p33laQuQsY5gBMMwd0AGjREyE
	TsrKGrahE94EEtsb8gcKEuh8tZ0WWTHs9FCwsXZV0cugWPPnMvj5n3O8=
X-Google-Smtp-Source: AGHT+IEYNvZE6kKWhT93yep1SZFjQTCGkUfGLqor7tn2UjjmQO0T/emH97LXWiNj/tKXcQbPoDaf8F8q8j+VWtoruKLl0BIEOoqp
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:27c6:b0:85b:b82f:965b with SMTP id
 ca18e2360f4ac-86467fd5c6bmr1468087539f.12.1745930850563; Tue, 29 Apr 2025
 05:47:30 -0700 (PDT)
Date: Tue, 29 Apr 2025 05:47:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6810ca62.050a0220.16fb2c.0002.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Apr 2025)
From: syzbot <syzbot+list2798b3e8aee0b9ae07b2@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 3 new issues were detected and 0 were fixed.
In total, 72 issues are still open and 16 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  168860  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  49590   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  37759   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  17497   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  11874   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  11560   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<7>  7792    Yes   possible deadlock in deactivate_super (2)
                   https://syzkaller.appspot.com/bug?extid=180dd013ba371eabc162
<8>  6409    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<9>  2378    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<10> 2198    No    possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
