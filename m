Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780E24466F
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Jun 2025 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749572886; cv=none; b=hn8QiKuIhwATI9Ct6RQsdDzHuJTTaF+fx/TjgloBlGVZTsRo7TL5JwNPytKsaJAUVSJN9vZxfb292Tj3gLUe0uPx0jLGFPqIlmY0RS4g54NuFtCxVCteNcV6r+/65XeW0yW4NsR6+JbGKTKTSfFDknpyg8d2/YoVknc+1QQDNkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749572886; c=relaxed/simple;
	bh=NZ8txLSjEDDNhoYSenJN1Z7u+GHqi1aA7B9rWdUaoBg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dj00oC/9SA2uznF2Sga23GesjfaMLwf5NidD7yZMC8NOLglLWvXKIFPm4fGWptIPFCERbveGBw1vwHf6LaUfv5rV/iRP92zOv0iPmBfcLRTT9Cksv5rwm02MGHWqKnaLE2c7IQFns4jH/14V3KSYlC/2tr4+zQTw0q2ajgSwPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ddb4a92e80so74564625ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Jun 2025 09:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749572884; x=1750177684;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKVcBCXq0OedZnKIRu45S9KsvO9xdgEfQXFKoQAmBnk=;
        b=EzsrXXwYekM1LGBOdn+g0fQ3uRKS3ufFS/jTu3MPdeSupMuwTkcLF8beDnj5drLKJY
         3IeyJH2PUeVFEJbPq93QhTms9OJ9cNdjKvpu5rKtVHbV1H/TxkjIVatBEBlsThaDhI8B
         Frbtxw6VL6YX5/AkvvF/gz/XGEdEXjFALJ2PJ7kXsxhOAOD/CR/zh2m1RdURVzHudhSe
         7kLNTsBmr23L6ari6xEwWleaqXrDzacDRxNPyb1ftnFqmX7r5xaWlBd2ygFzyHqq4Xcr
         GsOcwX3X5mdPlHuZqUolLs1VYQaZWs778b2at2My8k5NYkCMbGq7c/mASM6brgRUC3rN
         C+SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxYTeJ2OGgT1LVV5SbXPmB98A8INR/bnN5c/GYscKpPqBqdFcgmx/ch4xF+KhwJzGcIojAei4e3XnHfg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwgN9h3jjeOk8+4RnoG08PCmQX4C7U1o9zrpITtO/K13D+pVsHl
	w0Snn1b3YkGnnxjJMfOY4dATJeX8X7Q6q0PSaKo+huz7CkG3R3NPfdslp9gYcmMnVbt/8ULqy++
	4m0u4jy/wrXzEyIJv/o/LIjdCkZnkz3UBwOSXARGvvppsHiEVbWZa5enCK20=
X-Google-Smtp-Source: AGHT+IFbe+5OmUn7MHckxdI37wOdeeupiqUYo7HClY/nGOfpE4/xdUg9xXcFSJMbPEYigGmfIgiZWKV5yy+bvFBO30+psDuPY+zK
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c82:b0:3dd:bfba:ff9c with SMTP id
 e9e14a558f8ab-3ddf379daa8mr5086285ab.11.1749572884398; Tue, 10 Jun 2025
 09:28:04 -0700 (PDT)
Date: Tue, 10 Jun 2025 09:28:04 -0700
In-Reply-To: <679f7c8e.050a0220.163cdc.002f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68485d14.050a0220.33aa0e.035f.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in deactivate_super (2)
From: syzbot <syzbot+180dd013ba371eabc162@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, heming.zhao@suse.com, jack@suse.cz, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit fcaf3b2683b05a9684acdebda706a12025a6927a
Author: Jan Kara <jack@suse.cz>
Date:   Thu Apr 24 13:45:13 2025 +0000

    ocfs2: stop quota recovery before disabling quotas

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123ce9d4580000
start commit:   8560697b23dc Merge tag '6.15-rc2-smb3-client-fixes' of git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=170d968a88ba5c06
dashboard link: https://syzkaller.appspot.com/bug?extid=180dd013ba371eabc162
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d39b98580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fbd204580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: stop quota recovery before disabling quotas

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
