Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46EA4756CF
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789130014; cv=none; b=mGMEI98yfm9aHcNxta1fZVD3iOTTWX+7a/D7tytub6guISUWMLrLu4vSxHoIQFQr4BcW0w3kBdnzLKYEJFfNXcfIHD+iCuyML0mgJTG+Gc+0rayClaYnSLN+poBlPJwuXyLGkgbHNKGj/tPZZ5WA4Bp0pizMqILBNJkM25OuwUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789130014; c=relaxed/simple;
	bh=Yuz5L7e5NkvWbA0ATJ/mkkGYozizg7NYLQ2XtBmH/Xk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Jh5fLaD5Rh4PFT1o4d6Sscqpky75D7rITmKwad03RpUYKszjN2FYrdh92wCCuK3CdHxfP3sHnS6oHm+ypTJQeJD+XoMY/zozWJuODSDGytJycBz/MvcwDLn2I9S5l3gXR5DhATdi0+qctLz+kJRC2Q0c+QeqxJxIJ8GOA1s6lgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4667f641a98so852774fac.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 05:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789130008; x=1789734808;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1x2q4dn+cMVLp+9PDO0kgzLAyr/7wEbtWldTSqUF0L0=;
        b=jXT2xEW2P17XbnEG7IkwyJhd2xun612rEfjm5t+TyaOMugUH29Wkdy5Ye3hhSms7tO
         oFyiE/xEB9eA7PAT+K5OBCycvG8pckmj6CSXBP8qRCTHwFlYn5eTeTZtqpm+oW90sR43
         vmB9IRJVHHpFVnMZjJvWkYa/Y5F+dNKiLkAluIjrERH9vUOzc2WPn+3JzqURbep7gbbl
         gCWX0BJHHHmW1YYR4FADn4yve+cHJGlW+OnhvUbZuUGp6c94ag98WTX986NnJPQ+bnxJ
         9kenppdfEEh492YnFu1j+Aoy78SlSK/7YUsk4NC6bWiMNLc0Bvn2X0iJLgrMNGPFfBgY
         81Mg==
X-Forwarded-Encrypted: i=1; AKwUvBx+h9lJcOpH7D9/vcow3153wa6YroPcixYq3gtowuGqmOo8tVTYMZiV4lxlnXrmri/KdHenP/m+ehSz5g==@lists.linux.dev
X-Gm-Message-State: AFuF++n3lHq64yabiBA3ifBHSGhCf4LgqvowL8kuWGuXSKcry6rVB9qf
	kVQ7UZSYfFrjt6pf3ZUbYL5WstxMK7HLqL72bcGe+O+B0W/RmwD31hUcT/lAcx8JFpR554XxNT1
	iXZFajvUi2jBX3l6B0S4fP4SOk0HCTA/mIP4cwVK0iM0RoHkj8N1AlFxBoeg=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:273:b0:6b8:ce67:77d5 with SMTP id
 006d021491bc7-6c0bae0b068mr4556925eaf.13.1789130008502; Fri, 11 Sep 2026
 05:33:28 -0700 (PDT)
Date: Fri, 11 Sep 2026 05:33:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa3f518.f2639fcc.29487d.002b.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Sep 2026)
From: syzbot <syzbot+list23d4f5ba12358c4333ba@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 1 new issues were detected and 0 were fixed.
In total, 34 issues are still open and 58 have already been fixed.
There are also 4 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  433239  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  49814   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  20057   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<4>  9371    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<5>  6281    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<6>  537     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<7>  451     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
<8>  27181   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<9>  2714    Yes   INFO: trying to register non-static key in ocfs2_dlm_shutdown
                   https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea
<10> 2028    Yes   kernel BUG in ocfs2_iget
                   https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
