Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684519;
	b=ylVjt14g9azmu8VNJQS/w7wU2+EaOrur39buPpItYq+myMAxCdP5Jn7MTdhMDO3yQe1r
	 QoFR/R8k+whw5Tn93OYG5mAwoIS4fiGXT62o+7rJAFpuqNl5wZ09Tb5sxLiam6JK4buwv
	 8ppiWZjsHyDfFdJyby5FwpElvvyh9Un6EYK9hcgE5ZR2qss26BZHUC6Qr9IuGl9vLJoTc
	 6ewFt6qlBO0ypieSGOTCTsCru+tPoo2ZSA/jC7r+lgcTjLIM4ayEpmbkNcPiYtXniUNHZ
	 09ORUwPtbj/NY+rW2DeJYAH0rOKIPt/7L3x/va2I6TGL0V5q1mvQP2P3Wer6rUSW7TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684519;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=bQ8ajFT5xhILdB0dsRYEtZZRvSWnG4oIvX2mQOlC0CI=;
	b=bRG0vZeDYwt/YWESTytd2Q/54IUDwUk81zVBpu2cEmfAH9q4qAeN1lvr1cCT4IxexA5/
	 twqSgZqXoTZQR4jAORseWpXMzgOqGIhMyzD+BYdBMJ03jdfiYsaPei53s1hhjqN0rzvs3
	 ciRCkwff2FYwbFD/vFSX61t/FybjuPYIfgk5PqWz7xExnDaQBPYicD3/a1Izs9F8Mcxus
	 syvP4xq3g+xPLIXLGFsDgBY92DcxFJ5EpRII4tRWPcdfcRBrbwlk2lSEQEEnNVqhYY2YO
	 OIc5OM7IJ634zNyogU3gH3sAiwPMkns+TZmD6aeU4l67D3zFsTA91Lu71y12QUOmDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA99B606A329;
	Tue,  3 Nov 2026 05:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA99B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3967B68AFE; Tue,  3 Nov 2026 06:41:55 +0100 (CET)
Date: Tue, 3 Nov 2026 06:41:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103054155.GB1559@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, if my previous reply wasn't clear:  please add the test for this
to xfstests where they actually get run regularly and not the kernel
selftests which for file systems are basically unused.

Bonus points for having generic tests instead of purely file system
specific ones.

