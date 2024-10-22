Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAC9139580
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Oct 2024 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729611065; cv=none; b=LV5Do9U0O/4bixJq3URWmndPmjO6C1LWXSnV6O5v9w7EFBiADUkMPiz0I8Q7iZDWOw0kWg7h+PW+6Vb+yTrfAxw0dNAsiVpqm+Xej4A3Cb/ULeWNmvzd7Urz7T8tiVqUSTKbOKKFXzkM9ydZu/hNMxVilLlnJxwQsZ+bDa+SyoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729611065; c=relaxed/simple;
	bh=dx6QxTPa/+mQ4n+fH7ym50nfkVSbWreEqPOdi1FIoYM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iQ7eowiVAHbj4A5kj1IvOGsz4QfgP3/5AJBljpP05EoiWUq35livdaU64Rg/N4bwngRtgDle8Ooca8W7h+o1hJMaOtaGCmxBjSMR62a14swvWPQKwh3xaR0hxKVcRl6PNW/QeQuC3ZYYn7D+YH4m63pcRGWh0jEZyD2vxHRqwxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3c4ed972bso50873025ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Oct 2024 08:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729611063; x=1730215863;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLrx1E+31Z4OW10+IEI8u+uVs3kTaeUo1vQAtWeI+J4=;
        b=gGMlGYOeAxubDc2H6ji2VLvJJxOX3KKkzTUHmpbLDKQ6kR47ZjwCEHHDUboJF0QhQg
         y6Q0RVYE99Fv0/8xKx34IloqRbrDfRiLsgJ2KMq3QnraN7EGUTTKnt/QD+SgckVm97PV
         VjWpUxgdqfHxFA4FLYKuHdObmeQwpGeflZZGVAHNeX+k3/qpLcUo0h2v+N9yyHx60e3t
         N/cqK1/GOFUN+NhidTR55cU63UnBBViR8Y0cDO2rZI4YvujR/2WWPlKkV7eBnLZOAyhZ
         AwTbC7zU5E3w89oZ+7fUe1pPjbdE6lvmnXtqTjWO6ggWtmF6zNI9Z6NF9kgeBnyOuC4m
         N2PA==
X-Forwarded-Encrypted: i=1; AJvYcCXopBEM7AZHNJIIjsMZD1YWD57X0VZ2c/NaktNT0oEXWx1WFeuWQvndjwD4L2wUIWe5L3WjCei7dJhi5w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRACqiCS2Kcr6kqsXgUiQ3Z88nhK1Ge2HEHA3h1KpkBFrDizK4
	JrRWQwRTwbHfMYwbieqLvukKjLrtTvpfUQ1yR6dGRjkp+Nw6HOq59hzJq+PANchRaAsT+Uka9RY
	ilKLfSohkpkCqdrWOrtzTk9F5xWPiSa348T34JfgJFtMvRHQgErRdLJY=
X-Google-Smtp-Source: AGHT+IFdvdlR6YQIyahOfH75Uqz6F9rwXGlLNt6wjo6UobtDESeiz2U3sOfU7f8neUoYGbvAvpvZ+CegSDI7C76l/r4XCb5cvuup
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4f:b0:3a3:449b:597b with SMTP id
 e9e14a558f8ab-3a3f40a7ea9mr128631495ab.18.1729611063108; Tue, 22 Oct 2024
 08:31:03 -0700 (PDT)
Date: Tue, 22 Oct 2024 08:31:03 -0700
In-Reply-To: <000000000000ae358c06202ca726@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6717c537.050a0220.10f4f4.0146.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_setattr
From: syzbot <syzbot+d78497256d53041ee229@syzkaller.appspotmail.com>
To: eadavis@qq.com, elic@nvidia.com, jasowang@redhat.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a3c06ae158dd6fa8336157c31d9234689d068d02
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Jan 5 10:32:03 2021 +0000

    vdpa_sim_net: Add support for user supported devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fc2640580000
start commit:   d12937763990 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14022640580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10022640580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=d78497256d53041ee229
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d0dc87980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e19430580000

Reported-by: syzbot+d78497256d53041ee229@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
