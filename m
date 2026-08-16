Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3461F13B58C
	for <ocfs2-devel@lists.linux.dev>; Sun, 16 Aug 2026 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786920067; cv=none; b=cNTrGRLf6VuEPp4OfIKm/GxwPBZ2FkqOBo406lGB8fEuDYhb/XTH1dfsKbRQZ82DdEQnRYB6O330ut4SwkaHJbnnmebSwlPZ71Q8nyT+qrk+OxXsXRnSpw+lyCgwGvrnJ/3a7v6oMTNoT7T5kQRWuqXgIDMd6TSMK98C77OgEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786920067; c=relaxed/simple;
	bh=TBpuUbxTgu6iYHxvOoTHRegy3Y4/zVZvFaAmf6Keei8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YxRhYCeAsTaPnbeOuJXQOnmtmzGl4MNL2+ZcjAZxAOOMC6LwgJKg7YbsSFvB9U4n/3TITxBnlsyKceAPxCLuzZjjuXhKvgGx5KH2rGPKF37YxyPTJ97z2Flk+GAx31cRIVav0EgjcV89bl/7BcZpdV/GY146Clc6x13WWqfnYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6aea69817d1so2792353eaf.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Aug 2026 15:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786920065; x=1787524865;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VlWN7/9c88iOYmcK+eYbsS7lJz0uxrVGu3TW/UPW9rU=;
        b=C3hAyuN3U4fqc7+wcXzNtVFznsuBp4avkZHKn9YYnO4Jf6OuS5OXqlc4NfmfmCzuI+
         f27AoeuEGW23wnkZmDTmA4Gi42+iWeTdEEBhxo4P4XVh1ogyUdkI4gMAj0B8AqU7kUJl
         yMCz4xdx8w2fNk61uC8cy6xS68u7j0CbgZHE4svkbFQzEAvH50xZsK+JQICCG7iBtlxR
         tx7KylMxi7Xdv1Zcw4HBvzw2iB/genq5ZL/FYtta0OFDLp3Ai6DF5ZoMlsm6NQoYOSmI
         5IjQnvWVtEJkTdEhgA+TTJuq7iK79k6UpfivyJi+80ljb+IglRA8B2Hy7Nt2+gfCKZqG
         OXPw==
X-Forwarded-Encrypted: i=1; AHgh+Rqur3qsNuZrhT8GhY7Hd7Of+6+aKplFG1gOvTaqGBZcMtxgmuESwy7BtXUMVvcip6regTaBOPu05I+x0A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOaL4tuKlBqq665yUIZMPSq9GveGnLg8SP7FwL50m1HCwUaT4o
	37x1k/LSkevvFCBXPqimOgsogb6xWlpPYlE+Y2weLPNTdMIsiQw6it6J8G+6mddKuqWcT2GNuM9
	OXATps8Is8UDZb2lhlXiMFwBreh2uX10IGXvyxkicNYWaYsmDZIwQZG917do=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1788:b0:6a3:c52b:b94d with SMTP id
 006d021491bc7-6b0d5fdf254mr19671860eaf.4.1786920065191; Sun, 16 Aug 2026
 15:41:05 -0700 (PDT)
Date: Sun, 16 Aug 2026 15:41:05 -0700
In-Reply-To: <678e8256.050a0220.303755.0081.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a823c81.f7a79266.2f965f.001b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_remove_inode (2)
From: syzbot <syzbot+ddde294b94666bb51266@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joel.granados@kernel.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, teddy.astie@vates.tech, tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f24df84cbe05e4471c04ac4b921fc0340bbc7752
Author: Thomas Gleixner <tglx@kernel.org>
Date:   Tue Jun 9 15:14:45 2026 +0000

    time/jiffies: Register jiffies clocksource before usage

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100b7a79580000
start commit:   2d3090a8aeb5 Merge tag 'v7.1-p5' of git://git.kernel.org/p..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9e42545d0c4344f
dashboard link: https://syzkaller.appspot.com/bug?extid=ddde294b94666bb51266
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157bb0ae580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c4e0ae580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: time/jiffies: Register jiffies clocksource before usage

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
