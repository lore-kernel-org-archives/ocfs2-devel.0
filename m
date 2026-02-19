Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E3724DCE5
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Feb 2026 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534828; cv=none; b=nUst0i6EMWHkBWEp4uSPK7+C8vKb1izb7+H1Ow3WNjfUHecO0w0AbGPqL0kGfSSM6g6eb+1UdKXEX86j4ixiD5LgoRMIMgKfJVxlQn2ekazpFYt2tD1KqAEtlKG7yyXuobWypLYnmjw9+6mtMwj1ZJHbOMYV5Qg1aF4M3K45OKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534828; c=relaxed/simple;
	bh=1m+LHmJ2ii2fMCL5Yw8BNOu1FGvmwApnkiD4zM/oDwo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CZ/9+rLD7gX2PVXaC2koIqDu9FYWxo0SSOVFbMDVfELERKmYKsoCaY4Vw09dbP81w0h+dEzNUo2MwxENyuuBblEoAeqOysgij8dQ2X4fNtwKV0xD6qzAfnspVXk1mO4oBDf2F19qbPcKBcDGSmKZbfIiFPVXZ4TUHGLFDf4Op9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=Flfq8Sig; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="Flfq8Sig"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a91215c158so9756265ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Feb 2026 13:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1771534826; x=1772139626; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gN2p81ub7C7asTTClWhi8yTk7OGAaWSTbhCB/Ej6QE=;
        b=Flfq8Sig80DUs8OQRuMqPiKKF8QGlwHLbtoF0n9Oza5Bl5qAx28rG+9MEFgHGXjmdg
         p5UCb87ngQtAh5YUNXnzx6JP8nlhm7snXS5ao5zh0KNbZTBgBLz6D40u+juDZVW6OgCH
         PzDznnqk4jNb5Jm5SVD6txbu4EhvHTqgEdyAJaV6p8lnX8E+3+MOjWVXBw9YL339Pes/
         Q0lpK/Pv4uosdsK5whX79VefvpnXTVTZBnsswCdPPQ0bEewaTxMqq5x8kzN8O33EPjky
         yirRbCJgeTkx25mYJDEhMzW/tK9NJgR28IzQo4FurWvtMHqmxBnSVRUCzz1TAmcr/vzT
         0flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771534826; x=1772139626;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0gN2p81ub7C7asTTClWhi8yTk7OGAaWSTbhCB/Ej6QE=;
        b=ZxEAdzGTYPm4mZn6vhvscNgL/5vuszWwc7jopCANHvnXtc79hoPR9GDGN57aUy/b7B
         L8JpG4rLrlz0SMYZELJ61qndSL1AgKKoUEXH/q6ZsZKyOYRnQzy5nHSWGRFV4YGb3POr
         x94dt+/DC0AUoMF6LluL4VkRtxvEHLK0tolAtMI8AzAuKNndSY1xxjQlQJhCZQuY0bF+
         eo/IOnusF5/q0fix63FyHs1wnw+mF0X8gTOV2RgePRv0gXg2eVI35IFvceDdDj3BlAd9
         jjI3hmRz8vJHoLqadyLPi/fBy59z/SUThmMVJ5RsJl9z0TbfzEpMXOzAREJSeniHPzfu
         GvpA==
X-Forwarded-Encrypted: i=1; AJvYcCVv1g5Hox7d6FIl9T8kDX570kiCBdK1Fw4Ci1/B0BGACJBPOEc2EOAlIeWfX5kUU0ppvrATXpkPDmXfxA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdt2D1Ewgmj0oy7WPMf0m2P89q7ThQR731bgvA3JpIFiK7ih5U
	RuSNtOYwHkOOCDoGulabaOOAKfG/nmYcnS71xG4wq41jTXad+4+03iQO/AuvaTwy2Yw=
