Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27AF148827
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 07:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728889205; cv=none; b=AStEM94KIT0Yi1r89uD/cqZ5+FN7kUtEcIEUdYCsKaQGKLIs3XvaSD/wY8lAdqn8QgGIrQowlCpyrJouT7ik5FCCpbsW/s1ulfCObl0BBvhPte3odzuPDHAwc2S1kovaHNIbV4CnkECvccbetTNJy4UMX9zR/ImJs7lG3QsGbYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728889205; c=relaxed/simple;
	bh=UVeWoj5Og+wsSq9WC972/2Jqtj7IYT6e/JNvd8LqKOA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iRDsCzqtX/969jwrnM60VWTaHE0FQNNFxqeComDzfLXjqZ7y3tqTCd726xGYv9EBCEol74LSHWWLT1+q35M4ZwNHitwr1xeDotJBUMzKeK3imDSEu6b3avtKb8M1Zjo1PZ6VyasljYibBVLi7P8etmr/wY+7nPrflylYdN0XujI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3a6afd01eso30412425ab.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 00:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728889203; x=1729494003;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5tQ9QvYQlzu+5EQLgcSwBsHR+7o1ULHR0qfz4ooAiis=;
        b=jM0EQilyZy/rpnDF5/ZI5eqUf4ygdjlvs1rQyKy0KTy5SAgqejhUN8KIU0Ri7XrbBa
         YcSOm31zutSX2jB2bmWe3KlA3akHkKs0lBcZEupxdBn0OVm3kuIyck9WLK2AMq9yhZqC
         Kw4hhdJ71yZQsz3x6aH5t4+TElyalCvNPptM7sVjUTiw7rRLRqsP5sFro8HBCLDsXriw
         xtby6nYmhoX/tmHZ2F8/QQ3ye9yqg8ewlE4o547LBU0cFKFyy1YcZUW8LJv/hPDvN10U
         S0zU/UrA+UncjXheVFkXlYd2Vqq7KSs5IvpNbSPjO0tQMjxEIBkC2mQ+RB0AYhDUWJkz
         S9Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWE1dSqliq1nXhkHpx2gw/Nys0aSW7UXEWUmiKPsui1D2HoZGmabvQQBizeQt8tB+11hDV6uBKwF2bNyQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1r3msyNIeUoyX42l12OmzxUlGaL08OdtcvXIms/HJLsN0NW7A
	+QEjlbk1iG9C38y/Cw+d8TTMEg3pnX550hmVNxFed3LQHvV6RRQAEqac54Ogj+swnevM0PFEf8/
	xIMv0K/KE1LSURoPrZ00ubLViN/ojug74Nr5QTol6VEgL0UI+/1aXPcY=
X-Google-Smtp-Source: AGHT+IFPLvjoT1nCozSMVZ+82FBS4ca4DzmtsttPjqOJfzG/6nwVAEmMWDEs1IpVyod9cH6mpqA6VJA3nNIidyPjIoR/8n2wPf0e
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4a:0:b0:3a0:4250:165f with SMTP id
 e9e14a558f8ab-3a3b5c7389dmr79375795ab.0.1728889202945; Mon, 14 Oct 2024
 00:00:02 -0700 (PDT)
Date: Mon, 14 Oct 2024 00:00:02 -0700
In-Reply-To: <658bf0ce-9565-4b47-9043-a853374a74fa@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670cc172.050a0220.3e960.0058.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_read_virt_blocks
From: syzbot <syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com>
To: eadavis@qq.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
Tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com

Tested on:

commit:         6485cf5e Merge tag 'hid-for-linus-2024101301' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17169440580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=164d2822debd8b0d
dashboard link: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12e20030580000

Note: testing is done by a robot and is best-effort only.
