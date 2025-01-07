Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F6F1802AB
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 02:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217930; cv=none; b=HyJquwwxZmVBGMdOZOopEsbV6VOr84b651EkzEP8+ZibfI3r0qd5KquXKILYtCvr4uz4Nfby+/Zft7mYUpTlM/T4+np2DA+0ymiyGXUZqQ3GWiC7eXjfLh4xHDgWtWH6n8OwPkFn7f8vihyq7WdlQW4Q1R1IgTDvwkDtRLYsyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217930; c=relaxed/simple;
	bh=GwqqC/XL0ZQrreNBUYCjvO35/oh0f49UocBRMzLayyY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Tqen3Hr7d2D1sI5tRoiLYitSkehrI98FnqzhTgwQAkxui87/Zj73GYw0t2MlMehjsEnXmnbolf6oqfkarmGwkwHcV4ws2uFt2nkZXlTdZ3RKw0NbpQiu7CIvdp+hnj4mPZcX5HSJfpvUjP9PQkkB/7l9eOT+Qsnz4lIQZkcbRik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Wmb5oIKn; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Wmb5oIKn"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d34030ebb2so10185648a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 18:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736217923; x=1736822723; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0+Wl9KpXKHSFmNKUqWC8LFNRLrG+VpH7xwEJ8wEn98=;
        b=Wmb5oIKn7IN5iZ3sAjSHHBYdFxpggMQzcyDtsn11Tv7YPTyWN7waFSwlswehGm+WbI
         kD/eN/b4WKFr50kKuu4+332qkz3210IyaMLHqZ5lm7Hrbzvb3ENr7/4jdcXJbmxzC/Ir
         aeM5owB7XgB7JxGQLFOP4FJtxaEQT57z7kHpQYNac7OJeiHpFmJw+snMpltN3ut6CBKI
         TAAsZcF62gIX06p4sWuLr3qv1VYJ/Rcjg4Uvo0Efujoi16P66m4E2WAarV/K2OwtegeR
         vyDcwDg0gHfEVYQTZCwZADxs1o+27dD7/rXNCb4Q+3LdGVK4OdEOjrL8WUQlaR8N4HxR
         FClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736217923; x=1736822723;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0+Wl9KpXKHSFmNKUqWC8LFNRLrG+VpH7xwEJ8wEn98=;
        b=ZWXtoc5cyq64om6ZqpXa20a38bw1730qPVWPex7vu0wIptSvzsybUMewGFGIVeXY4d
         HT3JJBCtchqbpnDB8cvokU0mcssnCzKDGXEcQPRCuJ63QMIa/p3WK8arYJedCfB6OpBp
         ErIA388SLrtKID2ekyfUgEICKkkRmrpbpbPaRXHFJsL/iNG4r7HV3F1OlgMieyA5DRqJ
         rN/mR5xxwL6Lr8vDB+oZF1C89APiSsbHQ0LJCNQXFEDdAJ99pr+sYwbiJTBSUVjheHfi
         cNX8nWeU2EIHoPBdcNLGBs6I377oYyd3aiNkGisiS1ZINlYV5IkvTAF/4xOAZwGK38qh
         Ny9A==
X-Forwarded-Encrypted: i=1; AJvYcCUmFtRn0W/gAK5NoBnIc2zBpcJEVsmQLUCbN83mjHsXEEyQI6LqYZSUCFzuQcdaPn70aNG/mkmjKii8JQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHDLkFGNEQEoFZsN4ISS+TifgDUcQnR+/Cp5H86AFeEJtLolsv
	P+gsMmRdeJtSueQt+cHPcOdNIutVfFGJ0bXM+tGKy3tYpDZo11DS7ifnbICOMpo=
X-Gm-Gg: ASbGnct+Iglmj8+soKpSAqYAIq7y+0v2wrKdGahfYG+J3FuCABW4dZHvFQ4Pdnp+dHv
	I85Ma3rGpbIPWcid/Tl4MApaO3hgC+sIuamimFgT4TTkVPKdWwjx4rEKeCxs6XMVD4y1bRnil9B
	gdifaru02SxPE8TGLEaICUn/r2QCIciiBvTkMVZvIjee0B/Rrf8IQqHhfU0bvqsdoB6Da1R8+6T
	zPWOOYWJf9p2XgLc6ZI2JmhMMEkk3RgUFih3ZgXvypdGg7jjmZkyQL7flE=
X-Google-Smtp-Source: AGHT+IGpZU8Q8czntxu/EcGQkulwxUxwK0jj2h3ltb1dV7Ksvme1Oezp6veKXUsnLngsysuVPQDFXw==
X-Received: by 2002:a17:907:6092:b0:aab:c35e:509b with SMTP id a640c23a62f3a-aac3378bee1mr4924027666b.55.1736217922798;
        Mon, 06 Jan 2025 18:45:22 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8f90b9sm32125994b3a.131.2025.01.06.18.45.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:45:22 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250107033901.5da29524.ddiss@suse.de>
Date: Tue, 7 Jan 2025 10:45:08 +0800
Cc: fstests@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <0B21E83A-FD77-4A05-A70E-A580F84EC8D1@suse.com>
References: <20250106140104.91880-1-glass.su@suse.com>
 <20250107033901.5da29524.ddiss@suse.de>
To: David Disseldorp <ddiss@suse.de>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 7, 2025, at 00:39, David Disseldorp <ddiss@suse.de> wrote:
>=20
> Hi,
>=20
> On Mon,  6 Jan 2025 22:01:04 +0800, Su Yue wrote:
>=20
>> mkfs.ocfs2 is using 32bit journal as default.
>> For 16T size device support, '-J block64' should be used.
>>=20
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> tests/generic/620 | 3 +++
>> 1 file changed, 3 insertions(+)
>>=20
>> diff --git a/tests/generic/620 b/tests/generic/620
>> index 3f1ce45a55fd..60e5a2cacdda 100755
>> --- a/tests/generic/620
>> +++ b/tests/generic/620
>> @@ -41,6 +41,9 @@ sectors=3D$((2*1024*1024*1024*17))
>> chunk_size=3D128
>>=20
>> _dmhugedisk_init $sectors $chunk_size
>> +
>> +[ "$FSTYP" =3D "ocfs2"  ] && MKFS_OPTIONS=3D"$MKFS_OPTIONS -J =
block64"
>=20
> Makes sense, although as Christoph mentioned, a less test-specific
> approach might be a better. E.g. _require_scratch_16T_support could =
skip

My brain is clearer after one night sleep. As Christoph said,  I think =
it=E2=80=99s problem of mkfs.ocfs2.
Let me drop this patch. Thanks for  your review.

=E2=80=94=20
Su
> if block64 isn't configured, similar to ext4 (assuming tunefs.ocfs2
> provides a way to query for it, which I don't see at first glance).
>=20
> Cheers, David

