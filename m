Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8FA211282
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Mar 2025 13:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743426503; cv=none; b=j0yGLYmI3Nd4NYvaPGVe5pix+dGfV+zE1Qk92s/xIBnvgD0xtGJTIG+bPSQB0FJY2X/h4KRsD+vZRaEA/Ichhtq/pSqcRvLoAfxMu4ftL6rWu+h++WYzq1OhlkWVnEL+mxITmfF2S+bPyGIfJSuD9H6U7N0K+tcDeM/P3Vafy2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743426503; c=relaxed/simple;
	bh=rQOhOxCeXpud3m5iVUI722VfHj3ccanf8lV7ulNXxHQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=H+HfBijNHE160nMP1HSd5a7tCNAfLd0YPqe6w+SLepzz5TxXpbtrSqDxc9bkL+mJTU9XuO53kgiRVdbPdWyYTM55xLBroIeJnbtKwX8O/MNmUMBCul3SiTJUCngJ2rc5qKTt4yMEX0iDaFxeaxxpQNvwlTyo4ea4YFNwwaNSDMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d6c613bd79so4443515ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Mar 2025 06:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743426501; x=1744031301;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zbm7YxpkiWUEYakqF/l2hEzPdOv29cwCLbKsQd8Pxlc=;
        b=Rr10c0qcPXSwLgfVD+wme+lduQoCZewFRSTXKfYf4SBQAtDj3gykHdKih2WcUsztzq
         gz0pSUokGX9d2S62NbXqxM7G2CyGQo9TF0dTPhT5HEgRKF8Dps098mhXNnwn8acyLp8B
         MqSvzflsf00evQW6i6wnJQctVRM2EM3LaixVvK0fQXQEwa64EEczM0pU/khR16uhFm1n
         uy3sk7g2qV5SL8rfrxT9OjQOQvLKBQOgbx9UakCKUkRtoxY8U+B0AZcAHmjH4dao82Cl
         vmtgOh3UGrlVKvAo6W2Wp+UGPK40uxagpK3+gXF31fQgDJQvpTLWpivgSnLkg2JdfRtC
         90Mw==
X-Forwarded-Encrypted: i=1; AJvYcCUsng9cpJoiGq0EFjqIEwYGpQBZW58b1PG/T9Jb5XE/11MBuN0tFZx21zOc2eDtF5fVZoAZxTKZxeDKcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6RHrN6b8h7cvgL+OtUuqtNB2lWtLbGIQRrTZv8e7qJCyJJAfG
	FXjCPHOjr3U1TNNNN6wtuVUhkpT+iODeTWo301Isf20NXHbRV2DTDPX4muPCzKqS5n38fW1wS8Z
	949Y7kLAudOVGN99nS4utKpKPeBZcnbSv/F4iYrWliNJbmv0LV8dWgWM=
X-Google-Smtp-Source: AGHT+IE6ZyQphv/9VcMGurb/ClAhzOMXBXjCpRW/LTu7Xme2g0kHWZ7CMOIu3sFP2LtcaRePEYPC2jlS1Ehx78SGZYD2RxUxGvK2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1989:b0:3d0:bd5:b863 with SMTP id
 e9e14a558f8ab-3d5e0a004bbmr79287575ab.20.1743426501461; Mon, 31 Mar 2025
 06:08:21 -0700 (PDT)
Date: Mon, 31 Mar 2025 06:08:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ea93c5.050a0220.1547ec.0143.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Mar 2025)
From: syzbot <syzbot+list9c9e80ed7b87cb3956a3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 4 new issues were detected and 0 were fixed.
In total, 73 issues are still open and 15 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  146425  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  42712   Yes   possible deadlock in dqget
                   https://syzkaller.appspot.com/bug?extid=6e493c165d26d6fcbf72
<3>  32565   Yes   possible deadlock in ocfs2_acquire_dquot
                   https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
<4>  15089   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<5>  10599   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<6>  10568   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<7>  6346    Yes   possible deadlock in deactivate_super (2)
                   https://syzkaller.appspot.com/bug?extid=180dd013ba371eabc162
<8>  5249    Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<9>  2125    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<10> 1957    No    possible deadlock in ocfs2_lock_global_qf
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
