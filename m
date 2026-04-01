Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D7236605F
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 20:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075818; cv=none; b=XwXKw/SMg2gcQ4i/x+tNpl5j2T+WQhwdzpuaHda8rWcH8Ov9POEHixxIiKBmELGpJGC7siEs9af5yXf3/BumXHCPV/xuBzu8DtVb/2iHDWNgoULlGOx0w3pR1YSJDI5ld5E+q/UHRnRPDdH+23kp6LyuliT1orfvpf3DVMvSzIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075818; c=relaxed/simple;
	bh=9tpmrIZyrpG6RkmKlnAwBF+aszIygVDRfT5buSae3og=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PQ0SydDNkaZxc2Ix+6D1eRb4pwF7c0wOXLkPCT5KO+nCbHi6iWsbXfyjjfCtKC5Lj0LCto24ZEZZh4SD0S9a3rDHa0TTiLJfvn6StZKouEpyzCaFlCr1b+JaQWUG0KKp+W8fRr48ATZoe7Nnvta43HLAR0Q9oYBJOq62l32/JPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oVCd2Fdh; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oVCd2Fdh"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cfc795ca97so19244485a.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 13:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775075815; x=1775680615; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KphSsrU9SWHDmOHZfBPSJQw8Xj5WM4ODSC4fe2pIf/g=;
        b=oVCd2Fdh4IT3XL5soK0QIrpjQtOvgu7m53WS56HftDIvgHj0QDMs2bdwuJtcN1bHjV
         Wdjjqxda+7SEXuNCYfEsanOD7SthCFvqFy/QlyHQqv6IwXzA6r6X41ch4B/GURcLSV5A
         8sH3wXzw/ZOoI+qpvXJBpp5RjTBuB+x5oWYcrr9mopizsp78sYvFlvr4pRa3PIumj57n
         tWdIEr8iP0k9kh6b65NpIloiT+fHivwysN5HtCYkr+7Q5oFytrhCVbT//JMmJwp1qBR5
         5HtHQ9EmG5K8NWqPt/hzNG1rPlxPNT/WdYRVCtXKxhUwteycWBq5aH9BxHcBoGr+Y2oD
         LtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775075815; x=1775680615;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KphSsrU9SWHDmOHZfBPSJQw8Xj5WM4ODSC4fe2pIf/g=;
        b=aNNOKHZGNx1Vg7QHVf1MPm55ue+9kM+Hjmm4BpBnEZeIaGgzbdetJdozU6TC1O9wYe
         8rjXdrOIzv+dmJGesRO0EP8QcTDjDR2Yxgs6ODf+YNtLWN/z6vxVMGuQuGOa55or7xu3
         Y05IDEHAx+8/yuXVt7emoumjJRAc3PNdM5L1bpw4cSJx03OZYsJc8LAIA2yRxbvEBBfI
         BYUyExgy2dTNl5lizqU8VW74i1bs1ur1hXPc7TsfZ3LmHYt6m068p0TZzeR870qtfRSr
         x05FrrvdFLzX+opwuSbC7hAckbWizwIMe1VcreI9qQFXsbW4WrTIWvvACH9+X3bL8mlm
         yJAA==
X-Gm-Message-State: AOJu0YxDR96jIlAT/MzVXyqhud/q4FfuGXghMFtszumgayjJ+4lc29lg
	eeW5fp7+SETXx596QN7sc0gaxI8ScnLZS3BP10lPXQleaFyn1e7taLCX
X-Gm-Gg: ATEYQzwlZ1D1RVGOwGO3XKO7eKm+4NcMhk5B+0FAppL76mYISOpwNvaQ9WuIzJn+xBS
	Xm6HGVSnyJmpRY+/brWIRL1ruNegOjEXR+vPfHvboolk7Mm4I9XFv/T0kvy2/tRLFLt4Sm3FZeW
	zFCBB3cNF4WMiF0wq8ZEc070io2DtYh8jjaZJYnio1tDLNU43FVHGd8R+snhkmQstsuhdAfsbv/
	VavlFuDm2oIcEFbkZg7OunlSvI7Sz/ELpda2VN1nGPJbbQ5qZzzvL7NXdsnuy+VLGcvucFhQVxW
	1QYBfJ4+W559LtRNbz3yFfcHZ3Ll4bJ8OH093XqxD+3JOXZqYth6AcurWBt53H3VSIL/NaM+cQe
	SIRC6wYkWp3QwZpoofXNZRw0qxdC830jsdKbcKsworZkkMw8cisgc0LxSIWc2UvuoLh/mJBVbZu
	lYxvz1Pn28eh9RQlAsISGN6SuV65y42KNlXm7gfwpy1pJLcCweQp322qQ=
X-Received: by 2002:a05:620a:410f:b0:8cd:81cc:5568 with SMTP id af79cd13be357-8d1b5b8c7f8mr759568685a.44.1775075813874;
        Wed, 01 Apr 2026 13:36:53 -0700 (PDT)
Received: from smtpclient.apple ([104.39.176.220])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5393a7bsm67367885a.3.2026.04.01.13.36.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2026 13:36:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [BUG] ocfs2: slab-out-of-bounds in down_read_trylock from
 quota-on path
From: Shuangpeng <shuangpeng.kernel@gmail.com>
In-Reply-To: <ac0Buq9DS9kREZvt@fedora>
Date: Wed, 1 Apr 2026 16:36:42 -0400
Cc: ocfs2-devel@lists.linux.dev,
 mark@fasheh.com,
 jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <20F9C447-2953-4028-B1F5-2CBE5580DAE8@gmail.com>
References: <40B9252B-5C73-47A8-BFE0-1A76B1D9F437@gmail.com>
 <ac0Buq9DS9kREZvt@fedora>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
X-Mailer: Apple Mail (2.3864.400.21)

>=20
> Hi Shuangpeng,
>=20
> This looks like a quota format mismatch rather than an OCFS2 bug =
itself.
>=20
> Your reproducer creates an F2FS image with quota format id =3D 3, =
which is
> specific to OCFS2. When quotactl() is issued, the following path is =
taken:
>=20
> f2fs_quota_on
>  -> dquot_load_quota_inode
>      -> dquot_load_quota_sb
>          -> ocfs2_local_check_quota_file
>=20
> Inside dquot_load_quota_sb(), find_quota_format(id) resolves the =
format based
> solely on the on-disk id. Since id =3D 3 corresponds to =
ocfs2_quota_format, the
> quota subsystem ends up invoking OCFS2-specific handlers on an F2FS =
inode.
>=20
> So the root cause is that the quota framework does not validate =
whether the
> quota format is compatible with the filesystem.

Thank you for the clarification. In that case, do you think it would =
make sense for
me to CC the quota subsystem in the follow-up?=
