Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C4F288DA
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 07:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731657267; cv=none; b=PD6Pk22Qze+jzW/hjJ/7rYYZoHBuAqUOapxaFYVFmi/Jm7S037a87qDuCrEIao0Q98OSqpea9mL7LhrXQKO4TTCnBQssCPkwHgpTNg4X0FatbUIVD1HxKROOR9XcqFXifERJTISKUIz7eUilCPFPNSfCGow5kj4Vdd5sdOku8z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731657267; c=relaxed/simple;
	bh=gkq22GqUHbo4+rCf93eCZNaCT0EMkFnHj/INJLroDEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glnKAqD9W6oew1hXFw1jOBgYbpy9+hCXqmZZO+kR7xFsEnd04js/diy2LMfyNMabkENJZxEtZd/KS6enkzON1uO31DwWm1XlX6wrBNRozd0R6kQNhrhOo1HcPb4l/JZFRS8kcD7T35gJmvD38hCvt8rVZavBXtev1K0mDJXJkPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nd2NDW2f; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nd2NDW2f"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6e34339d41bso13900947b3.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 14 Nov 2024 23:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731657265; x=1732262065; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+niKqtPLFz4jhdE5k6gK8qLmYC/LgUzZi8oO4+OoWes=;
        b=Nd2NDW2fW+5qotap7HXStwmE273Q7ljiu8G6qft8x7GVD/zq8faOHbqLxYlvDuDPt0
         xguOQ75TkDGOynu+K4LrQJOOjQLHZO80DEZ2GTTkKdd9RAbZJlgktP/eVB3apeUAFz2g
         bwDIgeYUuIjlgfOwz0oh9U9nCVtCQ8CIblmLDWRWd1KpAMecYgOpmdUV1mXM63KjznyO
         /lZFVmaI+U9VevLfEMTCeP/Osi/78ibO3XOqMLq5ihEjzUkuWZv91rg5vtwG7khIgpSv
         o8mC4STbzs+7llAbALi+ZhMMS9PDfKKQIRSnJuHlqJNr8uyI1j0ew+VF3uXSCg8XiECH
         ykxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731657265; x=1732262065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+niKqtPLFz4jhdE5k6gK8qLmYC/LgUzZi8oO4+OoWes=;
        b=kLzxxNqRDkHCQwkzdSOpuNFc0812tlsBdEpDPfZ/9zP7RuUKTQEv3IOxkD4Atk3SXy
         sSEN2sIUKufRd/ROIFgYe6FXlB25rHZgThMOeIbxxHKmuMQsYWMAXgqDtJYA0bkETljP
         23dwbrwccRAAgcsZ4kAvL88Hq3IaL2HwdVyAkD+/B35sSk4ijnkEHyu8v1AZR51mywVE
         sACyL5aLnJbgW6Dln2lW3pWRcBVd6F0VyOYrjDKuLC7cXt/5z0SV6OmH/hte6Mj8MFVF
         Y5dbigANOQi+Ho4kxlEmK1GvnWYCG9hQ+85WLByQTDmk90x5QFy/LBpJ/czbn7GL1kPK
         BIxw==
X-Forwarded-Encrypted: i=1; AJvYcCX2Qgf9mrLBeJG0C5Du/S878ShKe2R2ldlXYS91I25sx/Ck3/HOvSFt/k3FmuumuLAjZlWFTRWUQB3ARg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyRbIzx4VtpbTjRkfWUNOI4D/EyCAyT6wcpZmHExlao1d56MmHE
	znCePiMBOTaYFsBj6FLDBWLBxNmRQ04ybDJf1KBB3m+oA6N6y7gVBsuokulVF+/x4Q58j/LQBeX
	382526Zjzd2VnEKEuuz09pjsNrZQj0ufmO8I=
X-Google-Smtp-Source: AGHT+IHYtsfenrdOoFGYEsxgKLqTPpPEKf4qOZSPWpIhwRzvpf1cjUW0a9+VRw3exOVz7yJGrVac9C2fZu0WtuRK4VY=
X-Received: by 2002:a05:690c:46c4:b0:6ea:95f5:25fb with SMTP id
 00721157ae682-6ee55bba137mr25813507b3.3.1731657264980; Thu, 14 Nov 2024
 23:54:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241113084108.186506-1-danielyangkang@gmail.com> <50564a28-9c75-497f-a50c-22e08b1f794f@linux.alibaba.com>
In-Reply-To: <50564a28-9c75-497f-a50c-22e08b1f794f@linux.alibaba.com>
From: Daniel Yang <danielyangkang@gmail.com>
Date: Thu, 14 Nov 2024 23:53:49 -0800
Message-ID: <CAGiJo8RBBs-4ATOP-sJkE-TWiGxbXHaKQP+_qsGKTmWhuUwrBA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	"open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 5:01=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 11/13/24 4:41 PM, Daniel Yang wrote:
> > The function simple_strtoul is deprecated due to ignoring overflows and
> > also requires clunkier error checking. Replacing with kstrtoul() leads
> > to safer code and cleaner error checking.
> >
> > Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> > ---
> >  fs/ocfs2/cluster/heartbeat.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.=
c
> > index dff18efbc..4fc1b23f1 100644
> > --- a/fs/ocfs2/cluster/heartbeat.c
> > +++ b/fs/ocfs2/cluster/heartbeat.c
> > @@ -1537,8 +1537,9 @@ static int o2hb_read_block_input(struct o2hb_regi=
on *reg,
> >       unsigned long bytes;
> >       char *p =3D (char *)page;
>
> Please define 'ret' here to make code style consistent.
> >
> > -     bytes =3D simple_strtoul(p, &p, 0);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int ret =3D kstrtoul(p, 0, &bytes);
> > +
>
> The above blane line can be eleminated.
>
> > +     if (ret)
> >               return -EINVAL;
> >
> >       /* Heartbeat and fs min / max block sizes are the same. */
> > @@ -1627,8 +1628,9 @@ static ssize_t o2hb_region_blocks_store(struct co=
nfig_item *item,
> >       if (reg->hr_bdev_file)
> >               return -EINVAL;
> >
> > -     tmp =3D simple_strtoul(p, &p, 0);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int ret =3D kstrtoul(p, 0, &tmp);
> > +
>
> Ditto.
>
> > +     if (ret)
> >               return -EINVAL;
> >
> >       if (tmp > O2NM_MAX_NODES || tmp =3D=3D 0)
> > @@ -2142,8 +2144,9 @@ static ssize_t o2hb_heartbeat_group_dead_threshol=
d_store(struct config_item *ite
> >       unsigned long tmp;
> >       char *p =3D (char *)page;
> >
> > -     tmp =3D simple_strtoul(p, &p, 10);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int ret =3D kstrtoul(p, 10, &tmp);
> > +
>
> Ditto.
>
> Thanks,
> Joseph
> > +     if (ret)
> >                  return -EINVAL;
> >
> >       /* this will validate ranges for us. */
>

Ok sounds good. I moved ret to the beginning of each function and
removed the empty line after each ret =3D kstrtoul() statement. I just
sent a v2 of this patch. Let me know if there's any other issues.

- Daniel
