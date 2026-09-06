Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A909F357CF8
	for <ocfs2-devel@lists.linux.dev>; Sun,  6 Sep 2026 05:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788673861; cv=none; b=IhKyAgbrsZAOEzvckIrCj/5PxkU3tuc1Me1HQ/mdky8KKyLxD8jtZ0YiTAs9wqfvPpkWNh/zLLJ8d7HWohrxjzd/QE5DXQuVROO5PdMQWCBJ/45i6Mo7MeWDBcM433C7M8MPOQQGHMhxHh2yE18liDOz+NObet6PWX22SB1oWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788673861; c=relaxed/simple;
	bh=viWJnjrbhyky0K4g63DpQdEAEtLqeMnC3TLX78qmwLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl7H4Ub3Q7Wjfyp7gi/GoVYplx94l28zE8bovE0pQK0cT1V0PBbfQWV8Lu/NkqrQA0IvVV/eIdql0ZpBPz90f9oHv/sJyMCCwuorDaidW3FmKZ9C/et8+ZlzG0dm0FVgnWpltlcSId5YqX9wKN401Sg6ANdS0SrWC6AGGDDKpb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m36WGhDZ; arc=none smtp.client-ip=74.125.227.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m36WGhDZ"
Received: by mail-pj2-f7.google.com with SMTP id d9443c01a7336-2d561173f9fso14508385ad.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 05 Sep 2026 22:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788673859; x=1789278659; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFG6XNGVyqJ8z6Dlrx8ujL8nDyq9SaEpffEn7E3UykE=;
        b=m36WGhDZVzTlkuJH8eUMbJ9/lhus8ADbXOF5o6zxmFUGVmgdOtL14Ono74DCgb73Bi
         2ZwOPXN65ysJoFXLY9UwxYHN8IHWvcjngx9jEGjitere7KMpmmQfUEikqwEoaSWYdMdJ
         1qdcNcNP4aLXI9SjJ8w7DSsN+Mq3KPRzaI3ySd/tx0jbiNh1iPqwE2OEl93dTjd4YStM
         1Bau5UjSN37M0VdOUUlZaHGwG+9IoKNWaXVK821PWc/rgjaksTZ4nfE6DwQ1GKA5DgTe
         Sr85w0Fk+ZLIvn4sl7W00cEm00N0yMlLQu6+L5zc1D0+5O2/1C+4XpVNGLsBOKwWTM2L
         DjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788673859; x=1789278659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uFG6XNGVyqJ8z6Dlrx8ujL8nDyq9SaEpffEn7E3UykE=;
        b=B9G18oOnHzG3FnCACkiyQQ8cssoivV2gPbXzKnlyLG0vAoC0hBDChy3WcpDPoPdJB3
         mT01a6JJdkUUTncvKWueO6vdn9uIt8CdVUe+JxL6RfZSHym7+f9r9OuouezHkLasqYte
         tXmigUAs8sHvXAaOeulhJ2xjcxPY3a6uEN+rk0yjDuocUc4m7qcbY+4sB0r2ovqQ+SMx
         3i+PmgQSCwAOSB5H8c8KPZM+5hOxxvfYqYf1V66E9CyHzPNGKXz0fBWmhMdXlMlhNnMv
         wKNkb7U3Jnf/KNM9IO3p7/fMtfRW5ksaiLOG7IH0hgW8HJl/kPVK3WBRG1y9+YKoedFQ
         YE+g==
X-Forwarded-Encrypted: i=1; AKwUvBxDnqDSic7Sr3ooQ42RsNAxkKfokyRyAlsfHN923NFymGGfJMWzm83mkL37+GC/5yp4QXup6Dimk0hm7w==@lists.linux.dev
X-Gm-Message-State: AFuF++mBe2wb871FW/PJN32EUTkGY5U3IZdR6qhv5O4cyrQ+FJdNg2dX
	sX1CwLGm5OvL2rtHKcTwLjA0AgFu4RzNmCrBpC+kGzOiNhcDzFtETnKa
X-Gm-Gg: AYBFou1Mgvgom6kEG7AjUvhhlcxMldVv0l88yeLki+QDIp8WSLCHipbbEuGHFDsjXcW
	nuE70RZ1rNKyCCKj7C5rKSNEMeAkHyALPJ+mEWph9dtXcXZ++ocdMWd3VKoor61DTrgIRFqyMyx
	3nueymJjA8WxMiCiHfqm7wAGMc3E5Ah3sIWlUSHTAb+17DYlhON55Ei0Z79IsGslPOUkFqizw1c
	6Dr89Ax0e3/QDOre4Zm1332wFNwyH7shFiHP3rpnACfmYVOuNCSkQKXNBG1C5uHFgr1I1V1QT/g
	HOHxiYSH7p0UjrTHpeKY18NQFSqc34cFce9vT3p06GCial0GvpEQPUPJ5Z6gGgt9CJkmYRLUc8O
	vDpP6EZE55b7yI4P93xddCUcrA42JNncaQ4wHXcnXOs00SDyJju7nRpNeHg/J1aL6wqw3V0fPdp
	z0g6AQL9IkVu8Oxt6af9OR4BgEQ9mJLysnSeIoBpsMXZA7Wv+UirAh1DTsWaEbc1HOleP8tSyC
X-Received: by 2002:a05:6a20:914f:b0:3b4:7e2d:a3c2 with SMTP id adf61e73a8af0-3da3a03e965mr23968702637.18.1788673858878;
        Sat, 05 Sep 2026 22:50:58 -0700 (PDT)
Received: from localhost.localdomain ([111.199.57.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45e15604fsm2225263a12.0.2026.09.05.22.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 22:50:58 -0700 (PDT)
From: Gong Shuai <gsh517025@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: Srikanth.Aithal@amd.com,
	brauner@kernel.org,
	jack@suse.cz,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luca.weiss@fairphone.com,
	ocfs2-devel@lists.linux.dev,
	Gong Shuai <gsh517025@gmail.com>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in __bh_submit()
Date: Sun,  6 Sep 2026 13:50:32 +0800
Message-ID: <20260906055032.3005936-1-gsh517025@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
>
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
>
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---


Hi Joseph,

Thanks for the fix.

On the OrangePi RV2 single-board (SpacemiT K1, riscv64) I hit the NULL
pointer dereference while testing other patches on top of linux-next
(next-20260904).

The jbd2/mmcblk1p3-N commit thread crashed in __bh_submit() when
submitting a journal shadow buffer whose b_folio is NULL. On this
board the crash reproduced reliably, roughly 3 minutes after boot,
under normal filesystem activity on the ext4 rootfs (buildroot-based
minimal userspace).

After applying this fix, the same kernel/board combination has been
running stably for several hours with no errors.

Tested-by: Gong Shuai <gsh517025@gmail.com> # OrangePi-RV2

Best regards,
Shuai


>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
> -- 
> 2.39.3
>
