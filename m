Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA94087C
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Oct 2024 02:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729652166; cv=none; b=Q1q4z7HGQFo1p+1y5ydzXiZqzxMJ/IZlgeU86YGihg5zo1yv8VncRCl1AB22xkgybzqBMS+qvs+M/qZid0pvgWsW3O62I2F147aqlvCwwkvfTEYv81gjCxhBunI9u+DwBur/NtnXKoRgpD4PME6911LttBrcuf0Z/Q5Uf1h13+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729652166; c=relaxed/simple;
	bh=dF73x0M3UHjm8Rjn3N77JiStFAPmQHilNsJYjLN1iFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AxLtv5rSSM//YB61h5vaIl7lgXuSWnaB8/DJMeNeyzz6u6GvkUqBP5fISskgk3AGHx2Q3IiBUwAHldIUJ097QsA0fzp3YzsjcVTGERr8MdlMtaXsN0groH9Xh5hNFJFITnXsCXDBqY7XhZVhLjymYAO0maesVQL4RMOvcchdJQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B4NWokyO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4NWokyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729652163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zHdknUCOThS1TrsG2FtImyl6O5CF9UtIeOhoBXg+sdg=;
	b=B4NWokyOPc1I1f56nh0f/S925zFCS/a6eDaCry9WjKyC3OdKGDVUvRgSLfJGP3hufPbDPZ
	0GWDXgmhXGxdDCwlUP76iuTsIy7DbFoOhuEBbFlNjnOcVqu7tP49U1XWLmkE2DxoOKW/ku
	zmc29GWbXshmpxmNEe/Lj+57jD2CDUA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-lP1EMwcGMTGLEfkJrn555g-1; Tue, 22 Oct 2024 22:56:02 -0400
X-MC-Unique: lP1EMwcGMTGLEfkJrn555g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71e7858820eso7819022b3a.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Oct 2024 19:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729652160; x=1730256960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHdknUCOThS1TrsG2FtImyl6O5CF9UtIeOhoBXg+sdg=;
        b=JXAWQZx0ijVToO0jSmYf/b573wBb5dNWjGIrXuhzsQZ2aKT5LcJ488iWvuEok/zfRg
         xbD6WarQGXRmubcAHtMH+UOdEeQJ+8GXWfbAUlk3GF2bN+BN3ArEKRg37oBrMySggNmb
         f5m8JBHHnmZkpayDz4O5FYYo4mgF+iD5fSc0pDrSqKNRApD5jvWkOtY/SBGmA8nbYu45
         iIXv+ebwGGW39SMrxM6EP2vTAnH0og2GNzMVAfEwOD/gH9Wdi2u0cd3DvC0KkbtTWvYc
         tzRnMxPI8Wrr61HRru+IQAQlajNUvyMAuHuST6SLHm3LYuuGn6K2vZtJy+51Ls961lAh
         k/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGRzbXrQxDuGFouXktVU9XeB/cDRq61ChcAtZqtzYzrlQ9jDpodMoS02+Fkw8KOLe/UAq0vbvcLFrgSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx10l7WsGfiIpJjrv0cS8gh10WuXS507u//UtlCOBxMWBRKrhF1
	J6ODiIaVs+860juMW/kNEK3tszpJuq7VX+CPY6pGVJKEuVzMuhBINHGzYr1ItNdtEUgNTJtmPnl
	mYanNfH1ynubF3IXwiXpAdqTYw33/RrL1o2iM37MC+gorT3p2MyzFtbhdEYSuyN+f8VXKUe2KHG
	aWMhQN9FVah5nc6z8MIya5DrtHdklt14K9vXDwkxlUWN6NOHZY
X-Received: by 2002:a05:6a00:181d:b0:71e:6a57:7290 with SMTP id d2e1a72fcca58-7203087ab10mr1840287b3a.0.1729652160282;
        Tue, 22 Oct 2024 19:56:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErwKn9FZkff6V8dcZWG5EY8VQ1YWvgVMHUhTBOzUho24sSekvZoUxoVrEwVIcCjlMhNwi3Q9f/+sZkP1bGws8=
X-Received: by 2002:a05:6a00:181d:b0:71e:6a57:7290 with SMTP id
 d2e1a72fcca58-7203087ab10mr1840276b3a.0.1729652159867; Tue, 22 Oct 2024
 19:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <000000000000ae358c06202ca726@google.com> <6717c537.050a0220.10f4f4.0146.GAE@google.com>
In-Reply-To: <6717c537.050a0220.10f4f4.0146.GAE@google.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 23 Oct 2024 10:55:48 +0800
Message-ID: <CACGkMEsqhW-pHhx3+t1GKKrn0RoHioUofC-QT+7nCDNASWn-Lw@mail.gmail.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_setattr
To: syzbot <syzbot+d78497256d53041ee229@syzkaller.appspotmail.com>
Cc: eadavis@qq.com, elic@nvidia.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024 at 11:31=E2=80=AFPM syzbot
<syzbot+d78497256d53041ee229@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit a3c06ae158dd6fa8336157c31d9234689d068d02
> Author: Parav Pandit <parav@nvidia.com>
> Date:   Tue Jan 5 10:32:03 2021 +0000
>
>     vdpa_sim_net: Add support for user supported devices

This commit seems to be ir-revelant as the changes are limited to
vDPA. It only shows the user vDPA mgmt devices which has nothing to do
with ocfs.

Thanks

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D17fc264058=
0000
> start commit:   d12937763990 Merge tag 'for-linus' of git://git.kernel.or=
g..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D1402264058=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1002264058000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D41330fd2db038=
93d
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd78497256d53041=
ee229
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12d0dc87980=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D14e1943058000=
0
>
> Reported-by: syzbot+d78497256d53041ee229@syzkaller.appspotmail.com
> Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported device=
s")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>

