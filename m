Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD37A285CB4
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 00:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152238; cv=pass; b=VZg32yDLMMVa88F+5wfZSYmJsPnBIW9/2jyHmNDbKRlDV6CRrirANnzVoP0/BOxq+wdv9JuFi2QT4PRngs3Yol98qNsyfy0gpWxxIN+HClWzbksSLK3cj7NFYmN4kk1pEKT2iP/9OMcXTS3KCajqejFyau3Bov4dR5RZ228v+V0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152238; c=relaxed/simple;
	bh=kPPc67NtrAWleEKVne4c/j/uzzgH1YApxWrhWKlymok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C0HldioPsSsJyZXePSdJ/MQUc1OGLdUOOHq8x/kvbq79tKb0LUqLdXDvgfNl5LOSc5Pp9eyFc9/n95XTqPOuVpUoCKaLmXMAsFum6N9cgCHTlKkqMtDrFgODLT5eAVDGvP3jNH0nyWDjp471F7T96WXHHVVKIwMZQKIRRrEBL4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2N/Nsu6; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2N/Nsu6"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bd6f65c781so22395357b3.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 17:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779152237; cv=none;
        d=google.com; s=arc-20240605;
        b=Ecd7g9pe4OnNcKMxG0MzdbkcYXsu6Y9pUVc444kkIlL8E7X63DLpgfbTN6ko+oHLt9
         m8y2XQipZR3NfuYQjkQyDDLKGSqg0gHced/gAAxveo+cnCpGRKgZKDXL3sX0NgWyJQiI
         XuyZr9qZJ59A6Gd8zwRwclSQT+vOUqobbBV1TKrMuZs+krIBtuQ/hGb9TWn3AvP6l8D+
         nk1F+RctGqsKqkb7XZO4pMexqXm9DqwcOavFb917lg3WAHOa03a9nEwDQ1+edBv6pSDg
         JQu57O1Cp80jeIHstIUne3PL7dtJSgGYpWaVm9iHVlUHrq7e3d0U6Fh/Vk5oIZkG7sMb
         A1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FD1oyzH3rlFKo++Lyr0jPFwyFy9e5n7p6nOd9rFVQA8=;
        fh=16npAWBQUN2v+5qtrhB3NAE3SRagUVLcEuqAIE20FvU=;
        b=QTIYyUTzTjbnj23iGkQUEDY42QPI6QRgJ6Yt2fic8mxalXWKxKeYfEmCQHDhcDUBnR
         2iZyME9jiymCqsHhIbnR8NXZQDuZ2m2wsRiW72NDwxJqvlXrvTIocBHiXLDHR1xSFJtr
         dodhdoe6rL3VT/yNYIl+J6rPL40YGv2NLr6U4okg9n1WECj+9qTs6gUeOZRbdytmQZGz
         xj50xoCXY9l1MGQb5+mE25kYT0r7zm3D1TTe0qcbzeIdXUn0CZeT5qv4ih63VK9cE+zS
         drmgcAdnbtiEwX0nIqsuo9pOenSR9z2dwiLwWgQQINTfJvXsNUBN7nUGrYDIg9pFlL9e
         EFhQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779152237; x=1779757037; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FD1oyzH3rlFKo++Lyr0jPFwyFy9e5n7p6nOd9rFVQA8=;
        b=l2N/Nsu6Kbpie69yjbiW5QpIP+TX8WWPJnUP4qDD/Bgm3mlIkgsU3eFxHLsTM71hb3
         LbXVmrvKMxySGRSf1Wo4zujm6adtZd7WFwAvP7RVPB+BLYH22hl2IBVLGBMpQfW2YgG5
         7lfTf4usdspz/4PkzkVUwHrcopOSZJ6wD4YqV400qHHZo4uusm+qmwPoFq4G5fO+mgro
         lRf92wSoco0PN4TfX8gs0YjZvMMNDykT9ecda0IPdfiPKby5OqoWZQbK+Azpj6hE/yAo
         8wqQVsQDuV/eW7oNW7D5N3vCskBYmfmU642uJ8ruzlYddJ6xGrSHw7mE9faNMYJz8kA/
         UHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779152237; x=1779757037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FD1oyzH3rlFKo++Lyr0jPFwyFy9e5n7p6nOd9rFVQA8=;
        b=s7H/MOcSdFmQa3aIxPjnESpBxs6rTAK8jlVPVDmmukzt1WS8OkPBbiwSH11Bpk4xnu
         VO/gDGiGMn6rem2IaSu1i/97aOyTtoZ9p19TRLB1KkPrpLbGaWv5a5SwVrslUUF4nXtA
         Zb0vB60pxmz9+SfkyuBYlVhXOxkJYyylWPcIROt2Pb+dC5Qtkcte/4GOw3Ny4aXVqbXR
         8FNoFioiMnU5769ei1PkFRUbZPXu6FejnOc90+xgHtudFi4vF983ISrixvkPbacEZyKd
         JPN887oIurdm32t8Oa34vdi0EZ44a6VWuQMaIbLaDskQGpYG7bP156yGOQnOtQfvC0ok
         dq1w==
