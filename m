Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324F3CF02E
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601772; cv=pass; b=EsVqDyIb42Lc/saFwnv1ZSsL22sx7eUxghRWkf7y2KhN7puVHeZcvmcRrqfxkgWg574Oofte4s6xlcD5ibo5z7ZTwvvpYgQnmMf/NWmXtZwD4cYWOkXQAz1+Q3hWKEeW5+7/6Oc6+pPxegG3L3t5Yu3X6axoW871ZkPJREuieWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601772; c=relaxed/simple;
	bh=TlMhiUYmmLu4FerCb2H3r/AO80kko0SMzyiAQjsjTAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SkbvAzhGYrOHnrfXC9wabSArxE9uT2ExMI+wo1i6Os5M6f7AS91Vm7dmApwjFgMTCyGEjlYlbmAiAAnVpkr3nRPjXG+wwkO4K8ER+5AXffrEEVrwMPzTzATIXpvc56zKRdjXFRDFdavumn0QPROT6NrX74NBH9jtx8S7ZhNyCX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chKfIwL9; arc=pass smtp.client-ip=209.85.167.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chKfIwL9"
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-5aa68cf9123so4288737e87.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781601769; cv=none;
        d=google.com; s=arc-20240605;
        b=F0BJ497NN5DxlGzdtfUI5fAOkSMyyVKA85XRCn5SEwYp0cu4yKtngsOc4T1FS5Abjy
         4rFJ63ibtQsV3aKVi9XmT+2+jjbJeZyX/U74DUIS/CdKQuUii8H0dxUVszbOE7b2kHY/
         ddTVXgM4CUvMj05FkiFhn0KDysxrsQPn3REohiUAvgTt2syDWlbQGY86ZP8cDkzfMo6V
         BRR0dCH8A9hV5aw3Y5J+7hGWk9XBBecpuqiO2dWJDjIg56+s6VHNPvsBWLE6IzOZQdts
         4NyKrsGlx6rtL4gI7/dBBWeJfTajfr+T/+XLc/muSGiL8VtkndyxLcuNdDTgIzF4JKcT
         vwNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TlMhiUYmmLu4FerCb2H3r/AO80kko0SMzyiAQjsjTAM=;
        fh=p1XjEeacqnM+QhRfTa10bv+ffm4UsixDPt9tjbpXF2o=;
        b=hWWHsIWZWYTBFP9aRtsgXCphY8RsyHOWL93//iMKmCJ2kI7U88fRf082iEPG+Fwh6a
         b0sPwdo1YfUzaVMBD2FjaGazqL5TPOmY97T2pq5kS+QkwPbwnQfT4J5bFOw0Tnt5963J
         x4CGPzaj7CZY9oDvrYMm0ArOUL432H2RMSVJRUR89NuOjf+DLhogkPCUf9e5kG4D/vTz
         x/FV3t2e38hatr8uKH4Nh0DSHlms+47PX8Sk/VVn3uIBqEKHZOyx4FBznFrzSrxxvf+R
         EA+lCVrw6G9oPAL9dwvIf5DPkI5TDJL34zBq+BO6QTaySHTugSRfH3ugTTm0CIvWD/LH
         HXTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781601769; x=1782206569; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlMhiUYmmLu4FerCb2H3r/AO80kko0SMzyiAQjsjTAM=;
        b=chKfIwL9iXs47CxeH0N1cCitU2gizQ2EAaH/FwZ32p3cigLn9u5eiq0dvzGuQVTgFS
         nicTf4XV2ToZvnVaMGNarHszhVXerwmyNVfp1lLmTtCMhpuvaEE6QTFonOavbf+/0q9Y
         vz79zuC7VwDb7W5kdSAa1odBvEuVh2MsrsIZL2sWmjuLC2OnEGdI4BlQO6UtC/YIU6xv
         8FUDy2tp2TvELMxJxMK2MTmr3Vp+RbFKZYyADcMhiX3uW2NgI0sLrddu8ts8hazJ8btq
         4bo31c8mfSvt99VAbJfG1EcK65JG63zvb+dv+luIl6kGgIkQZvONVD7gr+L0YUzpHOdD
         3HPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781601769; x=1782206569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TlMhiUYmmLu4FerCb2H3r/AO80kko0SMzyiAQjsjTAM=;
        b=sqrONE0GIabEGZOLED+G2LhyTryL1Yya546bT3El3XT2RD8Tto5uEhR3Spy0SnWuxD
         igLXTrocR9a+seF00VYO3Wr14hy4BSqqyW9JE06J8ach8pDCZup1Kg8wkTOKPRWzfP1L
         TDieu82lxfg1G7hDeKy149lvhq3gXNorNbJhKJp6VPepSn1bniNnejZ9Zeq/U6Oow/o+
         1U4sAK6kHe27T890DI5aLzkVtxttMqo/DfQBapycp64xC8rEybtdgsGfO6rbwJIj1L34
         XQE96z/7fvAm9dfdzTNHTc88s9OAyQGsMJG1oIhddEfLK3o3pvHr3Nf7+g+OvhAaj/ux
         CXng==
