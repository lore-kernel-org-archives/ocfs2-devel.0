Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0967028FFF6
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 22:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765404545; cv=none; b=KQEy3g0BPg4MUCfrWodrrOtsUgTpivmKBHzftt+amZxAIWpMhtcCpMhlSGlmevaUGPdFBZo7aKvApKCh0uwzjRKgt3cMMYB6r6qTyi0jcDwzLzktU1VLePFaTZstcYaoIipSVuhINt2gFDMqOI6nBNyqeM+ZdnFWBJL1/v+dvm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765404545; c=relaxed/simple;
	bh=dhhrwqNZRrmj9MOsCMnRPTKmFi18x0wS5ZnKE4M8YXI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=W1Mr6wO1jv81GrtOes+yF3HAeW8NU89B0uDtMHb5HUJ5l8P6ReiCs+ZMQK2NvyyB1h2y8+YFjC8wuRHAUxngPJS9dUR3th8ZBnNFXMwg3KD8iVUAj0z3YkTBug8CUFXYfeZ7oPfkVBogQdBj/IvtVjBZJMUbpSQfFCeaLbPAyfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6573d873f92so247647eaf.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 14:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765404543; x=1766009343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnyjkAnu1mfzQ7qGVEqb+KdCLKNOw5J/zzC2jGNJLs0=;
        b=qHpxbUPQ0Uvc/7sILKfvYLz67P3TG1STNlgxpm4XhkH9bNh15IXQ8ltKFFgi7Vlawg
         d63ukjPwPjGoBMaaQrl2k+jM3nSr4aJfuSZytReiRGexKGPgf0lx8KY4B/rPCDYRUTAi
         0IZMjrg3ck/LIrmsCdOSnVY0teBGPE08ogtPJZEsPd0xRfvnv/Hq25d22faUfrXmWiK3
         tS2LcQw7Ezy60MKcC0aLEs9FV7/Ykr52G6Jj3xvtFTKFA//M/5toQT0meidFm2E2WQBS
         rAugfvrqmFlVR6AD2hobT2rNCkBGfKPHmbN+9z+0H+kKe+TNP7qIisbGVncmal5nhHG5
         yqzw==
X-Forwarded-Encrypted: i=1; AJvYcCWsMq6LSYI5bnJv/qchIi89ZbrsSLhugKn9/SJR9fn2W40XUqW0krKmV/dB78BSV8E6mBvwG8eCC2EH6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YydjSOji3dOwGTJ3+RJp1h5YMIP9/HgJrjqBLw2H8UkrElZEhva
	5nPRjchxQnzrmw6cLMWwzbe2kSJumtppgopSXlsGea4qT+ItvdL5j1x8nrt8BOjANKeoZUYuw17
	J0opcoQizxrXZVdD6bWq0+Aqz6B83ypRF8zzBRJtb6ALea/qFs9EyK13uzfg=
X-Google-Smtp-Source: AGHT+IE/bY9J2o57OlEmWFwHjxOgrBtmeBXF4Bup+F4cMm+mfaSCAdkAtoXwDBKOMWkEviyGjQOZ/myiqRoAJK8TdnIJFpOnd4Jk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d04:b0:659:9a49:8e11 with SMTP id
 006d021491bc7-65b2ad28611mr2431714eaf.83.1765404543206; Wed, 10 Dec 2025
 14:09:03 -0800 (PST)
Date: Wed, 10 Dec 2025 14:09:03 -0800
In-Reply-To: <20251210214730.GC1712166@ZenIV>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6939ef7f.a70a0220.33cd7b.001b.GAE@google.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
From: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mjguzik@gmail.com, ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Tested-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com

Tested on:

commit:         0048fbb4 Merge tag 'locking-futex-2025-12-10' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107c7992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de48dccdf203ea90
dashboard link: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10c51a1a580000

Note: testing is done by a robot and is best-effort only.
