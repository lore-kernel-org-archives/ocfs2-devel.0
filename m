Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43FB15852E
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Sep 2024 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727254505; cv=none; b=OqwzAb5i3znK6NbSRGAYfMcJaPmRCEPkjUftU92w6IoodystO1WleuN929uHSh/hxRQW/qbUNOy8vhhDxsqIKLp8PzQfVV2EhjzGZqO+iwERQL4hP6mDJMZeClwxB3B29SJHnDyhqQB41mL4eZc6Zhrizpmdh3lhIyI39W7/hes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727254505; c=relaxed/simple;
	bh=73MPY6aoutLl/EA0dk0w49JFjhcA2BSDLXc0ZfHC7So=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SkPn/bJwk/XNg2FxZXqCzSK1AsiSXXbPBQRqqZD+Q+cnZX7O2mzreZE0OJc36v9+/sBlushwZi6AbqUSI3D0wbOwSYDAZmW5tm+BLMtpCadne34S/WatTfh7bXedknAvumpcZuUrpW5vZL84K7oxv31YhE8uaw8B69KWFnq+fFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0cbb9da2aso54464715ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Sep 2024 01:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727254503; x=1727859303;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qEMTbiahrepVGJTD40IQdXijMvf08ZrzOrFqeHstblg=;
        b=bMt6mNfmupcy2jkNNpqxQOY/HtIxK6ufPKmseK0Y2swCNeMfJ2gxim2613Mn0Z2aJg
         I05fIOfVD3zxsL2y5/6wy8PZKGrRajyxqswozUZBhSe5dnL5dJibpcIbYHQIlee2YN0g
         MkBseZNpXkVcqEDNakBiJnijd6Xa8uiP5w0PsmDg3vP0E4Xb+ErayumQ0RZ5eTwMJO8a
         ZgNU9q4klVwcilWCrXN1i1WViRwt2Vu1tpoA1RyVv/jlLx8xKyouX4MMMAE//DUfJrT6
         FWLx2zmuAcAjKxBq/v8iyr/VGzc0JgXKSUp26gKdSYrr1ufOBA545emruFkU53ZWiZ6d
         U26A==
X-Forwarded-Encrypted: i=1; AJvYcCUNbUJssPgzydqMOgQjgpQ4rq4nvaZxDiaDRw7yB9+GN60pyvs8+uVLu5X45jC5p66FRkkdhWx7dDvpUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YymrLo2ZaHSU3025oXXAtkXWzE48bEPuW1uVWg4HXOGy/EugqVo
	qfYIN4sPuivaoTeGxqS0214tbwBVwNBZ4Rr3wtZM/9BGxtGZjnVL7uULcl4gwS07d8jPRABeLuN
	nTb6xsIm8xUww+u42vKAT1HhWwa5N1mGTLvbflyttbeTN1LNm6y5cfOk=
X-Google-Smtp-Source: AGHT+IE84KSyKVyp+PYMEpncD5pqsII/zmei/APPWrJ5Wpu+N4xC4m5S0PZQ86rGdx31GmB0k6UBGW3MAXGDglCMoEI3gLOTMXLL
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1446:b0:3a0:ac5a:2015 with SMTP id
 e9e14a558f8ab-3a26d7095bamr22899465ab.6.1727254502870; Wed, 25 Sep 2024
 01:55:02 -0700 (PDT)
Date: Wed, 25 Sep 2024 01:55:02 -0700
In-Reply-To: <6e7d21ec-f4c0-4c94-85b1-afa308fdcdba@linux.alibaba.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f3cfe6.050a0220.30ac7d.0012.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in ocfs2_get_block
From: syzbot <syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com
Tested-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com

Tested on:

commit:         684a64bf Merge tag 'nfs-for-6.12-1' of git://git.linux..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13fa32a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fa513ce0305877d
dashboard link: https://syzkaller.appspot.com/bug?extid=9709e73bae885b05314b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13398a80580000

Note: testing is done by a robot and is best-effort only.
