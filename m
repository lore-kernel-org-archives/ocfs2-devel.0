Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3E01D14FE
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 20:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728680344; cv=none; b=SPBLNffPZHEwAhGfrmf/ROBUTRQtfdgmWan/kYPgNHV1ZBRqO5EKE+MmZvY95nbNw6ZqHXlm/nRuKLGmFV4JoYyp1iBnIDcfAoVdhQIE3VsHVekomKMWKfma3z+xzm6PSaQ4r/ufyOFxq8MQmH+xzR7qchN4/m+nPVVRGinI50U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728680344; c=relaxed/simple;
	bh=dxgsExbIp+OVezKK0BZ0B+riyJW3k/G5OfnVOB1l100=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oJZM36t2aQI0w0fV724S2hELmGxfQAjtZleYkXzjRGbKAwNW/xaaUVgiqEhvuDTaKcNzz0pNCHUOQG3/uZWID+dOYnMe5ByZRVl/4+eYoEs6f/eZ/qfbPXQonK9QCoB3ijF2jFpMLGca1Xp45jirLApkMaojl3+xt+Zr+nG+M5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82cda24c462so210057039f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 13:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728680342; x=1729285142;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xl8GCiVxkqpqWaPtQKGMQtJ2j70cmGQyjMzqhZ48zY0=;
        b=PlNxaVLU9Zg33XiPc5qZJTQc+yLb2fwrIJ106kKFwh//GLO2WRsjd4T64k3xiCvGdV
         B/cM/xviAl1X6VyC4jGu79gOzlSZSRx5qcQDl3lynWP/dN8BEMmd/icYfkJ6yzbR6qpZ
         nC9mR8QWCpE9uqoULy1ytCrkJd1HFPVweBmsD0y6BYyoFr2YpF+tbD6jHUn23voqCUrT
         f347y6smNLem4b2aD/NVRjdcqaogoqk2dj0/Nu++gZwlTqb0FKZXGTY9ejYxx0A9NLsy
         tMhqB6bB7I4NKz+m2medeZU+YiynEpjYMRnKUlUr5Kdl97nyrj3pVYUtw6HDb9jqrX+U
         vp3g==
X-Forwarded-Encrypted: i=1; AJvYcCUJRDQqj0k/b6QknUWmja7XYt1tGeOmal8Ez+CDikKTCgtN+MBQk/06QD857+BbZPHHDZOW/oHCmIx7Mw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6/rnRs/7XaKmbMgr3xO7pWcMt25WdjrwIXV7oCBnr8lpaul6Y
	ew6Ikq9Q8wk1U4T5Tof7tmNvYhf7oqp7Wts8jHzJ1Leli/7D6qinHCdO3BioUakhtGm6JmivCuK
	As9Xnzh3/7HYS5LJjOj1tbKeoYQEp3AF4ZJjWSUis7O44PLV3iyHF0B4=
X-Google-Smtp-Source: AGHT+IGMg+5mViMxz2hTxCofHeyOpJMtgyuvHSHMfMT+W033sOWNets6kAUVWDyE1p2Xj3LN1YnzHmEyd7OXC4kTEMqAcbfVebMk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:164a:b0:82c:fdc2:e25a with SMTP id
 ca18e2360f4ac-83a64bfd806mr68962339f.0.1728680342268; Fri, 11 Oct 2024
 13:59:02 -0700 (PDT)
Date: Fri, 11 Oct 2024 13:59:02 -0700
In-Reply-To: <000000000000cb688206213d1bda@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67099196.050a0220.4cbc0.0017.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_fiemap
From: syzbot <syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13a0a840580000
start commit:   1d227fcc7222 Merge tag 'net-6.12-rc3' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1060a840580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17a0a840580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142fc840580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15026b27980000

Reported-by: syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
