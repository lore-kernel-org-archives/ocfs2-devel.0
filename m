Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611D2C0299
	for <ocfs2-devel@lists.linux.dev>; Sun, 10 May 2026 04:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778387542; cv=none; b=ncLR3+sBjc7sEj9mItOoAOYqG6IQKu6qIA2yPZ82J1lwO40/S5BZp6JParjpGd+hO1NwtkNDpF5dgQmJ9Ynr3bK9x9gCusJ+HiabIt5nWsPhrF2Ltl9sA4f2Uq/MqA1qFFeFNEEhSaIfm0xx5VRxRQ+Uwtmz0MHBx+g2K0UHl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778387542; c=relaxed/simple;
	bh=8KxJgmOsG8c4RKJMyWr9EJJ2Qct81PQCKRlusQNeeRk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n7GWSC/y2tQWryZFKlk+UALC3+qieV4U5lYUMw5EmFzmr508mGkNbmu2OCbaLBLVjvsGhfRR2374khqGlPvocsHTiPbP3fl2k9B03yneNoxnbsmhdCONLV8bP/lmdcr1auLVM0ZmeNCJ4vrMn0lTcSD52gRTAPauncJEvNotO1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6961bdde2a1so6621322eaf.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 09 May 2026 21:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778387538; x=1778992338;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UDreTXJ3IECqjbirGHKbhuO/w3OeRWVdFtLs187bOqk=;
        b=MHHY4/OiGtgRLPB15dK9vw8dxkMy5aY55OiwQhSjMNR3cnL21aUtCXaIrL3wbJnIeM
         p73OPkr8GsWzrBMlc5wy/NdCLthgnwmwPz4UdURwi0BDXvmmweMDi4ft075/jqv0hXWH
         aj/QBzbz8MgS7mkid7MXyvhIwSe33GgrCULNSgOOIECXccZRa33XZ8xfeRsyWNyftlH9
         PEcq+GwxLzGV4QvG+XJeyA+mVALZHax8mZj1aZ+dIiECCu+XV1rqPoBsVOdKOSlKb8Af
         JmT0w9wk4Ux1FY5TxquyWanujfBm9G3RAsrAKrnRWpLvzIablx4IDflCTssKoQlnMf8y
         aM6w==
X-Forwarded-Encrypted: i=1; AFNElJ9jIbXnOq9tThAcu+rsgT8jR99llVC5y7Haq6uXewyVRUIdY0UTZj04Kb18W50HcHF/NtxEsUtagMR7rA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzbT6/nszBNXtbbbRYzd+D7K1vZFwRKetNL+gOzCZ2g/22S0riM
	da4MTpzfmHS/CuICeyFBlVtSLws3VgH9XooaZ580LNDy+XpXivLWlrbegbG/6ZTvpWXQkxl907h
	uGvSyxVtva8QS3xlsnj1ROlZ6C3TPY8eH3lxVfYjbqaQ6NT+60JI+69Iajw0=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:220d:b0:686:d107:2856 with SMTP id
 006d021491bc7-69998d5251dmr11233161eaf.51.1778387538129; Sat, 09 May 2026
 21:32:18 -0700 (PDT)
Date: Sat, 09 May 2026 21:32:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a000a52.050a0220.1036b8.000d.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (May 2026)
From: syzbot <syzbot+listfc4dd8b57f3992b87f62@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 5 new issues were detected and 1 were fixed.
In total, 45 issues are still open and 49 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  414352  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  46631   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  29203   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  26294   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<5>  18768   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<6>  11946   Yes   kernel BUG in link_path_walk
                   https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
<7>  9102    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  6246    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<9>  4067    Yes   possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 2535    Yes   possible deadlock in ocfs2_evict_inode
                   https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
