Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3321521230
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904786; cv=pass; b=drd8SrS9P+fjrq+Ha2OAa/ADEHpizJKBmpSSp8BD9Un+rnm7Zr2s39ChPbn1insXU0jA4bHkzVGyScC1YKi+BCTEgYmQhNcFVSQ72gK3X9rM3z6JES8mBEyw/UiW/dUvyI0mOb8WD3bhTMgZOnH7IIRcZ3WN1zckYQPKFFPAckQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904786; c=relaxed/simple;
	bh=sAaNg3SxdM3fDYy3xPI+WTibnl+GpjCG3UhJH/QSB80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lyX7m+AxS4I25JymlfC+pKzWrCEvqb5R7nsBjsCY9Gwlpr9Q69ZdHLKg3E4XqyM4TOkZgIJ87FLng1BP0J0cZfgCdVbk2YaTISATUGfToa7leEvJ71YDJr5JbCANmraMS2Ke2++BswKasDiGld+OW1Nn/vhUwcR2eg2UqVejtsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoW0JWAn; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoW0JWAn"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-836c8bde2dcso19714317b3.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 08:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791904785; cv=none;
        d=google.com; s=arc-20260327;
        b=r3mawr1JlteCLMqAafM4X+kL+QWrUZ3RdJFYQ+Yqgx9qnVriq46GidUzJSE0ET9bVW
         XMVXHluvJLx/liMxQxll6AedNlw4yejhNLpGNH8bL8u6n7VEHxhHcP9dxnwHiAyrlNh4
         XDPc4j/Z40VCPWn3jkTWi4tLwnB6fKd3RLRfR9LXF9kCs3VolfoHBhDnl+EgOoHOVaWD
         aJECdy9kWbJ8/mF2pr4nVcQ2iUFiV7PrKU3xVR2Awel40ozfFkcOgFs2q0UhsjaZtZV7
         hnptQlOTd4fyC0pLi8Ogokl7uYaQZYibBYUPWCdmzwNQTHFlGRBHPTWgUT9qb7bWTbvi
         XSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sAaNg3SxdM3fDYy3xPI+WTibnl+GpjCG3UhJH/QSB80=;
        fh=63cmdGRCgdFTNFc0Flm/xWaet6G3plDbe5XbA7kXBu8=;
        b=shTUMxHEXchvQMSwYoyEZ2pbuYvhkjdEBHw4JdW+GH69mluRlxICWrHcc7i+oSpano
         Q6PQo/B/n2DEfYx7juZOq5aPW3eY2rqDYdIjuSxN13XhEiXsX/tYPD/59eL64Wvge/x+
         llufsivUXFV50YtEoWaMmlEd2z5tdBChXXPqrWnw4GoG4kM53r2uEdSYnzOOZF1SCIY9
         uooPFjpPBy/8f4M92jTxqVVM70YiGNZJPczJEm4NXQXvzGANKbNjlb7CxmIovrnfJi8N
         g+SsrLlfDgwC1JkV8s274KPXLxS1SChlwdqYJLL3PzR/2RRpFhZFOdcjAhdr55zZOmvh
         IVbQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791904785; x=1792509585; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sAaNg3SxdM3fDYy3xPI+WTibnl+GpjCG3UhJH/QSB80=;
        b=FoW0JWAn/OLNJOJOeqahRj3nNkXFQmPINJ5GqCy/oaPM53m5uo1CumoR4N3O6FheX5
         QbwQfDrYZdusNvJWTNjtOpFFfojDsp+n/vphDc7xo7XdMCMciq3E3laA6HNzfhDfSR1W
         ToJjiWnqnH9/JrMimL9FxJZOKi3PbxE6Wc1rbStgKF9AIZP9S0yahZ9C8Wyf8zsTKfKN
         XoPmCQF00vcCojq7m1mukql/7nw5/9QmD+87H0dk9fWCe/yFPupFtkodut8VMe7E0j8e
         pLbcCYqZTlax1a6yXjNc/DSKty1AF0LInM6dwhjAbjz2wDRvDlWyJUoM+OMEZ24jBVCP
         m/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791904785; x=1792509585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sAaNg3SxdM3fDYy3xPI+WTibnl+GpjCG3UhJH/QSB80=;
        b=OvXkpIS2B6vFQcN7Hi6l88RtYeDsgNWLsd2zD5Xvissmrno2+/1H/Pakg11n37qC6v
         c4YI5Jduj378OOotBF3XcT1HVIcMUOcs0MyGEvcq9WRT7KvbxG07ziRAU62UmOKb4PTN
         eBkOKQr/kmZPzBSuwy9IlO+Ez/t6xYl87jL7HbFsAswCgH8VbYlnfOpTDpQtivnsN7sO
         Dn+MzxrcbvqxD646Wmgg116gf/m+pzcYQL+F9Uoc0jroawVFcPwhQikwONegah0OjkCT
         QVLqYAz8ldbB556zc7ITK5lFA0OZ6VtPHcANXeZIku/ns06tWZHYMnQH9WZ07mRxHjtm
         ghrg==
