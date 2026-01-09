Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32B220F2C
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Jan 2026 02:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767924162; cv=none; b=fySYBFL/XvlI5TjMO0fYKEnuZbTDgdHhrjmmFpUF5X/mGBPjsoLH9omOLUaRcn7L43hlN0fbHZQvg6XR8KfDZQ7LJ5wLt3QPbVp/gqkGpyARV8rk9ABbSQnriDo1O6yJTtrdIMA9p574Jq3md2piu3mSOaPy8/1+OLbVmOTQfjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767924162; c=relaxed/simple;
	bh=F6WbtV5aGEif4ztPN8+qvNxvIh6Y0/dzbky+ItYgSkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5UgViPgs3p6EUYZsc0bHgk6eICLqm84e+ayBpXzB6TWQPc0zWZxRNbzWy9GDi2bBBlctHYst65/qXNG7SGfu/P1s/uJVwlRhrsBCwZ6u6pTQI2nazEpLgv365F0FZM+ytxcV+OD87HawkHkWlSt5jRBO3S5F1KB+NPxIMII0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsPlT0oL; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsPlT0oL"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b72b495aa81so737744566b.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Jan 2026 18:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767924159; x=1768528959; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5y8b5E8TnCNW42yhK8a4MYdBZcdGkXQ5zHXVk/PwTq0=;
        b=dsPlT0oLgK1OrUrHLNEYI4Qz4XM+vY87TSlDSFvBS26Xirp6C/Cv71aEumRLbjwtz5
         3s66Z1McQtRqiWirqWQCv0kFQ/cUVIjnPpvlbMxgCqh9ymhHnKJ6Sbau2FMHuCsYhF+n
         eA+HFwiQgTXdKNUoeFu0f/A0v+pGp5X7F1hcvANWyL0RAtGW+ziEUa3PwgEwT/kDWijZ
         /PQmTPUvdKHozaNzY6l0ZBqv7u0DXnwzXENXgSasZ5gaSJ2qualFl0W6hiUbuq4VC2Q7
         t0T8AZhotQ6yPjL1LDBZnyZS6BuRz8K0DvLk1LtJmezY1IdYdsEcjJGuzdhY70iI6Zik
         ejgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767924159; x=1768528959;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5y8b5E8TnCNW42yhK8a4MYdBZcdGkXQ5zHXVk/PwTq0=;
        b=uJzwPJSJCilqgnlOJUGR4cn5DhSCYAul4sorKsbpMBu2AS0kM4pSnsD9k1I4adVsmF
         6bRcP+IUaaBWzjgOEXY0ADqj+at0twCNro676Ub+wAIwNt8StLBACjf/9+y/asUMMBJS
         5tLd42O3ceSCKW74htZRQuDUeZHJQT8ut9JyMNJhnEDl7p/zVY9v48IAJqeEr4+n6cOF
         VU7ycGmkFEKneo3CwY30pAhvnQQt2Ei6mhAPIYyPq53du8XV9fUZqkASa2ZNR8dkLPQl
         iAVX2eBG7zudYftcZb+ABl4Xu0+29hFEV/0oaZbZ/Sz6MLpKJtKsl2FKNv1ukZ6Nou8Z
         PdQg==
X-Gm-Message-State: AOJu0YxdO+Sni99VOQsq3BBCetJuXgEiYyMEY6y8EuNqomLaP3JZXry+
	zz6lsX8Wj2y0KxVJcsiauP4keBsWgatokZ1pBWeOXYw5TwFbvNgYeUN7z3w68ObwMGf5JgF4+35
	h0yM2jughmZoFg7+x87HqN2NTjCprNpU=
X-Gm-Gg: AY/fxX5Wj5VF6rqIBMyYbD/aabo4B6iuFk/xNUFtpR9W5/2C7kOstGWOjUr8Dt3spom
	vxLn9jGZYNw3yagNkGAEuweBktNSbe56fG2N1lRl9vysblPzrIshKKDbqrZolZ805mXza3qAAIP
	1cJ0TSrIAo8UOBo+abK6fV1zOdkVyPTqrceQYgG20byrJEcN9scqmSZAa0MHwaCvcIhTPxs2nOo
	0WzKqg/5SX4mGK1/N+qFyVWIrH8qz5rliMm4/tCxBVp4zhgNmA+LBn0xm9HTErEO7YTLsFbqw==
X-Google-Smtp-Source: AGHT+IEkuF7UtNSH9GDnGwaII7yVujOEsUOS7pScE4+tJ+X88qXtnpiqILmp74VYchpgRs3Y1yNPrdD1yLAR1z5k8hg=
X-Received: by 2002:a17:907:3f1a:b0:b7d:1a23:81a0 with SMTP id
 a640c23a62f3a-b8445460664mr749842766b.63.1767924158663; Thu, 08 Jan 2026
 18:02:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
 <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com> <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
 <25d90176-743e-4638-9643-861bd5792eed@linux.alibaba.com>
In-Reply-To: <25d90176-743e-4638-9643-861bd5792eed@linux.alibaba.com>
From: Szymon Wilczek <swilczek.lx@gmail.com>
Date: Fri, 9 Jan 2026 03:02:27 +0100
X-Gm-Features: AQt7F2oNsVlTsqiUGa5waS7RS1x6ZGrhmYagEYb6CMXotxym8-aJT6uNeMbUMoI
Message-ID: <CAJRoVwgxBKXcMSU-CMH8gC1TLnWFdMHiaFGOyFrkDZqzfpN8Ng@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thank you for pointing to the designed order in quota_global.c.

I looked at the locking documentation. I see that
"Acquire dquot for the first time" specifies:
  ocfs2_lock_global_qf -> start_trans

However, I believe the v2 patch is still necessary because lockdep
detected a real circular dependency:

sb_internal -> sysfile_lock_key -> ip_alloc_sem

Since ocfs2_lock_global_qf takes ip_alloc_sem, and start_trans takes
sb_internal (via sb_start_intwrite), the documented order inverts the
chain above, creating an ABBA deadlock with freeze/dismount paths.

The designed order may have been correct before sb_start_intwrite
became part of ocfs2_start_trans, but now this sequence conflicts
with the VFS freeze mechanism.

My patch ensures sb_internal is acquired before ip_alloc_sem, which
matches the expected freeze ordering. Perhaps the documentation in
quota_global.c should be updated to reflect this change?

If you see a problem with this approach, I'm happy to adjust.
What would you suggest?

Thanks,
Szymon