X-Gm-Message-State: AOJu0YxRcMNAb8tzrQ0GFkGmSvr3C/06JgKtqzkG4AB4qB+bee89OvIe
	A5UFJ2O4gkDwGR5TtW5RfHbk1OzKmfMa/Etesb1hfow0C1ITbgT6RNAqjtqHAAbhmoygnIZ7ASx
	HxeohMnPjCq8xRc7oUyaMJdh80xh5pqV0x/YiKn/bkNQAiy418Q==
X-Gm-Gg: Acq92OGXvv7KzJ7jLuAJnu0aVQ925h7CgemiH5NW0N/Hyd8nl+2Z76c5T/CD7qREIUH
	tvanUngOgKrXgeVPKsJba86WgQDhlLdNLqW9aWBa/JH3xZTyWiFZt+80YoBf2ff/vI5YztEW4U8
	waWOfGkGlwL1I5ZPEcTbSRCxKZO0MAUlGFD0lt2Kd2OWneOr33zBQTemUKqiiT3JOMmq/WDZMO4
	of0Iwd5XUgIvLRr5/G7qYsQCqjZ13Pim2xeuy8zcdVhaergfDy4IIBZQAaItKBcg1SrBDkKF1iW
	RF1XjPJBYcR7lsbfR6UUTP6YonYE6JfGZWStr9sBWCAIqjbti2aE0ccEr2IHJhSmS90qLUTQXzu
	A6A==
X-Received: by 2002:ac2:546d:0:b0:5aa:6b6c:ac54 with SMTP id
 2adb3069b0e04-5ad43723bd1mr593407e87.42.1781601768862; Tue, 16 Jun 2026
 02:22:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260526034040.3602377-1-rollkingzzc@gmail.com>
 <92497bd5-028b-4966-8224-f2878120da00@linux.alibaba.com> <CAB7XQsFM-W_Fg+rkXDB_zBaWqnzx2daxoL6wbjQYVsYwie2_Bg@mail.gmail.com>
In-Reply-To: <CAB7XQsFM-W_Fg+rkXDB_zBaWqnzx2daxoL6wbjQYVsYwie2_Bg@mail.gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Tue, 16 Jun 2026 17:22:35 +0800
X-Gm-Features: AVVi8CcfQbHWrEpCxcd7dLYMy1-wTMN9LdBysxArATR_XB6NWAwuBLo__QwPEcI
Message-ID: <CAB7XQsHt0Y9DAGV17F8Ng7=UzssXSiQep4wu9iycBDHUv2Zz1A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ocfs2: validate xattr metadata bounds
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Sorry for the confusion caused by the mixed sender addresses in this
thread.

I had a temporary mail setup issue with my usual address, so some mails
were sent through the older address. That has been fixed now. Going
forward, I will use a single identity for patch authorship, Signed-off-by,
and follow-up discussion:

Cen Zhang <zzzccc427@gmail.com>

Please treat the Signed-off-by identity in the v3 series as the intended
one.

Thanks again for your review.

Best regards,
Cen Zhang

Cen Zhang <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B46=E6=9C=8816=E6=97=
=A5=E5=91=A8=E4=BA=8C 17:07=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Joseph,
>
> > Wny not consider move the validation into ocfs2_validate_inode_block() =
and
> > ocfs2_validate_xattr_block()?
> >
> > Thanks,
> > Joseph
>
> Thanks for your review and suggestion.
>
> That makes sense. I will update the series and send out v3.
>
> Best regard,
> Zhang Cen
