Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8B1D416C
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Sep 2026 02:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834756; cv=pass; b=IMjspXnc9k45wVAHrKumBAdwQPlPR6JgrmrG1at+0ZiKSlfLjE3TOibdKHCcvpwJsynYdLnkYCXE1VylS03f3Pk5Th9WZNWDwv1lHwwiT7EsmRkOs5cJoeyW/SMv+a+MBNSQS8ieMZJpx77oSn7UxCdzIvkLaaIyg0BYTj5ehUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834756; c=relaxed/simple;
	bh=IhkE7Kgsea6Jppo7O0QUJgWybWjjjQxA9sEPbHI1Ymw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I+EnD+NFNzaTWO8VUoHl/oyC5hBV6aRFSBo+ZBV93JhunrCvpUjBCR/SF6RogvMwQ8lENp0UHioos2VfF5kT3/z3Uz91L6P6gqpqk0hdIUoq/jgiOP2z7hWpkawKevaakG3QoqHKLBzhCl+maYTjW9jCMbxvkxzulklvdDqJnbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=mJcQE+vW; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="mJcQE+vW"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d560775ca2so27492835ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Sep 2026 19:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788834753; cv=none;
        d=google.com; s=arc-20260327;
        b=et9OzX/pTUFueojQfROOrAkwI2TairHIsTHRHuiucGv9ROsROMOs1hImu3p80bXXrv
         WhBRku35ONCnqbuCsyaQvv2Ps2PmE3d/ngLswEW2PIj0S6SYQswSePLPjc7lSwu69fl2
         4PKYtKHwfpJeCLHFjvNh3rRlDDe9AcGDbN8nqlmoHJ7RnXZumKHfVDa/BlP9zTcPIyXH
         2RZ6fFW6ERnKN5VhI8T7NIr5XoDicFmvYVbL63V2TPVPAK+pw0RrvM7fKSxbgfwabPQT
         rTxxHsvzIHW6iMhSzCiUM10pxUc/sq9bI2GA7U2Xn1havN91cR5Sp1q1fLp5K4KJDVfH
         GzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        fh=PSMkXRXV4V+v5j5XNsgbPE6yuPQ9TRrgZPgQUi7tI1c=;
        b=c/LvPUtCyxeADlK8T1X7WuMEPgjpEMDizNnDIIY+7BsiOUd5hMWuFBldCZ59cS+LkC
         9LyGlsNTk13u63g4y6FgiNdPQwaXU7C2AIpeIXH7L3qAUVgXxNtjbEOJ3+w3y4rH28hS
         +Diu9Vj0YDLOYCXJpFkt5ma68dMHjyOTiAJeu0AAjrEmTxtAb4s9D6/IkGEbTfexHqA8
         SY1ZzOQ2xxQ9mwMMPeWh4o872pAM+ezhpZNed6ayQH28JwH0UtG68y2tiB4n9jsMUD8a
         G7DDwX0v3j4ebK6ShfkF4FXMhwcbmFoz7Iip/cV6PsMQA0mMJGswAZWcHz+Vbm/g3MLG
         1BQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788834753; x=1789439553; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        b=mJcQE+vW3cOgVN6cNVish4C0SfR1rpCh9nDdD3iyfGIbSSliWQuBhTvG+620901qMS
         KuldEYNvloi8PKLs5p46IJ5U0P7fFkB4a3r3OmoaXT0rxgjMuPuoTvmpchVOb2CGKbqv
         QrGTp79A6SLwxi8tKFRWKeekK5YJCQV3hIIzFIscxeHi+aNn1O+KKt5ZSa/8SXJXCIvB
         FFsu4CKpOAAViTTcMM22QsOcQEgVWoQhbnzK0RfmR0gI/aLaOH2SPC7CNjibVkx8POQ6
         CvjZP8bTYy/QL6IKspkkd/uf5LqObsWf0wf3HsHXuBV/pSTtJnSJ7zwjUqUEgfqiFfne
         qAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788834753; x=1789439553;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        b=AJjgt7UolK/FVdX3uyfaNl7IkVQaw4bi7U6kOyCHaglEi9qpe2t3u7GU61+5zQn8Z/
         kC1He+hB81m2y0ImvceNGDBqyT/i4lx/PhgVH3mw5HP5ipsAHsR+0Rva4QRh01WQ/PYS
         /0tDpy8giVYabdRdc2jDUkWBWjpdAFbRT+djRmhMjgrKaBC1H0oQ/Xy235Pns0YueX7I
         UUEAAUSx2JZ1MTJ6QyBtBSew13L4wv73I6PGBiy+QRQz8dfHpja5bSWaeyfl7TQzUbnF
         /J9E8f2WC2GG6OUJBvm+ljwGUAYfaMeQhEYLHSWBE4Ey7yZFQM5KTLZqmyB8uJbV/Xpr
         F4Ww==
