Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753734;
	b=T+0RPkJ/0GHKjS0ESbPbFEuR6dSh87hXlNPrAeWz2WM0CAlSKD9GN78KvHHce+Fa23RX
	 0OmGUANEgfcttVPgmt35B/nL3CT+PiVoEmRywUeQ8YCxy19C5GHWGBlesoY4xLf8yD5sc
	 kiAa8NqX9KGSJiKlewNM9QWpzTU06XxVk91c5/AxzWq3/vvNOoibcCJ1v6DawJUhURmrF
	 udXiLsTfWCKBs6YemjzKYzwLWikDRqw+5jDjPWyuFMQ5cZQ7Ndqc5gn2WMNaPy7TBgLDR
	 8uPAjJXFUrKGxPXKvC4dPZCvkqo7frpuLGTkeJd93umrf4YPAhkK0LYqkghbfPenTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=KCB5QfZGrVix2TOKiNYt7urk6h0akmYDJJT5EN5tPxHNpXXAe2V4oZuUD6jr1l1ii7Hu
	 DQS5R9i2SPOU3ebYpOegjkMfH9zgzFiAC5H6ShDThfH8x246pLKRz7lezyRggV8ZTvm/p
	 4aZJbxwocbRwA4YpK6wDYPAAmbTQSlHtH4gg1Tcpp0EENAkK5ShkeVJJDyP7zj7624Cx9
	 TPuDuxLZ3SFXYbjiPNZrpNHJ3RmP6xqXqSqfBScHLfsMkvSlHgwfu9EiGRrtp72LS3BfA
	 /0yQVQchYKLeF0sBYtSZXsR7oxefEZPhMyX2J90BKf67Xn/AgAZSgolYNZlHvUNReyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zuUpFt9J;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EFA606A334
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71EFA606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zuUpFt9J
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso153319a91.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=zuUpFt9J/cFubDGclKYU2ivE6da2df9R+LlsyBBxaOu0Pc9ckPYqOCKPk+od+eEdQS
         Vj2awdXKKArotuvNTgsp+OeUygUGbBjD5gI7w0wqelC8FVy61cDF8vIBT7NlJIbO6f/P
         fgO97Xns0J3oGOHTyzGdLIGWTZFn5JIKt56sDJZWC/Sve8OFGJDdFDaw1czs5n01rKOm
         chE1AxMCMbCl8jYcyeYll+b1NKrYFQQU00U11kFU0+Ko172o/EkR08ii/5ctiCTKHf+E
         XUF0+Jb+L3tr6/Ju/KRPYe1q+VvkAVEdwsbMEI4pirY/eypE9cJHCYXG2+MAawscXTIe
         GuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=QRlMHqvV5ArduJCw8y7IYqxpL6QQw3Po+son/a/Yao+RNLBRMdsdrd4JnjMXHg6PaB
         iSTCyanb0JC/VD0Q8tsHn4s+lPi/9crH5oPwB9HaQ2Q6G0Gi8BB8Y6kFXkLG4BoAW/Ak
         nKqfebkJMv7/B0EH9ZQ8t1zuFpag1ufTS7RsadyvP8XQcV+7zultZV6DRCDeS2Hb0ThD
         9k288fUbYqWZiwTLcbAC1bQqFzlhx+HrcF+l3Auj5Yy9+2O86NOtyCkTVQTAXhb+an6v
         YPxggK8F4oCZTWZd51lpwUS0/8KLmiFgVpTvKast0t7JByVBhatoulhSdXG83FEMyZNU
         QoBQ==
X-Forwarded-Encrypted: i=1; AKwUvByiMU5Z7zdcVTTPobEpfFaSi16qni5P/9FYeX7FxCNS5p5E4jf3MLmR8EgIEIYkpbveMoNVjfN32uv9Rg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9tNKH2++79NSIw832jlXd50ckTzWHTStEQAOL0yziRFpSqHIUy
	yt2/b4wXg9hOXksuuyVKJV3Xka5zomaZo0V7+21MWLwQvnIk1inlsUXy
X-Gm-Gg: AYBFou3PJhNDEfdXHpidJbUQwOMO2eaBurcj5+zxut9j4PyqQji4vMyXB7ZSGPL3WF+
	zR+oxD2SLWSCFXcVOFXksjG2aKXVN+5ZFhgOq0NYrGBH5anLtHFfteLfTH0digxIFc4Vz00gMW/
	7AoWmtE9zgVzmASi+/rXrFi0e5jT3ar7/HUF/WNSGe90XDwD3EuqYjPxbiJg67KD/qYfqdT57eb
	DmntbLKcTOsFC4h9avZHR2Ffob2+qBo0q1v0ubq0PEK7ySe1uqY+pauXqeMtQ0ms9WJqOg+ErvZ
	+Na9QW37PqhyUzdSdTJb1V9mxgFrkjuWW+kG3mrNdM3IfOowr5zY5hn9uoPGbgAxpKZm76dgbhc
	CtDVbNB562qiOyF6Bz/3gwYWUYAbc9cR1yEz20yZcoFY1dCa+rqqeH6swJ0dKz18qyioZReIMnv
	QBCYi4p7UICvkrmOqUSqeZ5K981sPz/QUHyFAiatZhXOa6MO/44T7duHBQtCK307hjRAtyzu7wH
	+KfiER7zDPtDK5S49dyDZajHUD4lI07RDSGo8P0So2avG381MlRo6uDzeN1OPsHUkyOwteEby5j
	PhTaRe+1H4oPixALcQ==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
