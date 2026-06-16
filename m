Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8989239A060
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781595924; cv=pass; b=XuNPqc8OponKgP3/k7wXuFlbo1bQLUOF2SINigY8v3seIp97qrgO1yk6lUcuZSbTwHZCuYqjYnlzPoLVbLiOEGxOCOWNjIQQYgJiojCrkMSlCx9I5Kce1SO+m+uT/b1A8LE1gTj7DiWU4uqtljKHxm9gQ338hiJvX6IF33mCUFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781595924; c=relaxed/simple;
	bh=/o2igankPbB1v37OJbLF8aUrEdpEP7CODhoZ32CJ03Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CvCCB2g5SUEo6BP9geglj48OhKt1ePVFSbtGSdfwPhYLscIoF+3ToaoiRchDVJ/+uJDaOa2/vCEJWeOYKSJNmOkQH6iv449CDiDMecyR2TYgPewRgU3VfANP62ayPfZ2ZGfmrOFdffsXIvjwZMiMPDas9LrDm9ypy5pAW5k1zRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sSteocr0; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sSteocr0"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7f811da1eedso27701867b3.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 00:45:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781595922; cv=none;
        d=google.com; s=arc-20240605;
        b=Gpy9nenntcpHEBVe9VtRCaxaEfxKek0dEgQay/CNWiJD2sWtfNEpNCfTjz83xer+sr
         MOBFuwWFp7ypbfQhZlLwVkHZaYl2GOhuy5IuEqj1Nmxmw8WShcKorqwZ2ES+Z7cmcvH4
         7sflaIAOOXuNha21wjwAm6/y1+7fOlfp8OqY65Xp4Lu20a6yk04p3EjfOyD5Daezd49P
         Y8ttlCrYqsWizk4j3MIc/o2cDgNuTpRCPi0ars/hwxKOK2tv012WwfGD6tv2Qwn6Ua6m
         PcWgXdHyy38jELSM5cc4heYIazvb0i6aDh/9pB1olNU1fJGDeqUZDiFxAkN08Y9CmoQK
         bX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/o2igankPbB1v37OJbLF8aUrEdpEP7CODhoZ32CJ03Y=;
        fh=dbeC7OJm8yPBQJQIoV5fgG3+/gBGxxMWOMWuSnb9PQs=;
        b=lhtgZCzYn6dvG80XR1WtQnyvnNO3A6h7dAOZywv56Qj1HdxwqaoopyBJcVtk75TYch
         yco0LtxBMK3H18SC221CDyAWU6frjilg2nv3z8A7fq5uicfOFod6xMDl2lzZnOugWTYK
         Z+YkHgrK5shOMmj3X75PO9D26UvDKVydi9AoZMOsm+8OlzwzeFsK3Rglgxi6PbihYvT6
         DtR/KhMXfQ2FcD3c2LM9U6xyyjkY7H+aqvLKV+g42k+4YBy9Rg8KZei6L3dJ4p90cwU1
         fbcsfTHRUvQjcpv0h391Ix6aEvcLuV5+CV/98JRGI1B5599m3gqj+zPycIWOAEUX/bW0
         jC9w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781595922; x=1782200722; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/o2igankPbB1v37OJbLF8aUrEdpEP7CODhoZ32CJ03Y=;
        b=sSteocr0XNQg38ZyZ8boqSfKegmNymVHsEqemqjhobyLDEgieJ2CP8Cc46DMo6dR0G
         NfdAw2MBTfX6RFGjipIN7ssbaBNLIb5bTdd8NH9g8HlTRpe33Nd1PSSW7SpKMJL4WA4D
         0YSICNtSl8tN6aTN4LnvBnJSahdJkPGciCtNiNwWXFr1rOGF1II2c4OYhHgMt/h74Cl/
         8s2OyW0uTB3XaBh0S7PwpNZitcY1zHYD1AhpHmsrEB4J8BvY25YromzTGk6ozyczPK05
         F4gTvygPqB8JYduMbyrBsRkdT+oNyZL9KrDK69Zr0Mf9DEO4xWy9gzOogI2PvziHuDYq
         L4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781595922; x=1782200722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/o2igankPbB1v37OJbLF8aUrEdpEP7CODhoZ32CJ03Y=;
        b=ONfDlJuIVaWLek+B2bcxpDbBxAh41493LlyZbQRcQjuTeM/eRPJEjB66/LbrV2zAMW
         nlCIKmoluXbk5qoMwTe+YQLB2crySY2vA/RB3I2ikNYw7OhUTt8KXTfzLK7CFRFfZrK6
         lSvWmy0HK78N+CEyOI9Kpckmn70pfnh879vFRicuGh5AYedxRMociLFvsVZkyn3FThVg
         qoRgH1zRI15VW5Y/V0jMRGpP/PScROns8/PHpRi0e3YTLlCg0RxB427N53yaHPaUPB7/
         0xAvzuym4THZonOnDhZ3EaVJcG+Gc+i2SYZgBOFUPrIDR2d6JYhPl6XtEHfMpQbRFrrE
         Y4Xw==
