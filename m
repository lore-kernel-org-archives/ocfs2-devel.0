Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626E1CAA65
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 01:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822241; cv=none; b=DXaXrs52WIBxaYQ2C0nZpQVZxUXCllxLLL+SvPNK1mYCFWbl7s6Tg2/Y9EzYJId99lHSMOzqiY8rbvyeQm+8N1Uu4KguhchyvgkbKuCSJR47+FaeD7Pt4V4b9hxG01Nm1fWlWvsj0KDxKP+eGZb9aJMIwX1/YwqrHL5u+6U0qSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822241; c=relaxed/simple;
	bh=P/AkJ7VMQl7xg3h+SCs73opP330uFlSO7pps2YFNAtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZrH5uoer1s2JMxq/KEyTB1VZqlu7IpYdNK2cCwSk7wXPP7/dY0cUw7zSjWURa4Y2rO2XrlVwRWfGqWpgUVlclwyuno7z+gJYcnMrS7T+U30j7pJsxYBtyDFNC0aT9GfuwcwA37wa3fAvGrtsaZ5JLl6/xZHBFVNRqPBmkP/28o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eJfAhEY5; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eJfAhEY5"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-382fa663249so22572121fa.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 17:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769822237; x=1770427037; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=eJfAhEY5COLNqiEl9kzNHyHNRdawVMW2wKc8MPxEdNYdYaDIT6eGezSFn5yiRVbLar
         aVVxsMXO7INN0QTYOBqzpDEnS/wTTl/LgtSdDF4ksaW9rQMtpJyWJnEs4eUd2gQkDy9Y
         xtPkub4d/eAXgzIZYJ+y8IAM44ezYyUjYEijw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769822237; x=1770427037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=wto9JjHeYUpV9g340+n2iyqwnme1EHhmgkVa94sF+CVwKG7yHRG4aZth4njSLzGr9n
         M/Gt0T1PoJ7tsABBTmtV/jfe4ItgS6abyOKkkXO1NI2v7URytyl/Rl52vGJwRcwz4+1n
         H7qXE1vH33if1bZVcEg0WsfV6ZDangOsg+81N+NXgvCT5PMM0le8AJzZcyMyCMOUz0CR
         IUkaDgr+bNU88YQGCqAQ/LimSgU/+pCLlVld0fMSEQC2bP97J0kHpqjPrpfLmf98ExM4
         4faiJBIhP1CZxiyGbUt9wIXGrGcJQYMJtJP9ywI/F3SPT9xBpHGcydLBCup0d2fjuW/+
         n6xw==
X-Forwarded-Encrypted: i=1; AJvYcCV+/N9a3TERRLbXTf8ypuUwS4O/WWaipWkBjDAP3DtuAn5FpWSdlOs9tfqGfQfrJFKhFcn8rIvHyD/Yuw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyvyiu7LTProgL5sB2kjkw4+DAJ1ZQ4kZraPsSvHUVL9iZiIt14
	6pzzU16rQCCsnfuQ7GFX8wP3VL7qiUQXa+L/N9ME+zpua50IzcKNq1F41/X0rqZAtMQ0XZESQ+v
	5y1ywwo9mgQ==
X-Gm-Gg: AZuq6aJwpMTpjTiPc/FIGHI6fplAjLfMjrmiREZ78+s2O/SZnbokkszm32aPKeBFl5D
	lncxXSn+VMXOwtYM2HCVb6VQiaQ/UxJ+7MkPwlVBGf4DBuO9lVzZWJom9Tn8E3dlYS+M6pM13JT
	cMB3kAfjBG+N7EsfyF0nOiPRmyuEgGd5UJCTiD0rTyz5+gRoFWNZILSdl3wdqowy8+gN7Qmodc1
	lmHcjiSXGTDsR2Jf1HZdKF+tA3hMFJcy0IE5aUc8y0GhpmLQImFswcfsAAVvMv291HTUr1HZlXj
	8taQLqAGqMpoCmvAB5vfrAUC+StVOSkMhPZJzM90Vw1+YateK254rm5UTLlEG3z19ZGwh7I7tbS
	csitnsgVKdQ4XoYFuFXVH8/schMpQedj1AjZ133m8Gav8FHcocBp9+KjyiaMeEdfk40BTVEEf9H
	9FEwMH5qvXZtJCerT7n5d+uZI1PHMTulVdkwop1BJ5peM7+NtyUb4pFwJNNg6h
X-Received: by 2002:a05:6512:3b90:b0:59d:fac0:3a11 with SMTP id 2adb3069b0e04-59e1643dd08mr1655993e87.45.1769822237408;
        Fri, 30 Jan 2026 17:17:17 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e074814d6sm2027968e87.21.2026.01.30.17.17.17
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 17:17:17 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59dd490be5fso3473737e87.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 17:17:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXO/2vm3OmgEn64gZmKAVhXKePVcmXXhr9ejjKBfyaYPQl+sI5Kop7Pb95tJkmOE/VJo1fkUkd7lB3f2A==@lists.linux.dev
X-Received: by 2002:a05:6402:35c7:b0:658:ba49:96c2 with SMTP id
 4fb4d7f45d1cf-658de54e61dmr2863591a12.6.1769821915767; Fri, 30 Jan 2026
 17:11:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
 <20260131010821.GY3183987@ZenIV>
In-Reply-To: <20260131010821.GY3183987@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 17:11:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
X-Gm-Features: AZwV_QiG_nByRrd83VYAdhaCU5_carsYUlImGLyJR9w-28CTqo3phlyWLRwFL8I
Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jan 2026 at 17:06, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I'd rather go for a spinlock there, protecting these FFS_DEACTIVATED
> transitions;

Yes, that's the much better solution.  The locking in this thing is horrendous.

But judging by Samuel's recent email, there's something else than the
open locking thing going on.

          Linus
