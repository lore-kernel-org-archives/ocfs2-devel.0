Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38128000B
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766222225; cv=none; b=mPY1W+VLD2utqwHoEhNwn755PjvKxC5MbbQOIKyhdF4uyp4GbmsnIpHCTsEuLJgJOY44IHJ73gOKKQgwQ2yxC8KI5qWmC2NBTRhF/YYzqjMnwrLaj6zJNN6etxso7x9IV4F0DA3To2NTXXnI6Mz/UGhSXuRhq1A7XLinEDAW6Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766222225; c=relaxed/simple;
	bh=vzCYOW+38QhEJ5rMtEdDEhThN5YaR9XWPMZ21spDkdQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FhGJWm9kxqPwIhS4ga4zAEz2T63KnRQCLLbyRYrxNmVTScmq4Oa6ri43tX4Kd6NtWhOHLPeRIN19hUsA/XhoDRXiFxDjwCUKX2ERbTZkGkV97j+rdvpfAJcXqB3o3wSlnq5X4o8miGCe7N6/2GlIxmhtlGQ+EQmMqJiRA4RMUmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65746235dd4so1726058eaf.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 01:17:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766222222; x=1766827022;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkzUAplXe2uPPGJl/0AQIIhOIg/EGQzLCwPFbPngXJw=;
        b=wPzwR+vLPUyymBv88KaDmc1kaIoIPdJm57+ISvQUfVRXMNYwSQKMZkonVU3Mf71e6z
         LZzmyNqC2Eeu2v6q7rUJF+sCkxhWD6/n8uvUiRNqMahBtdE5lhGV2eArbbnFiq+NQGd5
         1R761w2d9ztyq3cuz50ZTA9V0Ap9BWQJmRQC8w5jYDVxeIqjFgw7SJj6y3UhtsKpwYfi
         zw7IiB4rK486nsRBBH7afi5lBPDDzd9tHyDqQ34vO8g3fZOzNBWR9504CmtHd9xAubB8
         y2JHiEPKmpADTAaEEm7fdKeS3bJdBRljNDE2P3ChHVmtps4MGCG+hNt1g9sRR+MMrgli
         kGGw==
X-Forwarded-Encrypted: i=1; AJvYcCX4PknZ+DahjGlHROGAjJBOY8MrybkvlfPGqKhGu7pk8TURKixF5n/eDOyn2bdzmKVZOHO1/0y1JsAULA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2m3gG03mFspHdwRQ8ci8feRrRXMbITp/WFkBZGCtgYo/CMqN+
	zhz3vjMe6HR2iKBXVeu2uVagM0gRc3BwI9GIhJGX3RBGeEQ6KyEXdBj1uH+zB5wpCO/muDIZLZw
	muEGBbZSxQUjVR++zGfN8sxAL2cEQeEW8GvIGz2pIwVPAIgLirfCtT2oRroI=
X-Google-Smtp-Source: AGHT+IEhfetSuPrNfH5KG5dWxoB3STJq08SrBCK7xtzFi0IMLfeNULnlcPNYLVt0wLYi8Ng1qKpFAE0AsG7phdOzWHY5uJXF6t4W
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e391:0:b0:659:9a49:8e75 with SMTP id
 006d021491bc7-65d0eb178admr1812314eaf.69.1766222222606; Sat, 20 Dec 2025
 01:17:02 -0800 (PST)
Date: Sat, 20 Dec 2025 01:17:02 -0800
In-Reply-To: <20251220084457.107038-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6946698e.a70a0220.207337.012d.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
Tested-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com

Tested on:

commit:         36c25451 Merge tag 'powerpc-6.12-4' of git://git.kerne..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=152cd984580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb22c32016cc7ad7
dashboard link: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=169e1b1a580000

Note: testing is done by a robot and is best-effort only.