X-Forwarded-Encrypted: i=1; AKwUvBwMMEMquUAxxu1Q5QEJNMCsmyhgMvuGTeDiwfukIpK1+myiMFSoUcHUAHMTrkJ/rRtJE3HTCzKxzNVv1w==@lists.linux.dev
X-Gm-Message-State: AFuF++mYxo9zgffYZA8xauGkpcOoBJXy7aXMrWQltd7nToJphWpkK9WE
	4t0PTf7UeWRLqxW31mXyoG4z5yPUnXCKhk5HIHaWWTisHY+QjS2MVlxFwSt/IZDQPwl006lj/V+
	B9n3rpsnt/UzLr2YUtLHuFH9bTrB33TVLJtUmYreV
X-Gm-Gg: AYBFou1VlTfKs90XrJFBkhKMl4qQ1cCa+jiNsSerGQQ+CvSgAN5iLwBwgGCH5DZNtTF
	CFuxfFpN3PbaQpUqznlOvQrzjWkGhFCJGZOEHI2Xob+9Q6qlLffH9JmHlvQJWd+nAHurS7N8COG
	ps4SbqIkBrBBtun1SYGGwSjuOCRtD0F35Hvexx/kZZsat/qcUxQ950ryYObz+jkj+K1wSz2sPBI
	fICZ3z263rnOwRL7Eo8hroQcoF44bXEQT/opMWtbZq6iJi4B1t4z3cmtfM3gL4cKpChAwDmg+f/
	lk09UKeA+FVGnX4d4lAwVAtBZ0f9BdbP92MTrhcZQJZtJlu4fwiL+RaHJVbe/ihsm35AzolVzsT
	2USZLDemjnUVQXPH+BbMpVkXVNEantOo=
X-Received: by 2002:a17:903:3c24:b0:2db:479a:5127 with SMTP id
 d9443c01a7336-2db479a55c8mr167277835ad.19.1788834751616; Mon, 07 Sep 2026
 19:32:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260903090053.13120-1-jack@suse.cz> <20260903090508.1360863-4-jack@suse.cz>
 <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
In-Reply-To: <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Mon, 7 Sep 2026 19:32:20 -0700
X-Gm-Features: AcwNN1WQDihV66cQ-OHH0AQpq0YHKUYC6t3qZ2Ny2_gI23ZREwXcpRRBLjG5-dg
Message-ID: <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another filesystem
To: Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: multipart/mixed; boundary="000000000000ef6e9d065aef8b9a"

--000000000000ef6e9d065aef8b9a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies for the delay in response. Upon our run, the patched kernel
(this patch on 28924df2a08f) no longer panics on the attached
reproducer.

Thanks!


