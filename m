Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFA93DC4B3
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 04:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790655215; cv=none; b=jptGI9+ivZ5woGWVHH2fq0UDlZxu12MJXAdnF7Wh54j8j8KGvHTc+gP5Wg/ZuLwvuU9MzA+wGGCVPOz0yZ6KJYKH28QIOhUAszr8nnaUydc+wqdAhXQxJGe47d18458eW5n48AWZEmR7rZufZMTnU6xl8Xfyfvl1I4BIuh3sTcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790655215; c=relaxed/simple;
	bh=zIvEOC+XsP3lXg3aRF4/tY6ZEjP4/7XrWVFSulwDxkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKJhSloP3q5nudZTcbNyjW+YpnRs9vw4I8GDH/MEhHmz5dWB1MVd2scCLWFo6IMLZu34+oXx4HnTBlXKV5R9dzs6zZDzWvUzaS4kXEb2RxXYntThiQjMlnR6040gZAqX1QkFvOXBT2T+7fr2uShgMjPqpjpgl19HIx+gEGTKUE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ONlxXsam; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ONlxXsam"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b55da8so394471f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 21:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790655211; x=1791260011; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=901GbOx2BRhQA8Zxfo2Ky3itLYYimn6S4GN4hXMrzZw=;
        b=ONlxXsamiBzMSZMH6foy7KQJoKl50rLwBI2Lbo2EEjsg1VdB94ijYH6V5wtHNATa1G
         58+5Y/xXNSy9tlYvZ8yJe7xWg5PgV0jNO/dfuPYrmcAJ/1pXKwgZlpn4bvBMp0Dky/t3
         zUcXhsLvJWRFGVRwU9Gr7FjlQ4XXzgR95+N5BVQgzoyACMc77VxQokk9s362iKKMAbQb
         TaW217aSujmJYWvMBg+y65EDu4DzihB7xCTSuwowecibhr+ofOKE1Ny2eWAh7Fq2/ivM
         QL4Tl/V6CdYH3p+7R8RqIb/1r2YJMSAdAHZrmjv1yOhiO96Ta1hDl21sT92jrShZR8Ey
         SFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790655211; x=1791260011;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=901GbOx2BRhQA8Zxfo2Ky3itLYYimn6S4GN4hXMrzZw=;
        b=bMM0ybKhNwPB7C/KOAitD1h5eeHQaoY++FDAQTDsns+6VAHYUUD6ABG6YLW/HaiY+v
         Ir64oeCSf7wY9z7FnpWdijcCxXJfKOEZ51m/F22Voep9T3jUrIg61nRpRaU0ZhW6/898
         EUhfQz++NeKo703/OjFPJw6DZ4pTdwDF9zAZeGM0WYwuyGJ4N/+KYQT46SrpItDhL7UF
         qAqO2rDWYAmtDiWcSKN6JB7+aeAK0NAGuNUclwD8BF/N9ku8F8AUlwQ2GP6o3dY0lrbe
         fcERpxqiWw+02Zs+Po5CzqTnnGzcvtiObJSFoGUDmRXMCrnpjcsJvsnV8/MmVnNUc2aS
         +A5A==
X-Forwarded-Encrypted: i=1; AKwUvByRdUtkPyl/QKgVzYTv+zNyY2mnfuBJsgJgU8AjeLmaXofrsS1iq2AHGcCb5mj7JWpRINEP2JSkpPgdnw==@lists.linux.dev
X-Gm-Message-State: AFuF++kx76jyI3o5+JxOiflR3LQ3N60f/FD88F2F8VgE/391gZCPa0cK
	8OxWEjIf1iGQ1HTGkiMXWau0j7L3XVa2Ym/93kbM4H8EP+rR+/cWsDOhDFzLxuxPZ5g=
X-Gm-Gg: AYBFou1gHylkafALQ+Ctyw4xuvQP1CK6C14EpDYwNCg64ERwghHiYgThP/Alh4fVKWU
	vBZtdGDkbFKcd7R5uctAuXeYz1i485YfpyxNLLELept7CfdxdtZ4qzo+PbYMgrshucdFd7Y2y4t
	UJ/W8laYhM/OgPSTKNLMmldAj6+yTVnXZo/HFpQTqDrGg1egpjCmqZZZfbNLiZvp/sRB4ALbHu7
	ies4eU+QuezI6/aC1wxocd0GbtgMklfVRpkFiWNb3A5wLjBuSbSdOBxHBIHTaEIsS9ty6P25i8P
	Tr4Y5c7GP6u/zoDcg2d/Ig5Gp4Ixl2xf5MBXS3//r2bSAxSM1hUknQ1MlQHvRev0csqqORabiK/
	/bgbtjZ4FHY70YFzaXgXbFVsAq1vEpmBxp/mM+eE9fxw++pF0adHTDsRoNH5K9Hbq4q2XCKu5KL
	kY0VnpQjPIkRlEdcTTJBvdHFmKwLQD7EIQ74HMwTFdjwJ+7gTs+KL41KZ3V50deuz7EcA3
