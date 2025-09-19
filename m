Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF1E1D6DB6
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Sep 2025 04:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758254464; cv=none; b=H1nWD43cSD4Nkw5b2gmyv9IvmrNIsefo8izn0G3mKPsq9Lk5og8gubBMsneUA6nNXIBEYT15CdM/lV4HoK5+3SsoQxRlBZemNY+VwKsFFf7Ho2CFxhOmnJlm3D9EU2yixTcvbTAT4M/JlxYVCuOMO8zdjIvqCRvWYaguU4rO35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758254464; c=relaxed/simple;
	bh=ouvabztvBePsJ3eaH5/w487SdXuqBTErwzdVgnyu3ZU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V3n+35iM09vyDqh69f/GFxMAg0hR9DvcFB/eGU6ngrwz7rC4EUtltnYSzl5lQ4GbDxO/1Ltsk1DyyNih3ZoBHfNKxyt/09v+gM+jL2hvI6MVOqkeq/49F27Y9GANne89kb7Xdyhq4xL9HCawdLCDlFNAKLraLvd6p+hVHCMGDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4240a41d2caso20644035ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Sep 2025 21:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758254462; x=1758859262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IulN+igi3cpw905djkzcEMAptMFKIjnsWKZB5c5SZ2E=;
        b=UiloaAD9EKTY2/HB3D61CxBNUPWkC/f4/e9T3g1VDDZzwaRWJb0nayuY35RUu+zZbc
         0L01PM2cP56blaZszKN5/jw25e3Bi1N90y0r4DGg72FiTO5wf930fRVj6jPb0SOnMfsm
         vDZXQm1HhS1mz1Ir92OBqLjVImkUX927yh8ens1eVC/biS3WU1kLqo7ZvP057hM76OXy
         z5UQJoUlm6d0HeTDDiBKx+KBAuInfA1zVZNxjNsBnkvaVivDrvRukyVZ+75bIpjMaEpC
         QGDfxWCFwP85rEY9BTzOCbgxFNJt7GYhmJlvq/tg+dGWxyo11mAT92VherJ6HV+onZvF
         M3Ig==
X-Forwarded-Encrypted: i=1; AJvYcCU4qtb/Dq29qTdDcRumwL6UlUoq6VnARL4hChAIyab9r0tE2otIOXvb2x+wnSczGHm7hHc11TFh74QlpQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxzS3DbIK0BrIwdumGjVV+7RlkfL6td9BrcgNHLcGBiUctdyAhp
	7N4JjVI09BAay/dmmo1KB001xWoTqKo62jhl+g+B+sS1hapDNIct6TPvj8SEvGMYxT4iMveN0Ua
	WwenzIA6Sae+60PhZtbPkdaCEWgTwCprqxCJKamO5Q0aRzcWJZ2zEANFGGuI=
X-Google-Smtp-Source: AGHT+IHm+W8tdy68zb31OkCXSByh73N7mrHV77cGbyN2ywRb3nvvaxdLIN0Ne7mxO8w4bZQz4Zp5leyCBiPf2MBrJnKAl9rcZsLE
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4606:b0:424:8598:59c4 with SMTP id
 e9e14a558f8ab-42485985d46mr4379665ab.18.1758254462605; Thu, 18 Sep 2025
 21:01:02 -0700 (PDT)
Date: Thu, 18 Sep 2025 21:01:02 -0700
In-Reply-To: <000000000000c7e54f0621e8a14f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ccd57e.050a0220.28a605.0019.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_fault
From: syzbot <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, masahiroy@kernel.org, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f79dc03fe68c79d388908182e68d702f7f1786bc
Author: Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue Jun 18 10:35:21 2024 +0000

    kconfig: refactor choice value calculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1154ee42580000
start commit:   8b789f2b7602 Merge tag 'mm-hotfixes-stable-2025-09-17-21-1..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1354ee42580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1554ee42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179f40e2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109acf62580000

Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Fixes: f79dc03fe68c ("kconfig: refactor choice value calculation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