X-Forwarded-Encrypted: i=1; AKwUvBy4KUvGPkp1IR8mOR9G9kCTnSjRuGuNEmatq8HBxPbOkkJAe61+WgB72liggdNL0YT6I92n+y2BX3ornA==@lists.linux.dev
X-Gm-Message-State: AFq9FYKaPpr2TWbN5kilMAD89safEn5rxGHZeZVDmjMoq1i67sBdmxPP
	3vbq1xff4AVqF3qxDYi1uZjmU8GVwSNYNmj1cig7ND5YYLmqUMPTifbYEyCaT70QEXz0305+CKH
	ediSNhOwB0R0bT11JWDuCPw9rJvKFA8g=
X-Gm-Gg: AYBFou0yEGYnaiKBCSC/5I/v2MITbA2EqJQdjguqiSSN9FzUz3dkBGv5pXSKc0IRevK
	anp6QZIZ8cF+bEKyn5DWO0dQy2TF4O2I5C+pQ7hNwPhQa6mSxvoP+OKLgWq1RbFXFDc1b4CYJ02
	QRq8YaCl3jfPApVMu94AIPSGzDvdmE2img9X0uByfyiRD8kbzmCButEHFKKr5BR2QmXr6rGrOsi
	CYYULfu5ealxcsFv8ttNTRNIrnekcV9g+IpFvI7YF744LV+EzTARBmykBz8yOvL6D9OQ85H8KX8
	xLBPm2Pt4VGYlYjHe6MdsHCfhjcWI1cmRQQ9xdR6bx4WAhSTh/8/TpX1z6oGImc+NSre
X-Received: by 2002:a05:690c:698a:b0:8ab:41ed:c08a with SMTP id
 00721157ae682-8b07eab0144mr48055147b3.0.1791904784716; Tue, 13 Oct 2026
 08:19:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0043-v4-24e62761a79be6b84b55@gmail.com>
 <d5522bb5-17f1-4315-b50d-390f1cbde9f4@linux.alibaba.com>
In-Reply-To: <d5522bb5-17f1-4315-b50d-390f1cbde9f4@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Tue, 13 Oct 2026 23:19:33 +0800
X-Gm-Features: AclHuK8gdPEGKJ0_qGMLhW1-G20Db9CjxsJDyOZL76xFGxwXDOzAnrgPzDTY4HM
Message-ID: <CAFRLqsUXNnt7AukXFk3mP6R-GaV6CpJ-AJ6QR+J-YnjoHj4Nrw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: hold a lock reference across grant AST enqueue
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, kees@kernel.org, 
	sunil.mushran@oracle.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=BA=8C 15:56=E5=86=99=E9=81=93=EF=BC=9A
>
> It is better to illustrate the race case with a sequence diagram.
>
> Also please change the patch title to "ocfs2/dlm: xxx".
>
> Cc: <stable@vger.kernel.org> is missing here.
>
> Thanks,
> Joseph

Thanks for the comments. I'll address all of them in v2.
I'll also be more careful with these points.

Best regards,
Cen Zhang
