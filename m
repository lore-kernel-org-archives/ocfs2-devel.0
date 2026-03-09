Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B941396B73
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Mar 2026 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773059374; cv=none; b=LaykEmmfRP++UWIkkD+eR01O3f1mQJiHlsnuEsLDnjiYGNQ509cjyTDWnaLIzTbUuZteofjbTFmUANYgi5zsktygzXwqlMpnp67jpc1KkYRVljelwP/zOxubK4bQQdfcjzKb6macsLZOSDxU2P5mP/iDjk87jhc/b+nJ6AkYQ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773059374; c=relaxed/simple;
	bh=zxQIT7s86RE/oySHISdX8rocR89owdUokr+cI7cVsOo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JSdbBbbSV8Utv1rLYULLrPlBYrehkO5YTtc0poiHhZ0E9snL8x02kStH5e88KXFBIu2iKDFKBoShZtE1D50jppxK+7zrLHe6dk2WRQ6bPZCA6WDG/Tj3o0MyhlpN6tam/sdHU3B3F5IYo+P509zAER6Nc9chv/I+CEsuZMk01SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bb6081a0dso9437060eaf.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 09 Mar 2026 05:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773059372; x=1773664172;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rhthTa7FZALAozbfeiEAbb08hlYiMIoceQyPrLG2uhM=;
        b=X2LJhVUavtsvGvYZQjuARWFFdCnelimWThQ6uGgsq9/oPR/9RERymFDUXgmmjhpvhB
         B+r4DE1g7FgMC1ZRuH8kTzNH5HXrAaXDb24DDIuT2oxQrx986f8sFQrkGgp8afcO53Fq
         9mlMQmDCFAEm9vZq0vPDJ7/2xf58/A6B/skgg0speN6qHu3OWIOn0pdBy1G7drIydukz
         e8IgvlK78r3jCVEXVN0dAoPzah3Qnit0lNHmqmfC6ZHoYRqFwH2nOWwzagVVKUJI/Q0e
         oR7ZQqaus/oN/2aF5g6fBHBo4ibex4QF7IFu1o+XeOD481iW/8PRwoqv3R5zTKY4e50G
         091Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgeax86GYfcJxYVc516Mc5wC0YaD946PEYL+LmaHbyM1C58HGEEIaArpFgIZXU2FeOR4DbJ8iuNycucg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyqCUuPwmUpRec2uOBBnyZiVUcUdsATLdRzOmVqdTJOUTy8zzw7
	7WBWu4yMs863l5zEtQr8KAjOIIsm34QN7zr+wew8eNP21+Z1TJefaP55gQMg9315N6E5WUQzgu7
	WZ/UN8dFEEGqx0dNstZxzxZ6JTAjGK3iOmo48n6fjJV7RquDJj31ZcpC+xPM=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:52db:b0:67b:a3e0:2122 with SMTP id
 006d021491bc7-67ba3e02f5amr3846529eaf.35.1773059372676; Mon, 09 Mar 2026
 05:29:32 -0700 (PDT)
Date: Mon, 09 Mar 2026 05:29:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69aebd2c.a00a0220.b130.000d.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Mar 2026)
From: syzbot <syzbot+list925400bd191787d3c223@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 2 new issues were detected and 0 were fixed.
In total, 52 issues are still open and 45 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  391702  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  44815   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  27359   Yes   possible deadlock in ocfs2_init_acl
                   https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
<4>  25230   Yes   possible deadlock in ocfs2_reserve_local_alloc_bits
                   https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
<5>  17701   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<6>  8481    Yes   kernel BUG in link_path_walk
                   https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
<7>  8248    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<8>  6235    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<9>  4058    Yes   possible deadlock in ocfs2_lock_global_qf
                   https://syzkaller.appspot.com/bug?extid=b53d753ae8fb473e2397
<10> 2170    No    possible deadlock in ocfs2_evict_inode
                   https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
