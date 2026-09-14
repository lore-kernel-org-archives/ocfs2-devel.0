Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF6483804
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396286; cv=none; b=FVh8kQ6HAMcarxVrgRo/ZVL7Pne5gNzJTQg+cVK87hBz45K3DHPMCEMaf/32Axe4OYsnHYfSWvFPHXBkNCvgwDN4OqLavpPuEzlxn59AANjPX3/cPAM3EnXw6/8j5LEmfoWv+tj64eoVu2rHKzM6b9s12hY1ZRajYMvawEP50cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396286; c=relaxed/simple;
	bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=exIN9nbsIx89DTbCANkbVNfUWIkexvuVoCsWvxx/3FfF3CodGiEZFLasmXoBmQXK+mcLeE+YpArt5s9H7XQAQV7SpuNGh25dTKz0ixpP/N/e0RkkAeZCST8n3eTcIwHnSUl88iQ6r3GKzJfAk+pXvO4RqXYUmgbzQHdvsAHxaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x0BgFBqV; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x0BgFBqV"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a98dfb8002so2597485a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 07:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1789396282; x=1790001082; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
        b=x0BgFBqVn09l5lsxT/5C37YqBhQvJkoPQjPuiPW2cZzx4qwTmeds/sjKRZoKkHHxN/
         YTbNhaSuKeMiy8GzgOSqrZe0K0Q271X6jw8KKpgvsDImZu8GaNV+h/d1dc2CYJr2WkBw
         nm+bvfRRemzN028lPecxHQb6T2QMX4ei65JOhk7vyV54v/DzzdaIgmE/w80khhepFaRL
         BGVC0qBMHR42W8PMHN6VfUAbDn2LV9/f58XSzBKgBYJY3j/C2WzM3f3/w1f+Qha3JYOa
         0Apslk8iSZa0cXVYZntzkm4ONbD04m6v8yybzi2Ypc4N6OiDXTurBtufqe/WJ9OvlkdK
         aSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789396282; x=1790001082;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
        b=Oix4Zqsjjm5F9nMYcy7b0XrSIyqmQsvIBSSzAki+l8qZsBEqDDHXbFaaqvN9e/npwA
         JxR3HkfIapIFbnQl9t0QcxQ5yv8cdofxfHzaJe3fYOEweLG/9aPx310PXNCupiZOke2H
         q7vBY/iTxfr4lwVPiwxWBBGtYDRCxLlvWH5/mb+FMWsmmzjmRZKumhNA/AAZC7RaHOxY
         8TUA/Iufb71+QESW2EDAJmFSM036nfQ12PZj2o/eZfdOyKj0I9X52nnJRDhRX55xWd2M
         UJDKF8EVTU5xMvhlCSjsvntfEEQDcxbV+je+ZLXSKcs4B6L6WW+mPECYUDg2VDq9xjCu
         Xvjg==
X-Forwarded-Encrypted: i=1; AKwUvBzZru74MTi7/FUhvCaYX6Eg/p4TWay9P8jCyPFXfku+hMyhnJPyIqXPJFCcjtgI2DtG2dti+B4ex5I2lA==@lists.linux.dev
X-Gm-Message-State: AFuF++mk+nDBHHL5a0ONcuV3Apu8Ok30M5REDIZ7WQfTvc0qp2VaHHx/
	r1dZZrg+diVL89apyjm7buJTEZGLbqzXQlN9lPqNyQI71RjHPWxWORtDvx5i3ChC3k0=
X-Gm-Gg: AYBFou0ObcA1B67NELdJ0LdV6dmg4Fj5ZBglbeVvrlDGlDH6AMeTHjkqg6NvrtGyHZj
	6/nShR06blULOOgklQA/cg3HOELN/z2VoElOA5APd7nV2Z7Ugz649OAwWmUiHT8ZkKmjLFORIGa
	rtqWPKo1/wPQ1Wnl97MIWj8YyDIeJvxzlTElrqGVcOzBmr8vvhG6u9QQqZ70sU1mWTa2sB76+5y
	Ki/xr5HwK+0S38lF/BiaQc1hIXjBggGvBZTBIf4zaehIMFbv1kRs2UW22s4/7+7SLbdcXgndOZP
	aIp7spRg1tf9qoEEV5iZiGu0GcBxvkxcU2Mcfcav11x7ehuFgQjyRBxt7eLqOSiqngeC0lNLvWX
	i62ZhT8DHFOJ9azXyFrOFHLMU/ikxLK3noqObhC6UXnPPV+75BOC+8EjBqiAXsGYcw6htUWhmGr
	Dm2luumlTvWlNv0FSkmuXNJmibwfrZGka/IYx3ip1MLkJOTc6eNj/8RJ0p9bezLEDsU77TQapgm
	tk=
X-Received: by 2002:a05:6402:1ed0:b0:6a7:e514:1d85 with SMTP id 4fb4d7f45d1cf-6a9f624bf08mr1626452a12.13.1789396282078;
        Mon, 14 Sep 2026 07:31:22 -0700 (PDT)
Received: from draszik.lan ([109.255.181.4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b58314fasm4317005a12.3.2026.09.14.07.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:31:21 -0700 (PDT)
Message-ID: <6b9d4e9f8c16c6db084402c54dcf1b046b56823f.camel@linaro.org>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Christian Brauner
	 <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, Srikanth Aithal
	 <Srikanth.Aithal@amd.com>, Luca Weiss <luca.weiss@fairphone.com>, Jan Kara
	 <jack@suse.cz>
Date: Mon, 14 Sep 2026 15:32:40 +0100
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-09-02 at 09:33 +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().=C2=A0 But jbd2 shadow buffers have a NULL b_folio since co=
mmit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.=C2=A0 Submitting such a buffer during journal commit oopses=
:
>=20
> =C2=A0 BUG: kernel NULL pointer dereference, address: 0000000000000000
> =C2=A0 RIP: 0010:__bh_submit.constprop.0+0x87/0x120
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 jbd2_journal_commit_transaction+0x932/0x1b10
> =C2=A0=C2=A0 kjournald2+0xb2/0x250
>=20
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=3Dwriteback.
>=20
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>=20
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data di=
rectly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> =C2=A0fs/buffer.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)

Tested-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org> # Pixel 6

