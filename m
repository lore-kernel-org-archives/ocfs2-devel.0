Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C295633F6
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 02:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735524333; cv=none; b=Sp0gIwYKar6SzrF/XODXYOayrRJqIY4NZu8FhJoesW5zK90eQlKXrCXXHiiHnTiujPCLi+jXcdgYoGlLuYV8yPL/7WQxynUe3uh+mdetEieyuW9l8hdetREhXhCgfOLNkXQUWr0O7Px4Jw/+RuUwCfdluO0u4LNT0feywBBxbFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735524333; c=relaxed/simple;
	bh=0o49vux7kpu/U2dAIXto8nm3Qyjs2S9VwSM0CWcxGRQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tfg6uXgQ+Gb7BJ/XRq5jEcVK0bwqJ3REAUq6PzrKORWYCl/pWLP33GlUTcWpJss9w931GZ+Zc2eKQ2kUUcKwuGcdrFU4fqacOyX9H3/JpND7gfQ4UNFmHx5eP/pbwBg6DRYUFKi5ahwdaailVojOB9aTKN2Vqbe0xvjZaGZsJmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d3Ev9+8+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d3Ev9+8+"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3e9a88793so15630940a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Dec 2024 18:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735524329; x=1736129129; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipYHxwxET2ijxkhDERoKjVZ7M95QddGx/4uWqTjY/6E=;
        b=d3Ev9+8+zqf6qtLOFWl2pnCmKOuQZGIjKHoX8QOk935ThSsMJrj+aQhOu0PzpT/I6y
         cM8LsY7bc+uW0eAp4sS9SrSxJeqCU9J57PIYRfPuq6TKPZ8bcfGxKMpFhboazAlyiEmZ
         p/KcNFb7KzxKD849uio4R/28s6YgOJuLyLf9OrJAXsQPI0YXkU/dCCc7liOcsgqNbiE4
         r/Tc5ej29DL0OrPRcPraygpnItm+7uTIbAnwAV0LTmbC48NLgV++cmkPiybXYzyyAMs+
         KeW6LWqwe5q3tz6vWwo0C0bBwJB3BnFT2cncrOaJu+2EYmmzuwRn81OdHGrUgVr9kC6C
         8/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735524329; x=1736129129;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipYHxwxET2ijxkhDERoKjVZ7M95QddGx/4uWqTjY/6E=;
        b=mVm//xJs8OYCHcvii3QDkVBJOgDMo2FMlp/6Ci0TSTf2mUy0TnVaVl1csLHMuvFDxf
         p/ExrXUyHqqqYbjXW1/5ZmoR6AaGBsxSdODUf+A1CO3FUSWQ45Fz93SDP/XpRNLY2Uy2
         R6bnEd5lwwisqfnzgVkAuLh9AVgapXQJzWYFy+UFeR2y9UDwEOlZfCc8Z2iUfprzU2Rp
         b6aHw/kcEG7vboNjRhoBonZUvrqKSa4SwWVWutZVklbMrKTGQZn2PKzAqH3clzf+bcEz
         IVA+hnAYGuqywNDOH5iJ6/u8+h3QIh0JREXjWXZJ8f+715evi+bKGFM35CktrabDrbjw
         DgEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDmI3Nk+eEk5I9SSZeo0ilEupKHzIIw1dWLP2+Q0u9wL0cd0NXJluR8jJp96xcrKuulMgfpuzep/pHHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YznMADp94U9P0bcbuxu1JtaAHehrK0q7XnNd/YJom/fFL0e44rG
	DDS9sJUpcPa+nw2QNuYtTAM+/PidIjWruz6cuSAjcZgkMbbNKpr5UJihER1WpYI=
X-Gm-Gg: ASbGncv6UZ6OOhg/5Fgz9NnwNIJAPZNDOibygIvhqYbPoxEU14NSjooVPaLSJNrcYWL
	S7ZDj1DWX50cxESlzhruoTjDZtUvMz8VfoxnVu7+3oneQ4LA/HspAAzOUTqaJUPjIEUPrQ0LFvv
	uyRgD2vh8S2JEetpwpkfkd451wXAn6mzeOswx561+yogKhiZ3vlf0dJv/Zb5qX1mo4dbeRg6qJ3
	pSmq+XYQKvllpfh1FV9/tI2hUMZeCLNOgTGLXgf7OubengWS63a+EyGd85C
X-Google-Smtp-Source: AGHT+IFbAWzBjjDDtEpBuc5KU9AW3yIz/HBhtOARyc1odcYgiJBz+KiOYD0kSb1iPWvlbNCKe2NbwQ==
X-Received: by 2002:a05:6402:358f:b0:5d3:e63c:7d71 with SMTP id 4fb4d7f45d1cf-5d81dd90636mr27085095a12.11.1735524329126;
        Sun, 29 Dec 2024 18:05:29 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4477c4cc5sm21874175a91.12.2024.12.29.18.05.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Dec 2024 18:05:28 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] ocfs2: add extent record check in ocfs2_commit_truncate()
From: Glass Su <glass.su@suse.com>
In-Reply-To: <Z3EpSTa5KzSazonJ@casper.infradead.org>
Date: Mon, 30 Dec 2024 10:05:14 +0800
Cc: Dmitry Antipov <dmantipov@yandex.ru>,
 Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4DC5E5D-8736-45AA-8B8E-8124422B89B3@suse.com>
References: <20241217104345.358461-1-dmantipov@yandex.ru>
 <BCB4B87E-9C81-4212-8C05-CE160130A399@suse.com>
 <Z3EpSTa5KzSazonJ@casper.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
X-Mailer: Apple Mail (2.3826.200.121)



> On Dec 29, 2024, at 18:49, Matthew Wilcox <willy@infradead.org> wrote:
>=20
> On Sun, Dec 29, 2024 at 10:05:17AM +0800, Glass Su wrote:
>>> +++ b/fs/ocfs2/alloc.c
>>> @@ -7219,12 +7219,20 @@ int ocfs2_commit_truncate(struct ocfs2_super =
*osb,
>>> struct ocfs2_extent_rec *rec;
>>> struct ocfs2_path *path =3D NULL;
>>> struct ocfs2_dinode *di =3D (struct ocfs2_dinode *)di_bh->b_data;
>>> + u16 tree_depth =3D le16_to_cpu(di->id2.i_list.l_tree_depth);
>>=20
>> No need of tree_depth. Just call
>> If (unlikely(le16_to_cpu(di->id2.i_list.l_tree_depth) >=3D =
OCFS2_MAX_PATH_DEPTH))  {
>=20
> That seems more complicated to me.  I find the original easier to =
read.
>=20
>>> + if (unlikely(tree_depth >=3D OCFS2_MAX_PATH_DEPTH)) {
>>> + ocfs2_error(inode->i_sb,
>>> +    "dinode %llu has invalid extent record depth %u\n",
>>> +    (u64)di_bh->b_blocknr, tree_depth);
>>> + return -EINVAL;
>>=20
>> -EIO is better.
>=20
> -EFSCORRUPTED is surely the right errno here?

Indeed. -EIO is an old school errno. -EFSCORRUPTED is more accurate.

=E2=80=94=20
Su=
