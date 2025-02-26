Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C672698AD
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Feb 2025 06:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551890; cv=none; b=TeR6yqWGF+9FlS3aKTepX8n1Us7a9V4lueN0fO4pspGdixAsOueRuolNo1WStr6kEroCwi9jC0dI7XtWVTAnPHh7aKlCR5h7VXybcJnem/kFAVMx2aTPMRtBIHmoJKvxcaZ6q7PFMkLj1BmAuGP7lzQ5ba/P8+l9zFA0WA22kbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551890; c=relaxed/simple;
	bh=guiF0Wi7P0ZzC1Ced0aQ6A0N70jYk5WtLawsVVcMeSg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QIUYyRK75VdnOimKY/xAUtKUYni27lv5NAmh0NNMQ6ub6P2QxOWtlCb0KEdTjrT0DJEP8YmdR8GFYxGDff3xVW1kTo8jfJPv8r6JZKLxrOwQFDLhOZd5ZOGDGSKgxbMpyxLc+k4GQgJpoUmq3ENRA+qlQh2tv4WS8zrXQSi1RN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-849d26dd331so47183439f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Feb 2025 22:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740551887; x=1741156687;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2Sd3OH8n0uNJj8VT5Bq1G6tV5mGRmXD3SIdjLiVvUw=;
        b=COoXHwjwzqmmptjrXwix+Dc06m16QesP6vrCkf+XPV3yDlX3MH3jYVcVqcXfFVfvpH
         5KJo7GHx0+Rq7euUdXeRy/W4G3p5PH/35EL7A9QYeznFR8ihzyf7+t0P6gfzzcDIqO/f
         /O/2Bl7UBcGbEAGgV/LTXp8pnwCqO6gYJTy6hSZ8pl60pgHBIXVlTiMbkTI/1C0SCKSi
         sx+zGMdqiognAFDQaZkeIAwu1UgVj82QeUdoKGwZzw2XGA4MYbUKNyX3O6lzApQgZC8K
         26eJYO0+rw9F5QgQGcX/lqLbs/jVgGCjOndepCd3r2DcXpAGEiSv6oRkRRNPmmxPjCYl
         Td3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPTN/RlKF9QWgckk/6qvjO26iXZZu1z6V2st+qGZv5DBtN9wP6sjULVsMdR+hvxjwIy+c/7/TTNpJ4nQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfqhIgq9I9KY6YJrsVoQRCFVpl0M2DfjX0gkgmcqEcvGg11bmC
	f3U0I/YU5MQQaW58e0ksgcLgbRwO4MFks0PPivPIV8/YiSPXwYhGV/mZWHKQj6qIila4RrA3k4z
	Ygbop0zVFAxpF3kkzpnJZG+ZsNMZnJLkrSEf3lKJvU8o/kgdkBCcbYP8=
X-Google-Smtp-Source: AGHT+IFNIqlmmdkyElIfBgTMksbFAvD3UKgEmB0dGWiHR2hbc3WlCha1vSR4JlQ0eyJwK/IiVVxa+1etEqawYHKhoVPYLv5Za64d
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3286:b0:3d1:5f67:f0e6 with SMTP id
 e9e14a558f8ab-3d2cac94fb3mr193538655ab.1.1740551887676; Tue, 25 Feb 2025
 22:38:07 -0800 (PST)
Date: Tue, 25 Feb 2025 22:38:07 -0800
In-Reply-To: <674c6006.050a0220.ad585.0036.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67beb6cf.050a0220.38b081.0003.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_ibody_find
From: syzbot <syzbot+2471d99ca242f0f7a2a3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	rgoldwyn@suse.com, sandeen@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 9be53fe697eccf45e5c37e10ffd399eeca5eb489
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Oct 28 14:41:15 2024 +0000

    ocfs2: convert to the new mount API

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15fdffdf980000
start commit:   9b2ffa6148b1 Merge tag 'mtd/fixes-for-6.13-rc5' of git://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c4096b0d467a682
dashboard link: https://syzkaller.appspot.com/bug?extid=2471d99ca242f0f7a2a3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172412f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12155adf980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: convert to the new mount API

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
