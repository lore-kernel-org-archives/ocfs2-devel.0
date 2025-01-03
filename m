Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100AF156F4A
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 02:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735870561; cv=none; b=LehQx/EIv0C8x+eJ3Frl9mFng6CF+dLgcrAXBjAu24DunwSvpceZcJ4FoiqSSHiCRkV4sOfYIae/68OqgIJmg3fqCzWxXJF/l75HmBv8N7yNV8++JARIYorfXgzmHpuYtGMz4tdPzkGF3xRrbYtaP4GPJs3MKwSvEnMk0xJw3Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735870561; c=relaxed/simple;
	bh=16JyeGcZhO6N8M9DrC2Pewv2BmOQPn7z+2j3pnY+0ss=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GOHiXeWkHlf45H3tg0XOzwaEWABMekq0qgkbKFW6QxowTAxXZqqDN7HhOVoNMzJjdGJ2zN23inUPGyLvE+TayLd5skxT6NALt6qoddWanRHGEWLKA4cAOOYKdPh3ZsT8nHlZLHbMWrSLCW71LuMybKkBrNVIZLNCCnT07bRmbNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UYFcq+Zi; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UYFcq+Zi"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aabfb33aff8so2085507166b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 18:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735870557; x=1736475357; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G85eIimJOwvIebQ1a2ZuZyAhXaexvjXC3CTzmDry3Ak=;
        b=UYFcq+ZiuFf9oKrzDpzG2D9mhi98fY95VTkDAPY5EstSeLcemLHW6QQzCVRoQYbkja
         jnFQkdDGFkJYA+H0K+pjyIvpfkhmTIsobbIhfkhlzvrDOryyPWpVBmEn5Qxq8lBQBkC0
         VInpMId0c6VWzD3jt5rA1tVBwY5UTXgReDNGzwwjQeEecY4jMdKFtsyys/Y3GPjIcPhl
         AYzwuQ8l7fgonFGLpSqS/T+ZWJvVEkWwRM6ToiOnTAlE7sBMeD/lkl4RkE+LX7mhOLtY
         COT+iOYMQ4PGOyVOekBjN30y/nRjHDYz71r9tTqOMHUL3BYzXeccanP3yiUVPZyjFIpc
         OoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735870557; x=1736475357;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G85eIimJOwvIebQ1a2ZuZyAhXaexvjXC3CTzmDry3Ak=;
        b=dXUxpUWaDjnr6+9gYr/Ouup85BsMIUG0iikluJQcObhbG3WQ7OyxX1FV2fJ0GkbkZi
         ypzS3ESuXaY9B/G0zwshrPfn5BWOEYRIEt1TJizdWtGL8vrKACsHY6n9apbBlWEJ7uTh
         nGWtpRxOqsFwZJtQjkL+7lVG6X3OJcf2dCqRCuewyACDTQp0PyUsIpoE/eq0x+/R6GDa
         rYjyFyHFTcW5sD97tmgGGBuj2bmr4m1ct7Qg4/VYobkHzTbVxrkYvVKYpqdrgRrSOiJx
         0q/gmPpWLVeeAdO80nsrH9l5TlPeHvHo+iLRq90SrYiCjq1azUOKI+C+12U+o1To5v2J
         bIEw==
X-Gm-Message-State: AOJu0YxqBDCnUuNqo1CHlXrDitK8VXs+of0XvZ/NGQIsCuiCRfY295hI
	hVVVjkO215h0GyxAoba2fqDepgx9F45AUxTcfdKFSBEq8MVrSueWdsKVWN+q2BI=
X-Gm-Gg: ASbGncvUo03P6kC4HktHKgvzwh269nCAig7gFOBu9JeADUiS/j+PiEix8G5WOiPTVGM
	nWKxBmL6X88vipO9mx8LW0JR84UnCSMn4g73I6if7cLYq4p5EUuCUGp7VtUwQ0wg/MXgJOxDpqV
	p30sSvTlf0iGfStCGgRlQiqw7I1akNQAddu6R8tGZcjcAgpJFGD/EyRV6PzNh6ukqTdpXD2Hdpb
	EDwYOZ0b+ZnfQo926WxTFp8JTlfNbcrRy/MVrmWYzDSBJFq2id3wbjxz/cf
X-Google-Smtp-Source: AGHT+IFoww/h5irmUyPYgp+yy/jSCXmOoASL4vagRBoMqZogQr22V3jUj4jpeT6mdIvjim0UEpt3wg==
X-Received: by 2002:a17:906:528c:b0:aae:83c7:6ce7 with SMTP id a640c23a62f3a-aae83c76e6fmr3816469666b.0.1735870556909;
        Thu, 02 Jan 2025 18:15:56 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbae4sm25097868b3a.96.2025.01.02.18.15.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2025 18:15:56 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250102124539.711325-1-sunjunchao2870@gmail.com>
Date: Fri, 3 Jan 2025 10:15:42 +0800
Cc: ocfs2-devel@lists.linux.dev,
 mark@fasheh.com,
 jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B8A96D29-146B-403F-8AFC-4098488599EC@suse.com>
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
To: Julian Sun <sunjunchao2870@gmail.com>
X-Mailer: Apple Mail (2.3826.200.121)

The subject is too generic. Would you please change it to something =
like:

"ocfs2: check ocfs2_extent_list::l_next_free_rec in =
ocfs2_get_clusters_nocache=E2=80=9D?

=E2=80=94=20
Su

> On Jan 2, 2025, at 20:45, Julian Sun <sunjunchao2870@gmail.com> wrote:
>=20
> Hi,
>=20
> Recently syzbot reported a use-after-free issue[1].
>=20
> The root cause of the problem is that the journal
> inode recorded in this file system image is corrupted.
> The value of "di->id2.i_list.l_next_free_rec" is 8193,
> which is greater than the value of "di->id2.i_list.l_count" (19).
>=20
> To solve this problem, an additional check should be added
> within ocfs2_get_clusters_nocache(). If the check fails, an error will
> be returned and the file system will be set to read-only.
>=20
> [1]: =
https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/=

>=20
> Reported-and-tested-by: =
syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D2313dda4dc4885c93578
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
> fs/ocfs2/extent_map.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..83d3343b3e3c 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -435,6 +435,15 @@ static int ocfs2_get_clusters_nocache(struct =
inode *inode,
> }
> }
>=20
> + if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> + ret =3D ocfs2_error(inode->i_sb, "Invalid dinode #%llu: =
next_free_rec is %u, count is %u\n",
> +  (unsigned long long)di_bh->b_blocknr,
> +  le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +  le16_to_cpu(di->id2.i_list.l_count));
> +
> + goto out;
> + }
> +
> i =3D ocfs2_search_extent_list(el, v_cluster);
> if (i =3D=3D -1) {
> /*
> --=20
> 2.39.5
>=20
>=20

