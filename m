Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C553A7F67
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Feb 2026 12:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294864; cv=none; b=tnqZYk17Em3wnI77q1BA3TpsSCuPwEpyNKHAOEQEjfUEnuaoWyhgdJyzcvQjsMkGJLlLMHPVuNFEt1cDUQTs8Iyg90cvuRKLARzryisr3RwoKxCerwUksphkBtcgtmR+OhOeOGAYErMERtm6Drca9+dkBZCivyU+qmO5Wjkna1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294864; c=relaxed/simple;
	bh=rwAx3jlhLfP89/FtIztSDCFlFWYKdsoojhN9EUyH4CI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lLy/0/2qM/+qnaBSkYv5HogStyPydVh4wgMByglnBwkt0acBVpxzX8WPR9VuCTa/dtF2AGCkF4+/xZbrBCuWMbkW1sXWR1wM/sYAx/imwQiE3KnLxVH676QHjQEXJ1iuO2E24Z/XmvAO5FrpfDu6pyHU2ZUig1JsFJyj66ROnz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-66308f16ea0so3630393eaf.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 05 Feb 2026 04:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770294863; x=1770899663;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQ/xUhWD101JxY/NkO10vqwZ2MxnRVjLVTPmLR1kR9s=;
        b=Ox4sksKyBqrrIZHuHvGUWeAATeYw6OhvR9fp19xSopLicBJsknQXAmLPG4M+a5I/Xx
         kMiqucKxa1m3wCH/OELHB9QA5yyGb8Z2Ophv3laGbxazWC9EINXT9+VTBm0HZlsIhlaM
         jy3l+/BcWwLxCRB/k0TCZgJzaU5MI/qtUfVJ1tWu78zWBN+2GslPG75Q3o5dfKepgi3d
         trgcKkd0CbUvCj2GJJKZW3+CjZwxmHdDkTUtNUJ3jjpDBZvma63m1bAi/lAwmmYNWfZS
         aU3diUYluD9EUYoD3PH2Gv3dlqOX5PSRwbSGZPoa5AgACfDzogcbzSMFfjb7XK/ffiQz
         VWMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOpvwAdFqJEWIaSLXbRbTSgG8+Zp9Dxe11yFWfu8b2MXarGx6W29xPY3tr2hz5FiKHGu691Ha0tyG8eA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzyuW1YrPIsnQDdwrY+Z+Arr0snL0X/WLX2VWde5lXD1xu0cc5V
	98H2IeMagmk84XLqPAXphcaDKSWtXAxRzWqw1BIIA8ot7b5itR3NDLEc2nl4kjhfbJOABR5nFXg
	uKAqvPQsNlvCz7Xbqi+RS15X9YWukVIQb7vgLT7cuGGQmvGNdCsV0aFFkf8U=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:201a:b0:663:1239:9ec8 with SMTP id
 006d021491bc7-66a20789feemr2660206eaf.29.1770294863655; Thu, 05 Feb 2026
 04:34:23 -0800 (PST)
Date: Thu, 05 Feb 2026 04:34:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69848e4f.050a0220.3b3015.0021.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Feb 2026)
From: syzbot <syzbot+listf657cb067844747ceb9f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 5 new issues were detected and 0 were fixed.
In total, 55 issues are still open and 39 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  374586  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  43639   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  26344   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  24410   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<5>  16760   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<6>  7697    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<7>  6698    Yes   kernel BUG in link_path_walk
                   https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
<8>  6210    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<9>  5333    Yes   possible deadlock in ocfs2_del_inode_from_orphan
                   https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
<10> 4033    Yes   possible deadlock in ocfs2_lock_global_qf
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
