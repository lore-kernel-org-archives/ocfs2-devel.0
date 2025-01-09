Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68318214A6D
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409534; cv=none; b=U0o6yAYTC1SFc6hlA97OHG2aZs2Nlo84ipWsXT77tptR8h/POVC5VhulB7Oe8wi7R704XKLwzgl/q/nf3ceSoPUQWF8jh+Ox1MdhPTxqFdUpknqmqydvwK/YUWZtSUTltdn7mVqaxOeHwvxZRmLypZpK1ywFsTQOULpYqpAJt/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409534; c=relaxed/simple;
	bh=gm7DE3V0vPJcyQCtoRF2Hw+Q8690YWm+9sxa/jzU7gQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Bw/WORXhaAR62TSToyiAgWwZ56KB9FBHcJ8e31aKdto8b6c0ZBGVzhs9C9BSEAQeS9Z0iTrOijRhHDQFn1wwE1QWqEHJpC8Vpg5p5tqhuvhnOwH2ompONrTjaQRE7cI2I/y8Y/IBApZgpDDW+8w/kG156bNiI85hrWtX+DEmmOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aHEZRyuz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aHEZRyuz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaecf50578eso125841966b.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Jan 2025 23:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736409531; x=1737014331; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCqbUpe6hB1CXOt5It/H2VGIYpzfiZrDxLtZWWa+EXs=;
        b=aHEZRyuzGmk+BT8Ay98YS187LICoFd87ccR01pVU+DYmTz4+fWFlD/NnUwBVwospOR
         mvW+PqoxGAWQRUyE6FYpQ4JOEOujqf/b+sQETBHQGWiZJYPXlFCzvLjl+O+lfXTLCv+l
         X4aHyO5RT16aolWEvUTrr62ISpcJK6K3A/OP+hi63H0FE1aFgS60zn1zjXQ/fn/RWkKe
         iHmUsSBnZ0t7KJvPF0nkys1n45f+x/LA6xjOyYTW2QC+TecrZdOBIxeSMjEbLNQwInXm
         OPUv4KSPymbHpbsbUAzHGNJVyA8lxzx1drLDs9K3zZ1nacIZDr26gizSOzji2XvXcez/
         UTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736409531; x=1737014331;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCqbUpe6hB1CXOt5It/H2VGIYpzfiZrDxLtZWWa+EXs=;
        b=QkU+Nhg5TCe9ILhMlUKe7kNX6l8BVB+YZndPq4naYDJlMOH+hLiP+qCCB104VVORPH
         7g0bKEa6gz4yyb3rSLGferxnfjOARsXEskuJ0rEckT3GDmWc9krta/Q+KFCdoEV+nztC
         ANjNeYm7bSEmNdwfFNeER0jQokxIWGibMe1Eu8lYeRt5wOJcTgTmWPonnW0LOHl3ru6x
         UwmJzK0GXFaurEok6e9CPqDDFRF1w/PfjGn6e/EwAIgzDO74eeLlBjLWyUluTJFXn91L
         pcpY7nRIoRxxIFGe8QGfcxefGNqhLgYoL03fcbF0PBjfdQ6SEglLYXeKSmisc2L5gaYl
         Btsg==
X-Gm-Message-State: AOJu0YxosA/hWbsmjuyT6VSdI6d5l69N7zKwbsgOysJB6FYOAja2gy8R
	KqCknzdSDczS61lomEQMREA8mSS9HzlRwczWdheq9TJTpkl5OPLN4ojuje39gk0=
X-Gm-Gg: ASbGncvtaMW5bBsBf25M5gHi76nSPAlKxu8N9YNC9iLGpPxrUgV7pvXKqvhiLYsWSy6
	tyiM0stC2V0DzJkPW+yS6FfCeobF9BBXGh5gefsSOfjmb04iRroWUaWOJV4MnIp7VWMtKEmACtS
	6Ls47U7OU7SsVW+DLYE4ztqMwg4isNi8BQFbVZxbIRd+x3933MdKXpd+EuRiwnpabMiH7DSiK05
	zYegu8GF3Sm/2VT6cR9Gfq2nkPBYcoqqeCI1RtUJk7RdUl23QyZhSx1x6A=
