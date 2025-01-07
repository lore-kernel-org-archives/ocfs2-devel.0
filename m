Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F26156F5E
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 02:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217803; cv=none; b=ep4FrcjpodVXKmUc7zblHFs0KtuO9/SqK3OdRHmIy70Y8RGEAcWS93G6xHFRIuTEBiLF9ffVE/TaftYRzMwRQZcotzz8JPhyToWHYdmQQq9XS93Y+SdIBt1XwXlz3/OwS9Y473pj2cvE0GO258KNRGZTH2Of+da98Hx1bQ3VmIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217803; c=relaxed/simple;
	bh=atmxslussPqEoNewRStGfOlgpH0gRaohZK+PVuWNTbw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SAp6CIXMf7UILJIUS4PduPMv8Rekh3yv23FMnjt2jsXOCHNTE9sdeGncD/6K/jPBGwC5BjOIamSzSbJlvzMih02UUOF5+RURjb9WaPEpSFFiFu1cvHBJZiuSNjsyNTynUEMyXcd3qglj0Rhm2RTFHxf/Cx0FDsbGfAvg/Px/Bik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SrO3bCYG; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SrO3bCYG"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaf60d85238so948412066b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 18:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736217798; x=1736822598; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXUcL3nStPzDQg53+DjpcZtNPpb29NiMyPlb3M2zrrg=;
        b=SrO3bCYG1Odu0I1yOj4tGfa0CufiQM1tK89oK+V/D8d6b855wn74ZRlnyr7Ve8JjkS
         AMeTkzEadjOGksTNgTnYRuZY4V27RCPeKUQ3nbU9FAjofPci/7gMmwVpPtnd1d1R/fAz
         iI4NI0fTyI+oXxBBibhX3+f5tv8X62whPcrg44ahnokusRrxr8rSWOwbPyKuDQ7GBlU7
         MQK/rriLDt/R+K2vVTMxNEjEjHXJz71aFQaeqkUvtmM+a3OMQOaW+ON0wondTTuZSg52
         gQGmcSNoXZazW+IvIJoEpcxJg3oNJ77K/NCM4tl++Iwazulqfx4E0qniPbXy7ScAjVp6
         2tdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736217798; x=1736822598;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXUcL3nStPzDQg53+DjpcZtNPpb29NiMyPlb3M2zrrg=;
        b=sUf0FCEKzVur/79qly0fgg6g156CjOmoGSqtk6bdCbX8Hg2CMUt8z26qBEkvNLnuat
         AyIWljjgKND7wsNfbMPBrvm468VsmwBTqIkUJewpJ9GNuN73nn4rez2emwl11fSpaWhi
         gnhAns4N2echcylmJ7UVAdoPh+k3Z1ulqcKjbPeKj/7ULFrNVCyrEpEzvFl5guksvV36
         xBQJQCg8GwKj8/IyV6SNLG1U6zrjAc0Cbj/NpZO971nB9fXTTKjQMxx5rlnpoU69/9Mr
         iRmYe1/FLgxVhRucEJjzOf4ID4ssFoNmX38F/XoTZ/SWYO0Uko3yWInCMiXfgpeCmGSq
         kzOg==
X-Forwarded-Encrypted: i=1; AJvYcCVbyForyLtgjDxoZKP19pRLMPGKACLV6f7LZDR2tS0aWttQ1Oinm8w338SE05ZAWsWu0kUlUgl5q07YIg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzyJJ+OuFLOcWE2wibXJnhffRthf9wwtOspUNr6+Z7HmeXlPcrj
	yqEBFqyZsJE4RxnCjmWzSEdm1GOVbp8yQw/gjcpLsYAhtZPkT4eAgXKBkZ/91sI=
X-Gm-Gg: ASbGncuhCaxmfFq8Q5CmHJvRVaCdARpD5aTVnS3+8gpOPM5GxrCShXFOzIdIx9smkRq
	6iwIF6EgaKv+buCqIKQaL2qBepw6xYNFzoEADVbqrUr/vDd9RfR11iARWP9qlKxHUj/30L9q9I3
	LxPUSpct8qhLDKN3f5hpG2OOLncS7L/mbUCdCLxdUtZsQKtGFt4X+ktxotVfW29ayewkUBWHoMq
	LFuWezyRS3Q1aYYq9xGyFGoj5YCOB6te9jodHytPYOOJtuA/SDv41UDHDw=
X-Google-Smtp-Source: AGHT+IEsoJUsEaVLjDHC0PLwVOEL4shT4+vkrMouh+CENrtPO+h1kPxYzrZf4uW53TI3pchKVLPBZA==
X-Received: by 2002:a17:907:6d19:b0:aa6:8a1b:8b7c with SMTP id a640c23a62f3a-aac2d44727fmr5685406266b.2.1736217798266;
        Mon, 06 Jan 2025 18:43:18 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cde0dsm299334125ad.140.2025.01.06.18.43.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:43:17 -0800 (PST)
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
In-Reply-To: <20250107021254.GP6160@frogsfrogsfrogs>
Date: Tue, 7 Jan 2025 10:42:58 +0800
Cc: fstests@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B45499F-7306-478A-A860-73E02D47FCF3@suse.com>
References: <20250106140104.91880-1-glass.su@suse.com>
 <20250107021254.GP6160@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mark Fasheh <mark@fasheh.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 7, 2025, at 10:12, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Mon, Jan 06, 2025 at 10:01:04PM +0800, Su Yue wrote:
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
> Won't mkfs.ocfs2 turn on block64 on a > 16T volume without prompting?
>=20
It won=E2=80=99t. Only error will be printed:

ERROR: jbd can only store block numbers in 32 bits. =
/dev/mapper/huge-test.620 can hold 4563402752 blocks
which overflows this limit. If you have a new enough Ocfs2 with JBD2 =
support, you can try formatting with the "-Jblock64" option to turn on =
support for this size block device.

It=E2=80=99s 2025 now. Maybe it=E2=80=99s time to make mkfs.ocfs2  turn =
on block64 if device size > 16T.

Maintainers may know some stories.  Joseph?

=E2=80=94=20
Su

> --D
>=20
>> +
>> _mkfs_dev $DMHUGEDISK_DEV
>> _mount $DMHUGEDISK_DEV $SCRATCH_MNT || _fail "mount failed for =
$DMHUGEDISK_DEV $SCRATCH_MNT"
>> testfile=3D$SCRATCH_MNT/testfile-$seq
>> --=20
>> 2.47.1


