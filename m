Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC738E8CD
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305497; cv=pass; b=PSyE4pJG6BraRQnSzJX1bWiB3R3H2YEkHqJPQ4QdYdafMQNnehCh43xB0gP7TEpMY04rc6DoUag52apjNPPf+Ud0p4GvNMyc83Z+sRar36CuIhjGbWy9mDjo65YC7SUDw8URZfO74mQEzr/Nm5nqpvrAdeGXDhskdEriSV5udsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305497; c=relaxed/simple;
	bh=b9OJBisUOaludNj86ZlauzUnEhwjFsjPtwh+x8NfKgg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=sH5pXhxempi4i20DyQlQG/0tJnHvrrUngrV/gf/R8lJ/9/wD9Ljev2UwFcyfM9WMEYOP8OPsVD8jmH4l4ZUVJIyayseb65hfhyPKsDVqSGXDp4WLWMtJnJ6mRdlT87VtYBqZQZZm7BI8YC+etW+3yGapDy5g009Mdd8vPkJ9Ewk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5HzwLkZ; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5HzwLkZ"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7dc93d02916so37057707b3.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Jun 2026 02:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780305495; cv=none;
        d=google.com; s=arc-20240605;
        b=P0z82Y4Z56spvqD7sOse7fGuMwlZdrjMSnd+Vtz1khgN231lO2/QgpirZMTrJCa0e5
         h+Rz8UyVXLn1AV9hkE/N5EzywugmktQ+JSSAEj+iFvNkPHZa8FoePwdQp2vDyxxQE5b1
         rixG0j0sXF9IvrQXEcj/rbegNxp6WmYlMjAO9BR9aDSvjZQqsmPHbtcA9K/R8kT4DObR
         JcLvKhiy0lysfpVWuETppKGz4mUf4a18Gka/HNeWSUSoBxpzqUwCRGbl07c7ZuNS65Ok
         Gk8jbD8ikUtOnpIUiw/e3dLMJE1aMCKX+5iOVVP30Xtk68CSzr5F5k/Nssj8kX7C+Z1K
         E+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5AwwmZzWn1LtQWZ4Hv9nlhnSuMCEUjCAg0q/ULRs1Tg=;
        fh=muHN/+lknAEmbUItwfEKA8udxPRPhqP9BQDbNJFSihI=;
        b=abMSH46fqWVy3ZpahzpyJfaXBvStni3dNhvfY/MdOp/d08SVku9vjLMBafLXH+KkdW
         rHPupPRdNpQ92NmWjemq3MMvRHdVQ+qKGIRPdHvhRZ3i92nqFr1nSO+NGOP/t7jya/Fu
         3g3pe3EeELH0QAypnMOB+M/n/96WXyqL5MuJ4xzIAnkxvTU39FneP9CwxplNS2sIfMJb
         GjC3w8J0vGzqS2rf6nZ6xgEfXzFDS0GwcIHz2N2vdmbPnLpaanvGInYnsL4dfrk05Cku
         4rpvqOiInp/UAir4f/TECxQTwuzwRqARKqlEgo2Wnu8BPhAfviolvlv0oYoOo2mAO+9H
         Byvg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780305495; x=1780910295; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5AwwmZzWn1LtQWZ4Hv9nlhnSuMCEUjCAg0q/ULRs1Tg=;
        b=k5HzwLkZHKQzz5TRcPBuAWgG48WRKCKmF6vkir2KPEH01pY5vV/ykZUbdIISOUm9l9
         NFnOHoWb+bebPsGKJxY8lQFMCL/FzxS4/vblJdV4rff89sWlbgLCMYO6NdhUE+peaVBq
         slSQaxTY3W9K8jLbTLsNGdQcdfyM0OF2tEBmjPuYyG2Y5yMdbpcwpaA3Hm+F/wYRhHbM
         PEOdA60uvCHeAmYqizqXS8+zQq2NEeSfkiXm4qGSGCabD8tQ6uRyLII2JCf3RjaDtdL2
         jTi7izaRyxt1JZGdcrUidMlA6ReVEpEJ4AvrD8vHMq2bNi+vGKO4egpibOpqRKwU16cS
         gsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780305495; x=1780910295;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AwwmZzWn1LtQWZ4Hv9nlhnSuMCEUjCAg0q/ULRs1Tg=;
        b=sW5EJ/GVTTUs/9AIZGBzOcc8kvEaNmd+NfaXwlUKiZPGTM5U1kLGW5zZK02+c615ty
         m5pErk1dqtaaEJyck9yiF+OWOg/+zmpqGQPthQc7gieCs9vfk2IGl71QP+In68xhW3y+
         tDVNDmHvtpRya7ljomucq7Cpe32+gBkE3cBone+oTRWzMQmQDbnQKzqyFo9bthkdSLhJ
         TRV4IgR0G11nUAWvjWhr4LAaCfwuUuMp2OQB4x+Aqv1PZ1NyACcEV23fKeXvxL/sBmhh
         vWtIaBdDveN/ROd7Lj2S4qWXpnh1NFtBf/yLEqTOlagInaEYzt/LlMU2OabYipDRlaFG
         MFWg==
