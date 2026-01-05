Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D202D7DDE
	for <ocfs2-devel@lists.linux.dev>; Mon,  5 Jan 2026 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601221; cv=none; b=XqckZk0Lo0OFi+aRVH4G4/n0eonksz9/L1k4GxcGiUbWCb+EDi1Ky7FTDa1HlkZieogkw3IU7+QAp2bF7YKX23v8kz9bD8rxbO2HyXQfv2gTgqaXLHNvpJ4DMD76l6T8gwsfh2W7aMZ6W2dXPvay12YiuxJLkoU0KYKlH1avjxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601221; c=relaxed/simple;
	bh=p2o5Zb/sw8QKPT8iusvRoVPUC8mWWMcldIy0Bn+YbQs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jpivTj1q14RMNNqAXzdWlhDEDHS77R+bp1Ei/iY1r/Fw5EPJCrYiu4afoTeIyrNEQpcXiuBf+1LvAQajzTEgBECI6px3XDTxDJiyo9P8HLbNwdBWi535g7lM0s54+fmifIfk6ymMHHKULLsyHiTt03lAZAIqCvJ8DHf9RXblmys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c7599be25cso37137948a34.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 05 Jan 2026 00:20:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601218; x=1768206018;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rrd56Q+vMinNBLS8QrXy5Td5XqJF0ZAtFtuULGke8iw=;
        b=YuNcpJHboY2M7ennBkOt+sFeHrprg/uBd3J0NPFb3AHyN4goblwDfW3KqAcywyZJ8W
         6Fw7en9k/VXR9lCG3ayedG8dOlcE87KH8UgxOMwrPMvIS9phqMm2sjizPrjjR7UlTpIE
         4IZb0lkHqV7ihP5rdo78AxZPP5aygmtkhmMy1ub9esfCo1qcsaPgKfLxCQfRojy8mnx8
         WVJbYoFC2KD4mwUiuuJng2Fwmr/fLxjFagHXQbMS5xqk4oQqVniFZn5H327tgx1Y0CuK
         caVydcFhFr8vNX/iUil4mdO2w8gGHLXOCLqLS4upKQ3jXLTe6zClqubJHfKTkaz2ceFP
         EPvA==
X-Forwarded-Encrypted: i=1; AJvYcCUDlo4MWCSmCBTt28PQYlweDLMTEZMbS0u71TxGRwNxF5TADKO51oOIv84VrFTNZqNgmwrKbaN0ioyEFw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi2aV5AXZKSellMuTTbYIeclPV+Q0OJAujrGmHPCloR1sW6sM7
	FM0/VcRIVie0UGN8sgCFsTltKz5G48OYoi4zD9CoFRo10SBBBGw4AshzwZvZc2Igqo9E4wtbjdI
	MpZmWaU0pfbsxBIhDzS9QXGDzKBchJccXaqjh+RTUVBVdGR8u+cU/J9P98UM=
X-Google-Smtp-Source: AGHT+IGW7EX4JgGa06fhI8dSmYKO2lZGODwPdzX1KElVxLpoj7q9fH3ktImkY1Y7cSAe5mcjO3jxw0Ad+XNMJwcQ66DjuXWBjNgq
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:b2c8:0:b0:659:9a49:8f40 with SMTP id
 006d021491bc7-65d0eb303fbmr13843630eaf.81.1767601218571; Mon, 05 Jan 2026
 00:20:18 -0800 (PST)
Date: Mon, 05 Jan 2026 00:20:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695b7442.050a0220.1c9965.0026.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Jan 2026)
From: syzbot <syzbot+list02cfeae29bbd48f214f1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 6 new issues were detected and 0 were fixed.
In total, 58 issues are still open and 25 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  354845  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  40911   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  24725   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  23196   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<5>  15759   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<6>  7163    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<7>  6159    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<8>  3989    Yes   possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<9>  3666    Yes   possible deadlock in ocfs2_del_inode_from_orphan
                   https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
<10> 3593    Yes   kernel BUG in link_path_walk
                   https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
