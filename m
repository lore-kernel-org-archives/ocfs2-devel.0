Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D31C2D
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Apr 2024 03:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711943490; cv=none; b=d2+iIcNkZrYzI0kiCmUdfIf/9kZAO09ryykc0JiJWuCcdApQTqHTXNiMsY9h7Dy9mye4EejJrqzya4y8W1isX73Hy4UQmtnSRGJHjYX2j7CHN04SwSgcn0zHzLj1lLVnnOd7L3S4w6E/C2DhWQLUEItyk9TRCm1HR/12uI78+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711943490; c=relaxed/simple;
	bh=eviQCwf2m5wu33J+iMuhand6ORKdtOPjqUCzKDa4ml0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SXhuX3u83SUZ8MqjQ61fDP+gV/VM/b7B2bzrvd2kEzGQPwRqk5CH3OQ+nE7Xfb0BAWLVIHgLb52a33w4H/kX/MIEiQlIBrPX55vpPAE5PWjOeom6smNCLQ9BCPig91yjEto54dHzZjzYgaTzqrIsdSeGGsU1I0nJuCv0vLFp6+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L7eG9UWD; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L7eG9UWD"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d6a1af9c07so41949361fa.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 20:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711943485; x=1712548285; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eviQCwf2m5wu33J+iMuhand6ORKdtOPjqUCzKDa4ml0=;
        b=L7eG9UWDdgIzouAlmypk5olM49Eu9W+U46uhi5WAjKw3o68EM2zOGvU0r4QMyCJcxw
         9GHcnYR87bfBwM74JIDWgK8jiSX2MXmdKBevDvaPVqGjEY+azgjKqbrMlftyu8uwvM90
         vztMdrS4ys41pcBny+Pj9c9vXoPiW2+v+HN8pF9k+J5pclX5+6G5UMJ/7+jePS1383rA
         uIFrmST6NgH4KnvoaXhhLR/CeL1MwtHDjadrtgMhmO9gSxOertP56vsgipbKXHn/Q7A7
         U7/3l+pxcKp/7VN9YaTiteyNB1QfYas9pMmkWwWgqx7/xKwjZw6FAhgZDX6Ttgelxzub
         Vj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711943485; x=1712548285;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eviQCwf2m5wu33J+iMuhand6ORKdtOPjqUCzKDa4ml0=;
        b=OKYy394hxlpF/J4+l67pysdfwOaxTkkdfUoMa5yNU/Vi6w0JB3qkRlykVdYj/A9+J8
         Szg3lcJ9TzLDtUDH7GpJffdBjbSyu5TdsHie0c3rU70Jjorifh664SV+T07IqcU8/Inf
         yCh+i0+F9ugQ2odwaDaCRhi+SMUIdpOqF+ibQulOZ0bzazJqmy5CL9QFoOh9Olz+zwd1
         SKqkuNkWR5DSd7ZDSijEPXzPgeuiCrGMHMZ8eGtaWJw2znI34vkrA6wQUjHoPEy2waKx
         nbyExGPtwzOLwIE6PYq6hfxKsdyYl2F3Q04T9QPrhxe25ZmEskLl+Q5JPkDYFh4jmYYh
         J2gQ==
X-Gm-Message-State: AOJu0Yz88XiDn4TB0Dzo2zZRG7dQ+1tSQv+SkCG6Cqw37KOYD9RuDgPj
	sD+lu+SsP6dnQx/NqUOq8dun9z2ezM1vlp3m6jf1Hlo2AVSzOWsW9g5pbqVAxgc=
X-Google-Smtp-Source: AGHT+IGpv9m2LVmZfKAkt99wyRkwnbC/kXf/HuAbM8CgN9b06IdHn+jaWoRiEne/MWLyjnQkSDJbUg==
X-Received: by 2002:a05:651c:a0e:b0:2d6:dbf2:bb19 with SMTP id k14-20020a05651c0a0e00b002d6dbf2bb19mr5347949ljq.50.1711943485490;
        Sun, 31 Mar 2024 20:51:25 -0700 (PDT)
Received: from smtpclient.apple (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090ad70f00b002a2167c9cf5sm4712031pju.35.2024.03.31.20.51.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Mar 2024 20:51:25 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH 1/4] ocfs2: return real error code in
 ocfs2_dio_wr_get_block
From: Su Yue <glass.su@suse.com>
In-Reply-To: <3d6a2f6b-e345-4e31-9388-4d52c9a39739@linux.alibaba.com>
Date: Mon, 1 Apr 2024 11:51:10 +0800
Cc: ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB214E23-7DF8-4F12-8867-2286712DD467@suse.com>
References: <20240331111744.7224-1-l@damenly.org>
 <20240331111744.7224-2-l@damenly.org>
 <3d6a2f6b-e345-4e31-9388-4d52c9a39739@linux.alibaba.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: Apple Mail (2.3774.200.91.1.1)



> On Apr 1, 2024, at 09:44, Joseph Qi <joseph.qi@linux.alibaba.com> =
wrote:
>=20
>=20
>=20
> On 3/31/24 7:17 PM, Su Yue wrote:
>> From: Su Yue <glass.su@suse.com>
>>=20
>> ocfs2_dio_wr_get_block always returns -EIO in case of errors.
>> However, some programs expect right exit codes while doing dio.
>> For example, tools like fio treat -ENOSPC as expected code while
>> doing stress jobs. And quota tools expect -QUOTA when disk quota
>=20
> EDQUOT?
>=20

Right.

>> exceededs.
>=20
> s/exceededs/exceeds
>=20

Sorry for the typos.

>>=20
>> -EIO is too strong return code in the dio path. I have checked
>> return codes from collees of ocfs2_dio_wr_get_block to make sure
>=20
> s/collees/callers

The caller of ocfs2_dio_wr_get_block is __blockdev_direct_IO which
Is widely used and it handles error codes well. Here I mean the
functions called by ocfs2_dio_wr_get_block and their return codes look
good and clear. I will make it clear in next version. Thanks.

=E2=80=94=20
Su
>=20
>> the change does not hurt us.
>>=20
>> Signed-off-by: Su Yue <glass.su@suse.com>> ---
>> fs/ocfs2/aops.c | 2 --
>> 1 file changed, 2 deletions(-)
>>=20
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index b82185075de7..f0467d3b3c88 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2283,8 +2283,6 @@ static int ocfs2_dio_wr_get_block(struct inode =
*inode, sector_t iblock,
>> ocfs2_inode_unlock(inode, 1);
>> brelse(di_bh);
>> out:
>> - if (ret < 0)
>> - ret =3D -EIO;
>> return ret;
>> }
>>=20