X-Gm-Message-State: AOJu0YyLi0epjHSdL5G/bkW2/K8YNmAw5E03SFyFn7wmBU+nKMaQnXWa
	EoZYEB2BOI8+IrqbB5eFTppXHBix/i+6T9vTqgHGkOHGuPiMNdtam03pLar2TUTuRtWvPRWPu85
	MJdbndo2qjBBt1icGMEIsMIdHjMntpVnVcVtc
X-Gm-Gg: Acq92OGNmEyZtgDMJ5dxNoNzNn4SGPZB5i4iY9Y14htUHOwpRocjHU8iQ/6OczvGAFC
	s6L4EMgwOz3odOjunmCAcnhBtXvPvl85oWPUmS4gK3Atz6OgcZHHuSscMY2ij0gYFu9GN3ZEmy+
	a5nrf3TvBTqxFlKJGbQwWiezJexBgWvEgcn3VoYSIBuRilhItt/ElwRzePO+PXbcU/356lOz7Y7
	TVobEgAwVqA01D80VZ41IUBS8k39pXskcvE7XWyLO954nL9H0x2fRgrhkwbPBN9WEFMCyUCP6sE
	zU94XwVqf2Qkx2Ekgsjj
X-Received: by 2002:a05:690c:6e12:b0:7b4:e6dd:e9cb with SMTP id
 00721157ae682-7e05dea6ecfmr86255337b3.33.1780305495021; Mon, 01 Jun 2026
 02:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Ginger <ginger.jzllee@gmail.com>
Date: Mon, 1 Jun 2026 17:18:04 +0800
X-Gm-Features: AVHnY4K0mxtMpSWul5sZNgjS4VVcyInxinTRSz4E7IVpv2144FeK6aIQgc_FA0E
Message-ID: <CAGp+u1bveavhtNyW3eCRcDdPCy6-2e5ZyC4bhTtE83n_VW8kQw@mail.gmail.com>
Subject: [bug report] Potential atomicity bug in fs/ocfs2/stack_user.c,
 between ocfs2_control_release() and ocfs2_control_install_private()
To: ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel maintainers,

My research-based static analyzer found a potential atomicity bug
within the 'fs/ocfs2' subsystem, more specifically, in
'fs/ocfs2/stack_user.c'.

This potential issue is present as of git commit
eb3f4b7426cfd2b79d65b7d37155480b32259a11 of the mainline kernel.

Potential concurrent triggering executions:
T0:
ocfs2_control_release
     --> mutex_lock(&ocfs2_control_lock);
     --> atomic_dec_and_test(&ocfs2_control_opened)
     --> mutex_unlock(&ocfs2_control_lock);

T1:
ocfs2_control_install_private
    --> mutex_unlock(&ocfs2_control_lock);
    --> atomic_inc(&ocfs2_control_opened);

The atomic_inc to 'ocfs2_control_opened' in 'ocfs2_control_install_private'
is not protected by 'ocfs2_control_lock'.
Therefore, it might be possible for T0 to clear ocfs2's global state after
'atomic_dec_and_test' gets zeroed atomic values, while T1 blindly increments
the atomic value.

Please kindly check at your convenience. Thank you for your time and
consideration.

Best regards,
Ginger
