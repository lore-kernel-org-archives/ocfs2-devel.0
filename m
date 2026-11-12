Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794515637;
	b=l7N8EJD4MNxeNsrUZijkVdcxeuk2ldiMUDkSiKVZGj4vpLFeu+n1I8q/goaHaynpABuV
	 EYBqF10tk/SvThVP3ZcUos2ZfMA3HDEBMAStUroVkjvNYCBKqK82r60FLz/Ztc278XIpq
	 xF5kxEcJs3wdNrbPV8ZqqikynOpom7y8IbV+t8ZaEAMUI9bwYd2HJ8l9qNMivC2+xSgBy
	 KVM1zoWGRfswFFBpE8/B4pcIEHzt8UWvF3wKjW+I+fH+cAkuYayM2vi+ByuhdsHySmdvU
	 UW1zNWwXkZRpKeU0gsfER0t22Lno1G2iHkN/YtLb8vo+d8I9GbkdEZ7/Fci+Uc/Ip5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794515637;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=AGrviyGKzOJyqDNGuonvUk0+iEVsk423d//XjaI5/Pk=;
	b=szUS6tgWyWsewdVsp4CMNMs/OOpXtMt96ep9IEP7QNq0mMKrdnmKJeE9ToNvNIVBdSQq
	 v6XorrIghVwuPBwjRPjt069BgGPGEmt20ve08zGSLmsdaNnavi/RECvKnRCOLaF/zigFE
	 LrZaW5LNyjBs6JcHan/LftfTMoTShRvn5Eh0bXDNsDAeyXH7lXznE39vJgmhvO77pbDuL
	 0Km4h6c7A6dTiujmqPJKb1ivvFeKjQpyB3cUCW6qJ/RSLQY7lbA0T2BTmNOAoI5eY9YjJ
	 fr08I/4CwLSVhwoH9+PBA+UpX5tutbTLAhcC0vP2x9Y4QOWyiQ+W6VnUWG2tTsuy0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB8606A886
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Nov 2026 20:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86FB8606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4fb73e868aaso300157b6e.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Nov 2026 12:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794515636; x=1795120436;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AGrviyGKzOJyqDNGuonvUk0+iEVsk423d//XjaI5/Pk=;
        b=Ycp94WRfKswB7blILNUe6Llj30RgAVT61DyWR45Y+LA3HkNShoQj3b2Cq7tRt2MMQR
         2/piz/FuIp6itoyLQW9lADRPwRLSGjcoQSaJKBA08NHaytEEZd2L/Pt4gaN8CKMsimIU
         6qcbpa7IY59OHkmrCnUpIF2Uv8xl1xyIWIcmRlsI+CIqT7T95lA5G8BGwYZSTUX2VaUR
         wv3ybMWnolXqygyDoDvvJTcs76ZrUH00w6uytLM+TQnSixX6FLqhXvDDS+tLIKWwKFu4
         D689DpPAYYhkZ5oB8c8zJPaPuakfBL4PZvniwIkMhW3RWuswqIm2WSN1xWNhBJIu5QMg
         Jnrg==
X-Forwarded-Encrypted: i=1; AL+hErEG/XE3tdwLu5Mu9bE2gzI9o4tvDlMUcBYCvdFjLdVV/Lpb/TzlxTdFOpvkTjuVHm77ybYJuCquHIt4ew==@lists.linux.dev
X-Gm-Message-State: APuU4Z8JSGOKsnOJWMctseCFC28TwEBYbjgSsM3Mk8Nn5Bu5ITnC4bhG
	+CSWMLkQnmY8ttOBwpJvWy3eRhcw+P9Gq2WTyyJVOkpmTztl77lC3sNePrcWnhqLzBxQw+/MSt3
	x7SPQT3CtRdcXilDgeIlAYuVnY1bn/jjwRnLGfAgAV9cW0DyplMYQsZz/424=
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3509:b0:532:963f:3118 with SMTP id
 5614622812f47-56e603885b7mr346645b6e.3.1794515636629; Thu, 12 Nov 2026
 12:33:56 -0800 (PST)
Date: Thu, 12 Nov 2026 12:33:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af622b4.ff6dfe28.557e.001a.GAE@google.com>
Subject: [syzbot] Monthly ocfs2 report (Nov 2026)
From: syzbot <syzbot+list812a400613f624e19b24@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello ocfs2 maintainers/developers,

This is a 31-day syzbot report for the ocfs2 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/ocfs2

During the period, 0 new issues were detected and 1 were fixed.
In total, 23 issues are still open and 61 have already been fixed.
There are also 3 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  434640  Yes   possible deadlock in ocfs2_try_remove_refcount_tree
                   https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
<2>  50002   Yes   possible deadlock in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=5d516fba7bc3c966c9a9
<3>  20078   Yes   possible deadlock in ocfs2_setattr
                   https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
<4>  9457    No    possible deadlock in ocfs2_xattr_set
                   https://syzkaller.appspot.com/bug?extid=ba9a789bd1f4d21fcefe
<5>  6292    Yes   kernel BUG in ocfs2_write_cluster_by_desc
                   https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
<6>  591     Yes   kernel BUG in ocfs2_reserve_suballoc_bits
                   https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
<7>  473     Yes   kernel BUG in ocfs2_dio_wr_get_block
                   https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
<8>  8       No    possible deadlock in ocfs2_xattr_set_handle (2)
                   https://syzkaller.appspot.com/bug?extid=b4732eab3dcd27c32ae6
<9>  72      Yes   kernel BUG in ocfs2_populate_inode
                   https://syzkaller.appspot.com/bug?extid=779d072a1067a8b1a917
<10> 25      Yes   kernel BUG in ocfs2_block_group_search
                   https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