X-Forwarded-Encrypted: i=1; AFNElJ9qjTzetGbmh9lzm9jSSp3J+zrPFMk9zsxpm7gxAmOU535gfekg0BL0gR1Tu+0gphTiZLEApBYHfKFqmw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+XTQHvrqnWrjb2/ZY9D4iBp8mzJnpqsz/V/JS9u6ojJk3ON0I
	izcfe4KpqWHKbZRoYnriGvqapjE6i+SIBqvW2SUWlX2IQ57r/0FyBojR30gAuzGE+vxgPLi5p5I
	JbtnBEB1QhwTPNKHWfA/97lxHepJ7KtU=
X-Gm-Gg: Acq92OE61mh3j0TqPr/WvXN0Phwfrzl5VAWXPXpzjyGuvgPwkrt+uKppeG/kev9STjc
	4S7X4oW4dv0n3PySoz+R/m2Am2axLeVkGpRBGTa3rqvZkQK5QBY01gN9cXNQeFeM9SCrm4qNvIB
	W/Txfeh/FCCnTMGcT5y2O/eFjTT2ICkn5VwU3cWKh1pIgRWeO6wSbUZeYvqrG1XfqZ+QBmN1ls4
	n54RRwjZh0vZBZE7wW73xZ/Z0gWyFU51tCyapZQ37OuE5T9i53XQeeeWtPJII3MHqieMgwWRopn
	LEQyYey80gi2PzzhquY3DZMXiMfR7yj4M1O7YaKnBlnkVJc=
X-Received: by 2002:a05:690c:c18:b0:7bd:8952:1322 with SMTP id
 00721157ae682-7c7e88e8bb4mr180955027b3.27.1779152236685; Mon, 18 May 2026
 17:57:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260517111015.3187935-1-michael.bommarito@gmail.com> <20260518144022.4d0d0056d304d5fd9607bc10@linux-foundation.org>
In-Reply-To: <20260518144022.4d0d0056d304d5fd9607bc10@linux-foundation.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Mon, 18 May 2026 20:57:05 -0400
X-Gm-Features: AVHnY4Il8MSATFfQxeNIeO15MzMVRMDd8IMYQN5K7rcLoK7Kim8Dvf--x0za2Xw
Message-ID: <CAJJ9bXwOQ+7sf5Js7nZwRtn7=8+GXv6bjqk0X-+27L1XAX6DMQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ocfs2: harden inode validators against forged metadata
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 5:40=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> Thanks.  Sashiko review might have found a few issues:
>         https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.b=
ommarito@gmail.com

Yes, I think patches 1 and 3 need a v2.  Sashiko found a sibling issue
in patch 3, which is the most important part.

I'll send revisions later tonight.

Thanks,
Mike
