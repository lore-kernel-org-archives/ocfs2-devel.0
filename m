Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA3188A0E
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 08:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731657732; cv=none; b=Vh0Ez8+8cwcBuhcaG/cKLokLA/6fbnpuLf0TOnGdOLJvVpYTU3RYT02XqbCF0JYmepJtsLP02CKGvsFf1f0n1+R00LWWWxb6niji9WV9a3KQXTbol31yb4UGpyYTHkdhjRlcFgcDwPIRj3/e5hQR3BCcCJfL0iWl1XJqMIR/Cvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731657732; c=relaxed/simple;
	bh=IyO0F26tiWDwAJKdtJ5ldmOb1hy7SlrpIN1PLz8k/0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iB0eea4bNBwp5+E8SJ+u9TZG2YnmZ2aiMo/jiJMf4hy4X1XkG+r27CtQZuJTXNEx5k5TpfwEFsTD0Jfgqv15XpohhO36iG5DUHllxAUwvHJ5YahvIwI7dFeyg1n2SlxI+8/pc9G0gYsvAFrDeNOXfK6TzpJOqSdv7jx70X5hqI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TtPNM4Aj; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TtPNM4Aj"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e380e038749so1425363276.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 00:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731657729; x=1732262529; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSb2nT1bOZ8cqLIJo5pDYayW9eVckwb9N3dVvgH6GX4=;
        b=TtPNM4Ajg4SBjn45u7VLEVqHd4ORIOMtDyrmNrbPq+NCZuZ8NdyY+e1DKmQ6MIP5kG
         JAmaR1wC4iiJQGs+38V08bG1Fw/1/CuVVzcv8lZe7w2KzLNNX+JakIlm2WNCrSwKT8l6
         gkkU+foYGFgK8/pKf0a/56mwxsdzMXE07I5zJlhD5QKczALoMYGUdbS0WNMEGproZz5p
         2idET+tYxNorzw2WxU15JOutlnwx2pvBEknLMymAM1Lif3KMpEnOzNlyynMVTZx+lI7q
         rR0HDL6Ab6kIXS1VkXneQAWMgwdUBVY7o+cJQChuJVwTnvcuhqqHv47qmBe0LeZffQsk
         6IkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731657729; x=1732262529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSb2nT1bOZ8cqLIJo5pDYayW9eVckwb9N3dVvgH6GX4=;
        b=Af0wM776m3IlRxHqirxbB8+yTTVSjnkykIlxS/+s6YAKurArTjbke/fyxb4cvleTj2
         PRkRhoVNPwa/Mxa9d8f/AXKJlHJwlR1ejNHB0BgJ3Bd1BLOFCojqwrZ1Ntw7fniX3emp
         iGgxH99SxdxyHV1enas1giBhbg/E0ylziWo3UTkmLLtlrLuA2QMPKdN2H0faP977UJPw
         1rhH0te9m8Q/15fxoMhg25ybYFZ/RwRXu0LYLEjXAxu2H+Ry0ZrU1USZnfKiSf6hNx29
         1dSqja+PQX5C9zUdbajeO395tQGCYuWiAbStjzx16xCUjuagH+9AF/Ja22OCCkTVqKYC
         tHOA==
X-Forwarded-Encrypted: i=1; AJvYcCU7LEAZKDAadnYLtJb22Nmg6DHyCulD99lGl8BkohsIbDKzfdTxefAW3TMcst57PH2iE1sMlqF6Nn1IXw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf5hYuMkeZNRe7E4m9yS8Lnv8XM5JYwPn/rspojsoPxH9yPY8I
	zaRc9x63y1iTcbYF8HJsrGlzrBBHnJfOPc93F6SdVisCDof8OFh7XcGnnmQLP3mGStcO7hPdQNg
	DKB9UGBC3mlGCHM4DkrgYO/GAJPE=
X-Google-Smtp-Source: AGHT+IFQkVHPcnysrgsGIfAqUB9AY9NECNlY+Q+Met+trlCRNulDRu+0LDIvxWmIMIG3zHowXj5aM0s4+4NmCTmFoVE=
X-Received: by 2002:a05:690c:b10:b0:6e3:26dd:1bf5 with SMTP id
 00721157ae682-6ee55b7ac61mr20989327b3.20.1731657729403; Fri, 15 Nov 2024
 00:02:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241113080913.182499-1-danielyangkang@gmail.com> <35b0534a-0ccd-4b92-b493-33434a81845e@linux.alibaba.com>
In-Reply-To: <35b0534a-0ccd-4b92-b493-33434a81845e@linux.alibaba.com>
From: Daniel Yang <danielyangkang@gmail.com>
Date: Fri, 15 Nov 2024 00:01:33 -0800
Message-ID: <CAGiJo8QV_Y6JO8xdYp6AEhavHp+_VvLJ02gU=fwUC5b_5NhcbA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: replace deprecated simple_strtol with kstrtol
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	"open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 5:05=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 11/13/24 4:09 PM, Daniel Yang wrote:
> > The function simple_strtol ignores overflows and has an awkward
> > interface for error checking. Replace with the recommended kstrtol
> > function leads to clearer error checking and safer conversions.
> >
> > Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> > ---
> >  fs/ocfs2/cluster/heartbeat.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.=
c
> > index 4b9f45d70..dff18efbc 100644
> > --- a/fs/ocfs2/cluster/heartbeat.c
> > +++ b/fs/ocfs2/cluster/heartbeat.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
> >   */
> >
> > +#include "linux/kstrtox.h"
> >  #include <linux/kernel.h>
> >  #include <linux/sched.h>
> >  #include <linux/jiffies.h>
> > @@ -1777,8 +1778,9 @@ static ssize_t o2hb_region_dev_store(struct confi=
g_item *item,
> >       if (o2nm_this_node() =3D=3D O2NM_MAX_NODES)
> >               goto out;
> >
> > -     fd =3D simple_strtol(p, &p, 0);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int p_to_long_ret =3D kstrtol(p, 0, &fd);
> > +
>
> Please define at the beginning.
> Seems we can just re-use 'ret'.
> BTW, the blank line can be eleminated.
>
> Thanks,
> Joseph
>
> > +     if (p_to_long_ret < 0)
> >               goto out;
> >
> >       if (fd < 0 || fd >=3D INT_MAX)
>

Ok. Made the changes and sent PATCH v2. Lmk if there's anything else
that needs to be changed.

- Daniel