X-Received: by 2002:a05:600d:b:b0:4a0:1a3:bf6 with SMTP id 5b1f17b1804b1-4a001a30da8mr77286095e9.0.1790655211608;
        Mon, 28 Sep 2026 21:13:31 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9140545bsm48849465ad.39.2026.09.28.21.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:13:30 -0700 (PDT)
Date: Tue, 29 Sep 2026 12:13:27 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: d.morgun@ispras.ru
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: validate la_size before ocfs2_clear_local_alloc()
Message-ID: <ars491U6UjiFdf1_@p15>
References: <20260810113508.8513-1-d.morgun@ispras.ru>
 <2927fd14-46be-4cb1-8dac-0f4249f16014@linux.alibaba.com>
 <e13b47fa02d27dbf4c44ae300fc082a6@ispras.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e13b47fa02d27dbf4c44ae300fc082a6@ispras.ru>

On Sun, Sep 27, 2026 at 02:04:05PM +0300, d.morgun@ispras.ru wrote:
> On 8/11/26 9:57 AM, Joseph Qi wrote:
> > I think we can validate localalloc inode during block read in
> > ocfs2_validate_inode_block(), which will drop the duplicate code in
> > callers.
> 
> Hi Joseph,
> 
> Thanks for the suggestion. I moved the la_size check there, and it
> does catch the current reproducer during mount. Before dropping the
> duplicate checks in ocfs2_begin_local_alloc_recovery() and
> ocfs2_load_local_alloc(), I'd like to raise two concerns:
> 
> 1. ocfs2_begin_local_alloc_recovery() reads the inode with
>    OCFS2_BH_IGNORE_CACHE, and ocfs2_read_blocks() skips validation
>    for dirty buffers. I traced through jbd2 replay: ocfs2_replay_journal()
>    calls jbd2_journal_flush() right after jbd2_journal_load(), and
>    jbd2_journal_recover() itself calls sync_blockdev(), which should
>    clear the dirty flag before ocfs2_begin_local_alloc_recovery() runs.
>    So this may not be reachable in practice, but I haven't been able
>    to confirm it directly. The current reproducer hits the
>    validator with a clean buffer during the initial mount, before
>    recovery is reached at all. Is it possible to confirm that the
>    buffer is guaranteed to be clean by that point?

In my view, OCFS2_BH_IGNORE_CACHE tells the lower layer to bypass the cache.
If the buffer is dirty on this code path, that would be a separate bug.

> 
> 2. The check is gated on OCFS2_LOCAL_ALLOC_FL, but
>    ocfs2_validate_inode_block() doesn't receive the inode's expected
>    type, so it can't verify that the on-disk flags actually match
>    what the caller expects. A corrupted local alloc inode with the
>    flag cleared would skip the check, even though
>    ocfs2_clear_local_alloc() still treats its id2 as i_lab. Is there
>    an existing way to check this correspondence? Otherwise, this
>    might call for a separate per-type validation helper that takes
>    the expected inode type, which could also help elsewhere.
> 
> My inclination is: v1 (the check directly in
> ocfs2_begin_local_alloc_recovery() and ocfs2_load_local_alloc())
> has held up in testing so far, with a small additional fix on my
> end. Both call sites operate in the LOCAL_ALLOC_SYSTEM_INODE context
> and check la_size before using id2 as i_lab, so they do not depend on
> OCFS2_LOCAL_ALLOC_FL for deciding whether to validate la_size.
> Returning this new error also made a separate, pre-existing bug in
> the recovery thread reachable, for which I have a small follow-up
> fix.
> 
> If the two concerns with ocfs2_validate_inode_block() can be
> addressed without too much churn, I agree it is the better place
> for this check, since it would cover every caller uniformly.
> Otherwise, I'd rather keep it in v1's approach.
> 
> Does this seem reasonable, or would you weigh it differently?
> 
> Thanks,
> Dmitry
> 

Hope I understand your concerns correctly.
You can reject further operations in ocfs2_begin_local_alloc_recovery() when
OCFS2_LOCAL_ALLOC_FL is not set, while keeping the la_size check in
ocfs2_validate_inode_block() guarded by OCFS2_LOCAL_ALLOC_FL.

Thanks,
Heming
