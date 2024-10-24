Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8437820311
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Oct 2024 03:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740786; cv=none; b=Z4gVHVKI0fg/ABH/1sc4TnSLwTbb5n2ZW0zCStwR9XmCOfQ7gPb2VbbNtKw0VZGwTuq0xemch+PBafKjZleW588oe4xluMCbV6/dm0Tu48QQzyUwjbIwBDTzeQny4J6mz6qEbDM+8XdO95ZTE1XNLA/0mQCSXkfbEtssU+hQ/64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740786; c=relaxed/simple;
	bh=e3zKNUywK3f+E3PcbbBNsXZ0oD7/qbnvwnvYo/qCJis=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=T2bKkXY4TIZsTLQJcXcfKaIdSWonrQ+jsxvi1xBPp5pF5TzLib0PuDHgbaNCxj+IxRzZGIdeXd1cbWu6IlQb8IJwSqz8bXTSn2m5Bkn4A9zZ2LeTxNKLPH8fFeBr2Y8nTnC5otFRM3Np+YOrTm9GP93XGCBWVh8uoYefiXja82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3b45bfc94so5898615ab.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 23 Oct 2024 20:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729740783; x=1730345583;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwaey/nAqMM2vw2sYH3cFG6qAbmQNd5df9zlBMhOpnA=;
        b=qC4jOj+h95MqSDbQWWaemtinddfv8f4obPejNzWIQjG0n3MBR+cGag3Mdi2Wiern6+
         eaazbWl5tDGMDo3BlBxHqefAEKQ2clkJLHx8kDu84q7ai4snek2sp3wQnaZmELbYfiy0
         lfbDglCJikkI72LaXu/IbpYN68WKDQ1VkV2HbsEbO9iK1PdTN083FoAaqR4x0Clg7JQ/
         tDlZqGOOLlqp6PCyOsrCbBf9QIsYGPT90qwMV/BYmk2idqm6rBrLI6eIRFML+NnZlr0s
         joG69lV6cw59Bheey6WZ257GKSyQ4nb2dzeNyBYRUfYK+zaUFi2Ub8OylXbtrD/wNVCX
         UFMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTu8MkfJf4tP0oALT2yCN5bhY8+U5945GSKKAXMrBzADEzAN7JtCy+HZD8C8vT8nBp9vFPyczLskReEQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXeZePclFslQwhSo5cMo9VR6lx/ZYkgCB6fDjru9pkg3gPQKHW
	DijqxtodkiUc9pnMJODNbTZksTc+RrqmRC9K1Jk0FNKd787EgRdDQjem3p7bDG5bTNj5NWJ8+uO
	CN8DnN0uIrzNvwwH8nG8ylGTL8uHVDoBOWmwWZjzyZY/bKi8nKwy7nto=
X-Google-Smtp-Source: AGHT+IHC414wup6Zi/6FlP1TMTV8iTfkeqhqK87wqHZ5SJ92LcY9RPChxNWb/PL5h6yfu7YHXp9UWjaHfjfIVDxN6jUkt+CsA0HA
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b26:b0:3a0:9829:100b with SMTP id
 e9e14a558f8ab-3a4de82d330mr5928305ab.21.1729740783628; Wed, 23 Oct 2024
 20:33:03 -0700 (PDT)
Date: Wed, 23 Oct 2024 20:33:03 -0700
In-Reply-To: <00000000000070a44a0620047696@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6719bfef.050a0220.1e4b4d.009a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+5d516fba7bc3c966c9a9@syzkaller.appspotmail.com>
To: elic@nvidia.com, jasowang@redhat.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a3c06ae158dd6fa8336157c31d9234689d068d02
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Jan 5 10:32:03 2021 +0000

    vdpa_sim_net: Add support for user supported devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1047cc30580000
start commit:   c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1247cc30580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1447cc30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e0b640580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107248a7980000

Reported-by: syzbot+5d516fba7bc3c966c9a9@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