X-Gm-Gg: AZuq6aJyB3CvAgaWH1b2XOVp+qOtiRp1idho05ag23PPhLqs6nPsqj7bTgCnQfqNzu1
	tYJyBvkXTImbrCk8f/0ZLnOXdUzmDEvJpOvnvfus39o4f59We3mzbThHdRo7DnsloYhD89cbdb0
	psTT/soBY1VHOW7Zy0ggRbzwIZPZ3Xg6CZIIZ24cBS6XEcm5AipkYUiuzyKrstTM/HlkG//SI4w
	/NScQjttdNBX82eWStGgzaplBYHSi1zhGgxYTxGMlVsrw968pPdJwG4r4p6I5uP8slfQP3ihRYa
	crmoMuE/Zi3/O7dOov6GOo9Tz0cVhzcwZyulxTCa8keueutqRGcf7MvXXpOi2TAG8w7rK7AxUXT
	e38fXeKlmGmpGRCQ1UllAyG4db0/xpzRpEnPk718PnsRGSqJAIvnYxQ2595kcr6nyT9jOjrJHMx
	J13Zy2v4BIxWSQuzlFInCpJ/fc0p4NEuOX1pXmjbE7vZYIo/7AISyQKKdYAPc5BYnjjWQQLW18R
	3TIwPa4rEl/5qt/
X-Received: by 2002:a17:902:db02:b0:2aa:d671:fdf9 with SMTP id d9443c01a7336-2ad50ecf977mr59971045ad.26.1771534825843;
        Thu, 19 Feb 2026 13:00:25 -0800 (PST)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6fa260sm169579405ad.5.2026.02.19.13.00.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Feb 2026 13:00:25 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 1/3] jbd2: store jinode dirty range in PAGE_SIZE units
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260219114645.778338-2-me@linux.beauty>
Date: Thu, 19 Feb 2026 14:00:13 -0700
Cc: Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>,
 Mark Fasheh <mark@fasheh.com>,
 linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev,
 Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <63C86D0D-9EF6-4D33-95B2-8D0F5B305B0B@dilger.ca>
References: <20260219114645.778338-1-me@linux.beauty>
 <20260219114645.778338-2-me@linux.beauty>
To: Li Chen <me@linux.beauty>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Feb 19, 2026, at 04:46, Li Chen <me@linux.beauty> wrote:
>=20
> jbd2_inode fields are updated under journal->j_list_lock, but some =
paths
> read them without holding the lock (e.g. fast commit helpers and =
ordered
> truncate helpers).
>=20
> READ_ONCE() alone is not sufficient for i_dirty_start/end as they are
> loff_t and 32-bit platforms can observe torn loads. Store the dirty =
range
> in PAGE_SIZE units as pgoff_t so lockless readers can take non-torn
> snapshots.

When making semantic changes like this, it is best to change the =
variable
names as well, so that breaks compilation if bisection happens to land
between these patches.  Otherwise, that could cause some random behavior
if jbd2 is treating these as pages, but ext4/ocfs2 are treating them as
bytes or vice versa.

Something like i_dirty_{start,end} -> i_dirty_{start,end}_page would =
make
this very clear what the units are.

To avoid breakage between the patches (which is desirable to avoid =
problems
with automated bisection) you should make an initial patch with wrappers =
to
access these values and convert ext4/ocfs2 to use them:

static inline loff_t jbd2_jinode_dirty_start(struct jbd2_inode *jinode)
{
	return jinode->i_dirty_start;
}

static inline loff_t jbd2_jinode_dirty_end(struct jbd2_inode *jinode)
{
	return jinode->i_dirty_end;
}

then change this in the jbd2 patch at the end, which would then be =
self-contained:

static inline loff_t jbd2_jinode_dirty_start(struct jbd2_inode *jinode)
{
	return (loff_t)jinode->i_dirty_start_page << PAGE_SHIFT;
}

static inline loff_t jbd2_jinode_dirty_end(struct jbd2_inode *jinode)
{
	return ((loff_t)jinode->i_dirty_end_page << PAGE_SHIFT) + =
~PAGE_MASK;
}


Cheers, Andreas

> Use READ_ONCE() on the read side and WRITE_ONCE() on the write side =
for
> the dirty range and i_flags to match the existing lockless access =
pattern.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>=20

