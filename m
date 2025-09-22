Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE628134D
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Sep 2025 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758576065; cv=none; b=YmUMDCB99lMAqVaRKDCEzo/+AxlcAcPkmvIi5HqVgmPT+3zCADj5zEUu4x6dbbGAzjp4iPv740pTNCg3Smw88sbVNnO9EboawkdoZg9PmLudZL3V7HHHH6sPC+tiGFpC6POpgw0xPnxLyR7cwGo+k1MugmELNSyIFsmLVi2GBzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758576065; c=relaxed/simple;
	bh=r3NpGz1qBNHJUaKYOiNUrMQdMwwoP6Ucp5LUoYR9YGI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MD1vgYXXyBwdV4jLuvg4mnHrK8J6Eodkos9uSrrb4cwFlolTN8yO9NcJEzZvr7ZvAY0iSQxjOhAZjPIek9jky/bnHfY0ZupsLFSjhybE4swDljPLtWW6DQqvvLHOPIESB4mnecmXTfxwnIQ1shHDDsYYX1sL6yLmRw16nnGFdaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-889b8d8b6b7so540323139f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Sep 2025 14:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758576063; x=1759180863;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEXVzVh1xRpn36QUJyWBl0yE9J7HW6QGqDG73VIJJTE=;
        b=n8j0L+MklfIl11O8vQf069fiJGJC1ake+Lq02t//KNwayt+AospLNHGgmO5ovOpDDW
         hCg8h9DzglFBY/t2doazXT3tJK0r8S2w3FSKdYSUn55s6J7fDmlqsGIO9tmXpXWht8Hu
         1BOcTGS28sxnDx1abfLpo0PA/Iud+V1z48qdi6xFO+VLAMscpHV7d3DuuZ4uEhFNO4hw
         Wsw/IfnErkOVuJFjBzRl3bPPr56zBjBqbWdoDe1Okq8xe89uc/UxvQMk3iICDfOuoMKO
         rjicPgcwoV7aSmdkPkKsBiTFBtknL4bTHpAlgmAI/K8VFKb0trGIOPQeXrss9wTLyolK
         wqtA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ2yKoiaL9Lw0C4XdbnSJMAeptwjseHGQCVVRdnnOYCBVBXP7O1Ff/18MwbM2jsUV6w7dFK1JD1Hs9pQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzL4ILIqo3/Vz6cOz62oir2HtjkNFMoLkFbdifDynodNjydLAyY
	RlvjrogfsIDPBz2/icdfsw7HvVHiun+p5wT3zajE2/Nz/aa2itdPScUJvCENPj4jveKazbLeO66
	+ZH1yMINakJonLeAdv+gNSeap0JFafaC3pC6PfwswBiA8AotgP9QRF3GJQ7E=
X-Google-Smtp-Source: AGHT+IHJ5Lcy1PFoE+1HFqUxDvjXb3iEWiVH3SD6SKxbsyUcUF2l8Pan6sffL9AvGWy5az5bN517uy1gywSblFEpVuz8oT8HE9qK
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1542:b0:424:86d:7bb9 with SMTP id
 e9e14a558f8ab-42582209805mr3563505ab.0.1758576062967; Mon, 22 Sep 2025
 14:21:02 -0700 (PDT)
Date: Mon, 22 Sep 2025 14:21:02 -0700
In-Reply-To: <672b23bd.050a0220.2a847.1ba3.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d1bdbe.a70a0220.1b52b.0003.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] INFO: task hung in flush_delayed_work
From: syzbot <syzbot+ab509d831d9b0222f5fd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, glass.su@suse.com, jack@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 276c61385f6bc3223a5ecd307cf4aba2dfbb9a31
Author: Su Yue <glass.su@suse.com>
Date:   Mon Jan 6 14:06:53 2025 +0000

    ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140da8e2580000
start commit:   2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
dashboard link: https://syzkaller.appspot.com/bug?extid=ab509d831d9b0222f5fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142f4e30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c00d87980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
