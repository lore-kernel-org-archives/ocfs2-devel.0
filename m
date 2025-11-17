Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CBF315D2F
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 06:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763361537; cv=none; b=ByG4vTnlMJxyJIDg4Vn3pbtOOQQZ2wf5RqU3SBY7ZIKfYvurmMpIVt64pDidseBwHUX5Dsead9RSDKUVp2pEiGQp3IbMopcXh9Dd0c8p3d8JjXW71QWKY8gD/ChYKWOtfAzVR1ibe67BL/ZcU7eQjhBwZ23RoOQs3kJGkjuK/qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763361537; c=relaxed/simple;
	bh=/plnJ57Af1pKIM6FaOO3ZiZ7OfGZhAOZRZkJVrDs2pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RDRnq3nWbvifPgEYejzfcsjFoBSpCKstcVOL6Hh9xEQsUh62OYcquobll9Dy1tIXX7o7dBIHrmtdjTAkd4S324/f4JGVdrAdoi0zNUi3ITcFE9lBpeCkZQTzJzoTo5ZCSPE3QCVr36iuHCDypbS1fBjkubScKRKcrvJ7HJSYyGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSa0DI7j; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSa0DI7j"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640daf41b19so4554097d50.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Nov 2025 22:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763361535; x=1763966335; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ue9ktquIUVe0SEeE8JdfiJGmcws+3DzHFQCXu9wGr30=;
        b=lSa0DI7jtGDSN+rMolhqLRypi9Ib8x5rbVV6IbJT+qKsopDO7BT+bSUELMV18n4lbg
         qvVajMHu2kKvS5yQcZ1dLkXOJzkBn6uY0Iw0+4ab3pZsO9ZGwRy6oxhOu/4xprBdE6Dp
         nydatJr+foHkqKRMW0p0Xn5ivFG9c0oTekdOYpWB8nTm46jU34lFxPHa9wwb260nz76k
         sWX0KcBd2YodJovQz175NRziebQYP+MJf++xci9z0lE0wAFDMI1u1Zm/3LpabfM1Fk30
         OXxiICy4mtnUZYnUq9PFZK8q4VLqFjFgPa+2jDX00v2tRPHW3TEFvqswyTiZgGf86AHK
         0Unw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763361535; x=1763966335;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ue9ktquIUVe0SEeE8JdfiJGmcws+3DzHFQCXu9wGr30=;
        b=k2qsdID9kIr06qoVg759KN16ibmNDVRTHz2W3qHGUu9mlNWxisHCwhkxb9zpecYgek
         XUBJf7kUzpMGewsuWmuXzQcCQwHLhd9VR4y5EXs1VH9rOvLY/Pr00YlxR0urAKeerrL9
         5Wp0D7PlzAPk5/ufMzpy+1PIJj1IM0tj9mU5YNvzWcuGZiA3jk03x/CntUiig10yx/Qo
         UAuFssk+esLDfLP9pPTF7K5G9X2rfEelfc91wM/mkRuDrK8zEXBas6Cq3YNJMOolQgUQ
         L74bhdcOxXs4Rgj2uCb42yOq+j4qgESUjNItMiQLByxLTD3X7J+/VbOe5U0Pese0PHYa
         IHJg==
X-Forwarded-Encrypted: i=1; AJvYcCXaTTiIKB360pNhfruJelx2VhQwkHVneIfrneDywnhTS7qCdW0OBMzgoHKxjOXR/BIJDrvND8xg5iwzoA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHi+HXs7KatRJZw0PLDdyuQw6T9EXUmlKQSkthu8pB2FyGMrXy
	mUkllFy0IR6W0aYq3RSlE8AVQK3DiDqZMvY8yJxt5gbsYhwjsfCKnICuy2F14u8eFyxe2PhUGPl
	52NvchexppthEL7mh3Ko+4l6sgsHTY3U=
X-Gm-Gg: ASbGncs1+t+3sKFpUdnSMqfl8b4PRwhnTjyg/YqXq7pIHtQVBjyKWJcU/JKWi7Ruz8I
	zPywRZC2vRQk9SKSq2oPb2GeL4gHjPnObD+gtcj0TySAlopIQSAtDCiAq+o41MnXf9gvX6Ai1FJ
	CvFJ/TFq80nGUVFxon8PPlYH1O+RNKjIx8X0H4djcPrFYPyvqhlwk4SvMcg54CVM6jNXxIfGYET
	z2SGjdW5someQvYmoinFGAPRYHxaCZH9tYBNCKWp7LXK0b5RvW04xyhp6Dl1tzlkE6f9ZltRn7U
	b5+4RkmVHLb4zIVwRirDEkgR/w1Z
X-Google-Smtp-Source: AGHT+IHlS6Dd8/VVx92KEv1NQQCM2mIpVio6y/DxJpRzrWgVptfxehL/L6+37IIKuLxl2aJZqIWJKtxwuJjY1EkYIVw=
X-Received: by 2002:a05:690e:d4c:b0:640:d597:4170 with SMTP id
 956f58d0204a3-641e6c74b51mr10102981d50.0.1763361534887; Sun, 16 Nov 2025
 22:38:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111073831.2027072-1-kartikey406@gmail.com>
 <undb2iy2lstp7oksnbtkls25ql6un4tbokgp55dfozjwxtfydp@eed726ssveyi> <CADhLXY4e0P7PH45Xgn65YkD0qoPL9a+k7xeiS3zyOku_JSTTLA@mail.gmail.com>
In-Reply-To: <CADhLXY4e0P7PH45Xgn65YkD0qoPL9a+k7xeiS3zyOku_JSTTLA@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 17 Nov 2025 12:08:43 +0530
X-Gm-Features: AWmQ_bkGSKdR1f0EJD9WuTkTUHu1yt2I1PEo78dXjApaevGsq39cStT1dn_HWxU
Message-ID: <CADhLXY4HLStZcuFuqnqw-Pre-19+kvnPjiyG7pZUrLM3B-eA8Q@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate xattr entry count in ocfs2_xattr_list_entries
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Heming,

Thank you for reviewing the patch! I've sent v2, but I used -EFSCORRUPTED
instead of -EFAULT/-ENOMEM. Here's my reasoning:

This code is detecting on-disk filesystem corruption (invalid xh_count
value from disk), not a memory error or allocation failure. Using
-EFSCORRUPTED:

1. Matches the existing error handling in ocfs2_xattr_find_entry() for
   similar xattr corruption detection
2. Provides clearer semantics (corruption vs generic fault)
3. Is specifically designed for filesystem corruption cases

I'm happy to change it to -EFAULT if you still prefer, but wanted to
explain my reasoning. What do you think?

Thanks

Deepanshu