X-Google-Smtp-Source: AGHT+IF2JbyLmuhDlY4ij5cWMJ+USqJo1i7NF0xrwm2kDXhIqhnEP0nRJ4hpE83s6OQyK5w73UprSQ==
X-Received: by 2002:a17:907:d9e:b0:aae:c3c1:1361 with SMTP id a640c23a62f3a-ab2ab6bfe9amr536690366b.44.1736409530644;
        Wed, 08 Jan 2025 23:58:50 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a82e61f2asm27491435ad.124.2025.01.08.23.58.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2025 23:58:50 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] ocfs2: check dir i_size in ocfs2_find_entry
From: Glass Su <glass.su@suse.com>
In-Reply-To: <76f6c583-50ce-40f9-a1c8-f1c1155d94a2@suse.com>
Date: Thu, 9 Jan 2025 15:58:33 +0800
Cc: ocfs2-devel@lists.linux.dev,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Jiacheng Xu <stitch@zju.edu.cn>,
 syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <21FCAABE-0E59-4DA3-AF16-C07B3E5AD540@suse.com>
References: <20250106140640.92260-1-glass.su@suse.com>
 <76f6c583-50ce-40f9-a1c8-f1c1155d94a2@suse.com>
To: Heming Zhao <heming.zhao@suse.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 9, 2025, at 15:46, Heming Zhao <heming.zhao@suse.com> wrote:
>=20
> On 1/6/25 22:06, Su Yue wrote:
>> syz reports an out of bounds read:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-out-of-bounds in ocfs2_match fs/ocfs2/dir.c:334
>> [inline]
>> BUG: KASAN: slab-out-of-bounds in ocfs2_search_dirblock+0x283/0x6e0
>> fs/ocfs2/dir.c:367
>> Read of size 1 at addr ffff88804d8b9982 by task syz-executor.2/14802
>> ... ...
>> The two reports are all caused invalid negative i_size of dir inode.
>> For ocfs2, dir_inode can't be negative or zero.
>> Here add a check in which is called by ocfs2_check_dir_for_entry().
>> It fixes the second report as ocfs2_check_dir_for_entry() must
>> be called before ocfs2_prepare_dir_for_insert().
>> Also set a up limit for dir with OCFS2_INLINE_DATA_FL. The i_size
>> can't be great than blocksize.
>> Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
>> Link: =
https://lore.kernel.org/ocfs2-devel/17a04f01.1ae74.19436d003fc.Coremail.st=
itch@zju.edu.cn/T/#u
>> Reported-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
>> Link: =
https://lore.kernel.org/all/0000000000005894f3062018caf1@google.com/T/
>> Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory =
inodes")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>=20
> This patch code looks good to me.
>=20
> Only one place is above 'Fixes:'. 9b7895efac90 refers to the initial
> ocfs2 code. =46rom the patch code, we can see that the code lacks =
sanity
> checks and this bug is triggered by a specifically crafted fs image.
> So, it's not a very important issue. In my view, it's better to avoid
> tagging 'Fixes:' and backport to the legacy kernel, which creates
> extra work for the downstream maintainers.

I guess CVE is involved here? So for old kernels we need the Fixes tag.
Yes,OTOH it absolutely increases the burden of backport jobs.
I am dumb about security area. Im fine about removal of tag.
The objective of the my patches is just to silence repeated syzbot =
complains.

=E2=80=94=20
Su
>=20
> Thanks,
> - Heming
>=20
>> ---
>>  fs/ocfs2/dir.c | 25 +++++++++++++++++++++----
>>  1 file changed, 21 insertions(+), 4 deletions(-)
>=20
>=20

