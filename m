Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792858716;
	b=eMnhHrKpsvSXgDbHg2LjhVrryATiI13Ku8SwvP7qtGBqG3F8Pkvkb9LmssJmOnd9x6dv
	 otCW2UupM2SkagUjLPaZ3lattJHxjY65HOwiJrQpnT9CpA2eNWed6IF5u28lO2quFyL6h
	 tRl1vMYPfr0jhylDwVqES3vyrCy4T6NoixjQqO1TEa4jBIDnoy8P21IU4bE4VYJ0ucV+C
	 OeDnekIe8U+ewfEaHivV4AhAtHO/t6niWdADxgNi8ErPZ5wz67suEIE9F8WC6GCPUBy2X
	 bV9i1ApVVTQamI+XsQyuA4Iruf5duwJvcraRMXZ0QZE5D1WDu44vj5rQpLKdA9ypmDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792858716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wJl7a+8EQ6zIyPMzXI0QdmBaUpy3gczzvc67bhOuxfw=;
	b=yLgMyntgODNbkQV5VUTjNgw+R/gyeuZYXwhbe5beSQoEp12+lOztqFgzy4GtJ/s0vUaC
	 64v+6zWZhDgd0+8rgrozhxqVhIF7I4ag+u8lTpFyVBY+YWOhWbpnNjZ/oqWbH+OuLSoV7
	 jWFqkdrIuaafdQpBSWe2Iv9lh/bBpPVjswGFhhOxcNWurWsSAqSQj52O2i59JCF5Aw8is
	 QCHYt1ivTVarZBSljWrQ9GvkRJMPBfLTYoytckNMF06/uz8hf9a9sRXglgNbVlUzWMfFq
	 SWRWOgcTOIfYsxBDvZIC89dHh7mE5PqNNu4WLwUOnHLeeyphU7q7BcE8Elg7Qc3kv6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CShq1mtJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59DE606A31B
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D59DE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CShq1mtJ
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8ab395abf79so15770527b3.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 09:18:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792858715; cv=none;
        d=google.com; s=arc-20260327;
        b=fW++/xVNRG0+KxKjJreaSm3daplrHlzUiRrdzsSHzen2iDBCLBqX1ZNFjDj8N9zNM5
         hKY5lA/L2Ic1fGIwRL2lKA8FiGQyGZsTUVcaoM6ETUdYpBzu1QrLpeAz8EVAw4y6Y+MN
         lzSEEY0PiDYSSnlhkR12fIIHS2c0YxUXsjQbnU6IeRIJ3gRjReDYT26a4FNI7vUswz37
         eJ4KvbSbaXCozh5L3WWWiDZJwmRdaEEs+VUp3mZmcOSNjH9UJvINAj3OsacL5bfq9kih
         rQ9PE1mp9evSbk3dxHstd4xG7dq4Q8Z4TcHWIJX10xdDfwdnpUG8HVEGFJ3kjMEv9t2r
         8cSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wJl7a+8EQ6zIyPMzXI0QdmBaUpy3gczzvc67bhOuxfw=;
        fh=SwbE4CiGAWqiUyfwsHqEB3J42jgxmgn4OuuJmU1syvQ=;
        b=RDV8vQNJp3o2aZS2fFfhylWbf0Wf3oQl58D4RIe1bmYIviRZ+ysJe3FkTrpIz9y57N
         gTEBhpEergDZ63rG+6JoUu2miXJJ64S3TgyM4qVFnjZjd9/Jf9g1p5s0L1Nemoj0QDBA
         wUXekFSXfAoOu54A1QEKVrQwwDxdUY7+9hncsfXH2gSgDOmznCt+OxIKbDjLa2iumbfW
         OoiJcZzla7sQOXIri552h3QbpsBVe0e3sbfGZ2AK2D56+Boz10T5KJyF/hm4CFELpiSN
         qbxvC4Tw3Due4WH6smJuXDAqLyb3/b2LYVXgCQtI6+QTzY+7ZxMU4raelUd80osXrggo
         f28w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858715; x=1793463515; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wJl7a+8EQ6zIyPMzXI0QdmBaUpy3gczzvc67bhOuxfw=;
        b=CShq1mtJDZIU8WeoqAXeM1FKMDjDG26oN9w0ox0Z7SyhmSANw4zSRVj5x/60QKmqBZ
         7VpqEXac6i+znqqOKyKVrDvm8UBCDJztIeFXGMSOdtJPVe6jd3/DVxCkLQc4WMYxKG43
         cX9oPau6RNevO23jDrTPUErIRA0kXudSsqXTtgtNKmgem3HTkhE7vJGLhBwu+SUnBkEO
         HEe53agKSUeih/5gu1RJqySEgsaSrLwy9hXm8QQsIV52b6t2W6vRrmsHrsA3+MBb4bIN
         wTzzlW38C0w6Zn1cI/mdLeqK69JnSiJmiNaxVUHMVWg9cWCUDSerbUwZRP6G3CBgSk0i
         cT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858715; x=1793463515;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wJl7a+8EQ6zIyPMzXI0QdmBaUpy3gczzvc67bhOuxfw=;
        b=pGf2RYNNgAvAwZwjyiZ0EtPtTmF7CUxX1c8lc0TXs0cO/lRfpm/GFxZFgN/ksXOVGx
         sjda6n1kH0q69P/xGNeb2edqjvXievalmn9APlvFSPL/26lceJNgVmiyqxk/Wb59mzj7
         0r1VoTyshFY40MgiIFKwqAlV4uK42CzOcoadCXcGEvQ7e+ynoKHm3OPrOfdu2+pkgEQc
         VnYRJByI5a8fNKDMlRWK+Q2tywm3F72CbBXTliMPFdZBfemBjbDwQey6wrFLoFiDxLR4
         1Kjm0q4LTAKG4OSCkxUJuNpCLZv4p62oEMMD4KIEmM1RxzGcU2dNd6+KXmizW0Q6iEbc
         t+9w==