X-Gm-Message-State: AOJu0YwNJwsx5EkjkmyIAJx0Lr1bqCf7d92ISUwpP0Te8DNQmd9+sGZP
	wlcSKWSghoAWy7p+87kOt6gF1M/wMCYFPDkWBkAStSdoSuLjVZvhq2HVBmZNdKieQJgFVYCSh0g
	4Eoe+YZ5+gy59GD/iY/I+SzohwpdM1eM=
X-Gm-Gg: Acq92OElZ/eZQWo03zhYZmJaLCUXsiiYSKnv8cbWfPo6DgO0kS9i0+GoSU5K1qFd/2A
	z+3jpkdRf/Q53kVGN/R5FS9YC0Xv//ffon7cuxYZnIDeSCvpksYKC95z0WKUu9ITfsq6SnegT9b
	43zIDsaMSr72R1M62gx70DraH1Pq5CV+aS5qLCOmpodAvq0FSnd4zQCub7QPMU+ew6DQZbdvRJt
	wugaHZLvVC1Q0Mra46KumTrtLEA27vcyYS6LNOdWo2lxu44vtBem86EZRJAiuTeT4XGe+3uvLtS
	T5asPUD2rw==
X-Received: by 2002:a05:690c:e351:b0:7f4:fad5:2087 with SMTP id
 00721157ae682-7fd00461af2mr23925877b3.38.1781595922438; Tue, 16 Jun 2026
 00:45:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614053345.64053-1-zzzccc427@gmail.com> <84ecad6e-4072-46e5-a2ab-3dbfe5c48476@linux.alibaba.com>
In-Reply-To: <84ecad6e-4072-46e5-a2ab-3dbfe5c48476@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Tue, 16 Jun 2026 15:45:10 +0800
X-Gm-Features: AVVi8CdYG-qO-zaqe7kNb_m3dk8AtPh4RzffqOg6YLyEN1cZtVREaW2mecTt2FQ
Message-ID: <CAFRLqsU_PdYYdKejY83CeKWoYx++6eNeFFa9SwR4o2irNJtjCA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2/cluster: reject local node clears while heartbeat runs
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

> Seems a simple fix for this issue is also clearing cluster->cl_has_local
> in the same path?

Thanks for your review.

Yes, clearing cluster->cl_has_local in that path is needed. I updated the
patch to do that.

While checking this path again, I found that clearing cl_has_local alone
does not cover the running heartbeat thread case. After local=0,
o2nm_this_node() still returns O2NM_MAX_NODES, which has the same value as
O2NM_INVALID_NODE_NUM, and the heartbeat thread can still use that value
for hr_slots[] or for the final node undepend path.

So in v2 I kept the local node number stable in the heartbeat region once
the region starts, used that stored node for heartbeat I/O and teardown,
and also cleared cl_has_local in o2nm_node_local_store() as you suggested.

I will send v2 shortly.

Best regards,
Cen Zhang
