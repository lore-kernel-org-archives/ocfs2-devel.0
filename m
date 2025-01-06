Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37C1D5ACD
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736146505; cv=none; b=WURn1+9i/RBZRxlYktpXNoOR3dCNsdOd3AhZoZempsuUOAN5o4y3EBrGEmf5jMwISDK78vwdEG/nGD2rwJ29Rtpmok95pDAIQa+sWIEpjd0jc202iwqjEWZW4B35X0zTyY6TMLzVYBy/heQkkwmIJydTVtgl381EVxz+jf9I+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736146505; c=relaxed/simple;
	bh=dYD0BaznYELk2BRQv0oerReN89qB2D6X0+w2J6dyIT8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qqzkmn7p0peln78X8sfpuHycKfRE/yge70w4m82UburBCPWOW68VyHZ0JWj6drCA5GBtE95M2+qp2dMBlVk/eOljNbKeGb8URI5auhJtRjHbsu7ZT6f17qRbmnz2lv5gXdmRKH6q+z5tcAISzA4l75ZBcOBJn3kZwqNtHjzEDFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7d85ab308so138602385ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 22:55:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736146502; x=1736751302;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XuAWkepJ4z8I7B8ndFIid0USQIrBbyMpBvCBaxc8c1w=;
        b=G5E8M/jNFL3D7yJeIJnUbq3jVVJd2sKQMw92jJC4otXHjkTOQiMrrYS2fZEb7VTXPE
         L+6p+wfQpWHrwW1AugGqW/OFPGQBy3N8LSZe1zR4jgaDazL08CoIDXUbQAWh833FVxvI
         O5NPXxqlB5ra6atV+fX5PLPhKiJssYAjCCLloX7RkpZVPEKEqcvF+l+cSqxQztv3W6Np
         uHJfgvONQlAfhuBUDDn+AMVZoscjsDqu5c0uEHWjVeSalZWKWUORZlMMtBrydBAOrgyR
         e5tlBL+gHJaCkBcWXlubpg2+6ng4B7WsvS1bNwK0F1SVR+oeTtZ4+oNZ0nJ9jtmGBWo4
         WFGw==
X-Forwarded-Encrypted: i=1; AJvYcCUL4LQ2/yRDvmf8D+zOCBkYOJrBVdK+ljLIXj+fzdC+8fZzJ0yJaqxD4HpUdfviE+DVACPEfoBtcVlevw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1RdGurIxh0OSiOFfexHmZdaXCizMts5wB0fQuPLGme/MmC8Tb
	NpMclkD5HQl0hUZJeIuHugNQ+2DoQ+DRLamLO7ZuVK8JdWLf20Jf7Gyllcp29YWt9qKmsey2pGo
	utJ87LWSUHR0ldKjwIs+kkhFibChg4sNRjJI/9QiYrc5n6bRSjipo93o=
X-Google-Smtp-Source: AGHT+IF+YG4U1JVGU3AXxx4c4NsW8hUgFItDCXK2uD1d+TAsD39eehF6cCOmssk/Nr21vHaXClOFuNCrSuxk4jxYN5qusJAd+1Tq
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:260b:b0:3a7:819c:5129 with SMTP id
 e9e14a558f8ab-3c2d48a3256mr488990425ab.18.1736146501838; Sun, 05 Jan 2025
 22:55:01 -0800 (PST)
Date: Sun, 05 Jan 2025 22:55:01 -0800
In-Reply-To: <6B66223A-7AB0-4591-B431-088A3D94551F@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677b7e45.050a0220.3b3668.0005.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
To: glass.su@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Tested-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com

Tested on:

commit:         e957aa27 ocfs2: for syz
git tree:       https://github.com/Damenly/linux ocfs2-syz
console output: https://syzkaller.appspot.com/x/log.txt?x=136544b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5ad6ebf66b1e197
dashboard link: https://syzkaller.appspot.com/bug?extid=a66542ca5ebb4233b563
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