X-Forwarded-Encrypted: i=1; AKwUvBwBAz8Qdse2rtAwnYKQMWIoK5GLHBYFqO+6TYmM8tGLTG42pFxqjes9MiBCjR/w9Qo7e1b+JkNOUTFKjA==@lists.linux.dev
X-Gm-Message-State: AFq9FYKWgvHky3m6WoYECHEYxIc9uKD/nYhL44MPPlhsiTIRNX8799BO
	8Enf5osvvqQ4w1AGjD2YpnLsYoOH2vnYQacOhoEAqbORJG3V/m+Sd589b9kyw6hl9Afi+pihbwn
	VrhyZCeXavK9yJVrawmRbMV7KZZcJbCg=
X-Gm-Gg: AYBFou3MVoHBOrs+wqqOjUkAS3IE7KHGFXchY8sWNXaXvxlqGMm95IhkgokxqbhZZLh
	cGg8o24xp+Z86SgRVDj+gkKlkFLJ542RSrzHWTLjbloAJpa//ueNNDieMf0ai8JIShjrR81O/cY
	649VFbnNIyMYEgMRm/wPYlEXLLOZbyiX/Y300OhZI9ocOkqcmKMfcqNt/Q6ABVpagH1Xbl7rUHp
	WPCaD8sJuLoPQBppXKErgeIEao1rK75uhUDycTnEIk0kgIudx+ybn/wUM5KkmXcjSh9bP2SfBvt
	LfgDU4fRSCP5jhFBpVw+HhQJ7nCUaPtrS71yPTc9k+Vox5ermbmTvGKSD6iTtqub/82L3ptZGQ4
	oxbz5B0RIhXFHo4oTUESsX30lDZOnThWpdyRl9XR/
X-Received: by 2002:a05:690c:89:b0:8b0:e13c:2854 with SMTP id
 00721157ae682-8b1669e55a4mr18271807b3.5.1792858714927; Sat, 24 Oct 2026
 09:18:34 -0700 (PDT)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0087-v5-4888399e71ae6d93613f@gmail.com>
 <1868bdad-cad5-4cec-8d76-af6f3cd92479@linux.alibaba.com>
In-Reply-To: <1868bdad-cad5-4cec-8d76-af6f3cd92479@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Sun, 25 Oct 2026 00:18:22 +0800
X-Gm-Features: AclHuK_VfC0_HAFy2LMxdYARoi52mIFRU4CCMwSsyLqo5xk4mZaw1sLNyRN_7E8
Message-ID: <CAFRLqsUXK3rX6-uM3+2cMmSCPYMz9WxNGRXh7zG1+1YhNxTjgg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: wait for filecheck kobject release after a failed add
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Joseph

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8824=
=E6=97=A5=E5=91=A8=E5=85=AD 23:49=E5=86=99=E9=81=93=EF=BC=9A
>
> Why not name the owner directly to ocfs2_super?

Thanks. I've updated the comment in v2.

> And "delayed release" is only accurate under CONFIG_DEBUG_KOBJECT_RELEASE=
.
>

The delayed-cleanup scenario in the commit message is also
explicitly scoped to CONFIG_DEBUG_KOBJECT_RELEASE.

> Thanks,
> Joseph
>
Best regards,
Cen Zhang
