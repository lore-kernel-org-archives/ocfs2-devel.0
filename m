Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37261F91F6
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 02:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030919; cv=pass; b=KtdrfG/8ztyGkWGHfitRu3jTYvmbHDyuzaMXwBjU/8y6UqnmsvGj65wZbbkUTK6FgK6n9DCNlDsPFK5G0ocoMaMO9KSGD8Xb6el2K28lpQWQWVWhCFkgLu8l69BrYgO02LYHcjADCLOf1PzUIoMFOpJludgfoG4xbpRue7MtL8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030919; c=relaxed/simple;
	bh=qSdlRYB2TMcSNTloyYzjoolB7q5XaBTJAM1Srcl+1E0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fjueEub/2X19x+nU3u8lx3u45kV9wkKLzc5a4sqNzmi3W1jL8IxOA0TnqNrbovozmq/pK7lJvBfbwutWVBXfZU3FeI3f1k2+X0EgTwbUQ9xIHnmPDOOrKXnxvvGBSCsSeQSJW5UMnQVfAVEXknlrs4OmFzgk1yNs6eNS4sgD1XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6Yxm/9g; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6Yxm/9g"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b094046a7aso13856817b3.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 19:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792030917; cv=none;
        d=google.com; s=arc-20260327;
        b=LQ5/6c+2MyCw75pATET19KnRHK2teTL58QnQrNHFdWPTfAGC+DN/e/IabP9T0627cn
         dOL1rZyHpAT4rKkL/zPrjMJ/tVKitElc62sng/xns7jxqE9pXEGiaMzdjYTsLaDNvP57
         ZfGHL+rbpb5J6wcBIGZB7IFekTKXhR/mlMW76Zbt2C5KbKECbhZlLs6q6oMznRlpiPTi
         2Nc7DTXuDFagYeDDj85N8atWKlpZrP2xVG5EceYMsMAEMKxjQRklvwvjn/HVcMgGjFFv
         FwCYQkDLK/rnLnDjkDXnvq14uGgv3QEHvNcb2y+lBSnK5m8h04LcxFoG/e9185/vNxzM
         w4qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2wLqmXSLedm8Oeu0GWuAPrw8pJzuZEEe27FUMLIhsGY=;
        fh=CLreM2HVt5BEXWOXFsmOw2Drd1ZnivE4wF2IyG3Ox14=;
        b=loTcFq/H59HPhWTDJoQxV5Kygu4c2TbDAo4UhjSAL4IKIFBKxpEzEvoFlBdZVMTQyY
         sarhLeVucyymvPdKQsIX6fCLUk67V5Tdc3VWVnTDk4TRZCxX8ntStXE3c7+UwwVwhanU
         BDK6SBUeJQmOviHd4lt2YR500U4UtHCjJuzQxgAPXBsAztmgf6Q30u+reciMxPtCIqM5
         IP1IdRy3eKicOxdiqzefOK1zy1bG9ibQWlez4dhAtHIeD4IEqyKPt+XQ2eLgZIKx/mGn
         RlhBWcS02eFNxRR93210JqR5zG3Y3NAxvAKNlQ6BQltCtJVUawxdWKswxwYe3TLpT9ku
         Eegg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792030917; x=1792635717; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2wLqmXSLedm8Oeu0GWuAPrw8pJzuZEEe27FUMLIhsGY=;
        b=l6Yxm/9gLpsl7GrN9wO4M1zLIV+wI5BZBDrwbcAZE5Ey3HVlGToCM5H1iKUqEmAJuZ
         p5pboamJewpB16/IWjXUqaxij2IXz9joVYetiRup53t5oIF+g4xQTgDpv90zK3LDijX8
         D5iqN5pILUekBDpuWYRTVe/Z/iKVtO4PorDEpybpYqVp78SwaRa9/VwQqePKWx29xZpk
         hGpz4jPFlIk6TrjmTL81Xh7ZzXMpGU0w8gXG2nJ1skX2BWlnsY0Uq5lQw5lwvCvBEjjC
         qGBnA6opCBakH6hFNDBAezrahWuVK8TSGswHjRlbb1l6LTePYxm5KC3At6DAY5Gpf2Kd
         lOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792030917; x=1792635717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2wLqmXSLedm8Oeu0GWuAPrw8pJzuZEEe27FUMLIhsGY=;
        b=Dd4/d2tS/z3O7AES5OcYJqfpV9HipTE8dGLydUA6nvb5GFxTNMvcbNqPXSXSTUEKEm
         JHpoWlqpWTNAtSjyvZRx+YGMBe0zXm10jgtHC5Xe2sM2jpzhp84KRDSHvBNS0IXtNMoQ
         RHh1TT+4XgMtY3wIKlStiKUZInO70MAVuTTawegOIyTnPDGTs9HxhrkpddIq2ul+OAwx
         J0m3AY83DbPc6bFNMzoluvtuUUZSzHJjaCCzMAPu1jXS8Sagh8FkoOxlbqVQBHgRefrK
         xdrdZb/ol6ZdFSztaC2pUKNphhIsgKJWzrQYNItjvXQ9hRDQKM6PTwLJ75zBCAggJsm9
         WD/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzrlMwcHh9WBYPDmC8WDWnCrAqGFx2Rl/rm5IQCbG2Lo8/Pj80nmCTvwiBbmnqfKawdDdx8lnGzfQ9f1g==@lists.linux.dev
