Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817A42AF16
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561944; cv=none; b=n0D+RhKoWAbQcPR0t35vxPbaCdwF9AAfbI/l7LxhaLPbqJ4plNaI55cGfZoRFgLF2VN6KevQcAnm9nsOwQVtTfp7X879S+IFsCEpz36lxKPfSo16jhUc04WauKBODsPc7Fw+pJkxiBGiifFYLLSpKehKfr3C/mCsrsbZaDhv5y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561944; c=relaxed/simple;
	bh=pXL1QrYP756TmKDQBZQtuKBAdGFAtIf0OZ/LQA/bTIM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ovLIMoCREiS0VmAyBq4mxgmk8EJ/jGTk0LbpHEKPnHuhzuVkgq8q3+QwSSpFFG2ezenNWyNNS0KZHfgFuDw1ndhrm14HmHix6P6/zRuaJXdwSIrhQ3LRDRvd7H+Z0KKxplxOASxFarThxlheP2kkI39KTiOTtRVPv9A9AuBENuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d14950ac9fso38631825ab.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 11:39:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739561941; x=1740166741;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpmcrP0X5CgyWJvMhCxkALSxzE630NH+Vj+9LCM22q4=;
        b=C8H6f7yRyL8IecXoHLapfyJz2OjxDs10UOC1t+DQDHOKfctFBWO15+ZGIouA9oSu4X
         DPupRr+jIpxUnX6KyE3iM1CC8l66L89P4f3x53T1FbVKxTOysEihyLlPyz6YwN5bgHtH
         Mkmah8eAwg71S4sR1C++V8dEuHCRXbmHyOwjQ5Y/JFlcWvoTj6UFzRXe05kVm3QFtSqc
         aoAIC3T+fcMo8x7jEbsMPEFiAJYfsz9eOf4ArXdQQLMwxacZJIFdlfTbGmQpHpZauEFD
         R5F07KM3oSJv135o69iIDGxKR+NFilcpsDGwqR92bXJh4FpQbwr7JfvkwwOwFZlCBibd
         cRpw==
X-Forwarded-Encrypted: i=1; AJvYcCUxYCr8YBc3JbqlaWS+AwjP5O8S3/JGnc45n+s4i0Ndrg5cVzhFirZr+NKITbOklzt4vShniIaC1ml6lA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5yoHiSlnwomYr5p7H+Nkbc8mVIKAXqdBYa+/aTf74oXn4CuyE
	EpuHMMjspJyJs8f+4kgxfip/UxJ3hIdnWcf8Pjisl8LIuvXVNeZRt6YRSOshdi3gGbf5bBOOjX/
	VVTcbrhsnHLzWw6Lgg7nNbmaHobcVjgd/Usdee9C4GKlHz8eXT4wkjhQ=
X-Google-Smtp-Source: AGHT+IHwYKRLC3mbDJI+ep30XOHzdBQ/EyqbNlPdsQu/0k9zNZ8cqCjKXSehXJ+r/XjgakVTtETWIRwe+z/+nNWugMzDa7R54Mqh
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c548:0:b0:3d0:24c0:bd45 with SMTP id
 e9e14a558f8ab-3d28092cd46mr6338805ab.20.1739561941685; Fri, 14 Feb 2025
 11:39:01 -0800 (PST)
Date: Fri, 14 Feb 2025 11:39:01 -0800
In-Reply-To: <6774fb7b.050a0220.3a8527.0026.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67af9bd5.050a0220.21dd3.004f.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] WARNING in dqput
From: syzbot <syzbot+bf75d2e9b63fe9e0c330@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jack@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, rgoldwyn@suse.com, sandeen@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 9be53fe697eccf45e5c37e10ffd399eeca5eb489
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Oct 28 14:41:15 2024 +0000

    ocfs2: convert to the new mount API

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15b68bf8580000
start commit:   ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
dashboard link: https://syzkaller.appspot.com/bug?extid=bf75d2e9b63fe9e0c330
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e5d818580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: convert to the new mount API

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