On Thu, Sep 3, 2026 at 8:15=E2=80=AFAM Hugh Dickins <hughd@google.com> wrot=
e:
>
> On Thu, 3 Sep 2026, Jan Kara wrote:
>
> > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > requesting to enable quota using tmpfs quota format. With suitable
> > passed arguments this can actually succeed in enabling tmpfs quota
> > format on top of ext4 filesystem which leads to crashes later in
> > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > filesystems only, verify we are indeed enabling quotas there.
> >
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
>
> Acked-by: Hugh Dickins <hughd@google.com>
>
> Thanks: yes, please do route it through your tree.
>
> > ---
> >  mm/shmem_quota.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > index d0b92d6da50f..a3fa4bd93e75 100644
> > --- a/mm/shmem_quota.c
> > +++ b/mm/shmem_quota.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/rbtree.h>
> >  #include <linux/shmem_fs.h>
> > +#include <linux/magic.h>
> >
> >  #include <linux/quotaops.h>
> >  #include <linux/quota.h>
> > @@ -54,6 +55,10 @@ struct quota_id {
> >
> >  static int shmem_check_quota_file(struct super_block *sb, int type)
> >  {
> > +     /* Verify enabling happens on tmpfs superblock */
> > +     if (sb->s_magic !=3D TMPFS_MAGIC)
> > +             return 0;
> > +
> >       /* There is no real quota file, nothing to do */
> >       return 1;
> >  }
> > --
> > 2.51.0

--000000000000ef6e9d065aef8b9a
Content-Type: text/x-c-code; charset="US-ASCII"; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mts1yf5c0>
X-Attachment-Id: f_mts1yf5c0

LyoKICogUmVwcm9kdWNlciBmb3IgMTAzLXF1b3RhLW51bGwtZnVuYy1wdHItZHF1b3RfYWNxdWly
ZQogKi8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0
ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVk
ZSA8c3lzL21vdW50Lmg+CiNpbmNsdWRlIDxzeXMvcXVvdGEuaD4KI2luY2x1ZGUgPHN5cy9zdGF0
Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGxpbnV4L2xvb3AuaD4KCiNkZWZpbmUg
UUZNVF9TSE1FTSA1CgppbnQgbWFpbih2b2lkKQp7CgljaGFyIGRldlszMl07CglpbnQgZmQsIGxm
ZCwgbjsKCglmZCA9IG9wZW4oIi90bXAvaSIsIE9fUkRXUiB8IE9fQ1JFQVQgfCBPX1RSVU5DLCAw
NjAwKTsKCWZ0cnVuY2F0ZShmZCwgNjQgPDwgMjApOwoJY2xvc2UoZmQpOwoJc3lzdGVtKCJta2Zz
LmV4dDQgLXFGIC1PIF5xdW90YSAvdG1wL2kiKTsKCglmZCA9IG9wZW4oIi9kZXYvbG9vcC1jb250
cm9sIiwgT19SRFdSKTsKCW4gPSBpb2N0bChmZCwgTE9PUF9DVExfR0VUX0ZSRUUpOwoJY2xvc2Uo
ZmQpOwoJc3ByaW50ZihkZXYsICIvZGV2L2xvb3AlZCIsIG4pOwoJbGZkID0gb3BlbihkZXYsIE9f
UkRXUik7CglmZCA9IG9wZW4oIi90bXAvaSIsIE9fUkRXUik7Cglpb2N0bChsZmQsIExPT1BfU0VU
X0ZELCBmZCk7CgljbG9zZShsZmQpOwkJLyogZXh0NCBtb3VudHMgdGhlIGJsb2NrZGV2IGV4Y2x1
c2l2ZWx5ICovCgljbG9zZShmZCk7CgoJbWtkaXIoIi9tbnQvcSIsIDA3NTUpOwoJbW91bnQoZGV2
LCAiL21udC9xIiwgImV4dDQiLCAwLCAidXNycXVvdGEiKTsKCgkvKiB0aGUgcXVvdGEgZmlsZTog
c2htZW1fY2hlY2tfcXVvdGFfZmlsZSgpIHdhdmVzIGFueSBmaWxlIHRocm91Z2ggKi8KCWNsb3Nl
KG9wZW4oIi9tbnQvcS9hcXVvdGEudXNlciIsIE9fUkRXUiB8IE9fQ1JFQVQsIDA2MDApKTsKCS8q
IGEgdmljdGltIGlub2RlIGhlbGQgb3BlbiBmb3Igd3JpdGU6IGFkZF9kcXVvdF9yZWYoKSBvbmx5
IHZpc2l0cwoJICogaW5vZGVzIHdpdGggYSBub24temVybyBpX3dyaXRlY291bnQgKi8KCW9wZW4o
Ii9tbnQvcS92aWN0aW0iLCBPX1JEV1IgfCBPX0NSRUFULCAwNjAwKTsKCglxdW90YWN0bChRQ01E
KFFfUVVPVEFPTiwgVVNSUVVPVEEpLCBkZXYsIFFGTVRfU0hNRU0sCgkJIChjYWRkcl90KSIvbW50
L3EvYXF1b3RhLnVzZXIiKTsKCXJldHVybiAwOwp9Cg==
--000000000000ef6e9d065aef8b9a--