X-Gm-Message-State: AFq9FYKnybw2iNCxTMZM9j6XE6pWKOhVBNXefFvEp53s3G5yrPfU1q21
	OgXfXqO3H9px3WPPDPYkBtXneBVHKTZlxfOzyoVUEjqDrvpepBOlxHyYpZDct40YkHZddEH62jw
	6m4BcquG1S3ci8JvOnmUre45+pXiroCM=
X-Gm-Gg: AYBFou1T9ukQBiCpA6FroT2hkIxwjN0xwYBuZI579s8fEaKuufskpl2kE7y2Wl2S3Um
	6d3eUN2PUSKphH4aj5AuIBqaHYZZhEJ0JJibF+cwDEpzdAkyqegnE5op4s+WpBShCG3w7E1SDw1
	jaXSWZ0twSKhvSq9YkhHmGybv/A01qP+ezRCdYd4ZBXBRgGND8UF7vP7O/TL+qNt1S9TwHOOSrJ
	QxvWC6lp1nj23GEClqxSJKBNPgOseDguAFOa7bVqa7kVRPGQ+Y7aUMhTKNYP3x2zWJF1ifhGb/d
	+iHe4eUAh23SBV0YpcgW8SuH1Y9gy7S++DzjTHGR5DoGJBMAVH9RA3CgBQ==
X-Received: by 2002:a05:690c:c1e:b0:8ac:46ff:d376 with SMTP id
 00721157ae682-8b07edeaf0cmr65106327b3.28.1792030916867; Wed, 14 Oct 2026
 19:21:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0055-v4-c1574edc9949e3a22edf@gmail.com>
 <5f71eb6a-f773-4c66-a1a9-c0ab9d385f39@linux.alibaba.com>
In-Reply-To: <5f71eb6a-f773-4c66-a1a9-c0ab9d385f39@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Thu, 15 Oct 2026 10:21:46 +0800
X-Gm-Features: AclHuK9l6NrqoT1uvaDLmDHqBj1VRiL6l9Sh-FVjwKZaGZu6IWt0fcjmAjjBDpI
Message-ID: <CAFRLqsXoshOAsTfYogY_PiGOnd70=s08AwXz9UXp7mT8UgxqDg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: dlmfs: Hold l_lock through the unlock wakeup
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8815=
=E6=97=A5=E5=91=A8=E5=9B=9B 09:09=E5=86=99=E9=81=93=EF=BC=9A
>
>
> cbe0e331fdbd only swaps ocfs2_cluster_connect() ->
> ocfs2_cluster_connect_agnostic() inside user_dlm_register(), but never
> touchs user_unlock_ast(). It seems it has existed since user_unlock_ast()
> was introduced in 8df08c89c668.
>
> The code change looks good. So after the above comments addressed, feel
> free to add:
>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> > Assisted-by: LLM
> >
> > ---
> > diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> > index 617c92e7b925..60653db7b411 100644
> > --- a/fs/ocfs2/dlmfs/userdlm.c
> > +++ b/fs/ocfs2/dlmfs/userdlm.c
> > @@ -253,9 +253,9 @@ static void user_unlock_ast(struct ocfs2_dlm_lksb *=
lksb, int status)
> >
> >       lockres->l_flags &=3D ~USER_LOCK_BUSY;
> >  out_noclear:
> > -     spin_unlock(&lockres->l_lock);
> > -
> > +     /* Complete the wakeup before a BUSY waiter can free lockres. */
> >       wake_up(&lockres->l_event);
> > +     spin_unlock(&lockres->l_lock);
> >  }
> >
> >  /*
>

Hi Joseph,

Thank you for the review. I will fix that.

Best regards,
Cen Zhang
