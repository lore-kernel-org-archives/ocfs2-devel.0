Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408969;
	b=pAZQLvha0lsAXyFxpg5/pz5BUCS5wvCYamK6T27X2Q3puciHa8LI6DUoDOgJFZuEy3oq
	 0MQhH6Ll1X1UDDdCDhSvsiXJWk2md7hzUGA+TiSrjIPhcPLWAGvgDOGZKSAQZmA26fSz7
	 CCpLkcPEVbkFZ3HgNUad/SdXze7hSSv8DuF3kw6S9Km2XIAMekX8aDSDCtHw2FMz39nEw
	 d8896d3Qc+mik4+M6wss75DS6iL1O9DO3rohi6keUAJlOLqjx3Gqa1S1I20mpr42lobYm
	 6coxL4cD7HRTx/cUJ4C2+ETbGvKQZZshKj1ZjaJLDmbp6YS0+jWs4/FYsWBL7w/BrNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408969;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=GonZG2wwIvN+gNPTSiAAkhawJ65Nfia9tR3JjSU8YK0=;
	b=njLklijsLPme73fFuRPQZB/xIiZNRyxULNuK7RRPyYRS/00CwMBG1wpvcPPK865DnT52
	 p/vJgcg7C/ijERd9QpU3H7KAm0HPv8BUUOm/nsnrscI9UyLy84+5qIaAdPDFnJiqaaTj1
	 jGnt6I2glQpCKu2n/T+2IuHtx8NPH2RuPkUbupBziQ1eYXGDp1I8QYRssxjMEzKyyMoYf
	 b4Ue2DzPWPubwbKsZjtswJorFbHLwhWqUbkUaKSdq2ToPv1WultLWkJ7A0bWkMwwMzSVZ
	 5javtjySy9CBWSl4wATRjp+qV9Br9cgyo5pfkwTnsLkj2YEBBTB+zLMhAoeDG8CnBKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC0E606A321;
	Wed, 11 Nov 2026 14:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDC0E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C15C68B05; Wed, 11 Nov 2026 15:55:56 +0100 (CET)
Date: Wed, 11 Nov 2026 15:55:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <20261111145555.GA9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But i wonder if we want a thin wrapper around ->read_iter/_write_iter
to do this check so that it matches the normal read/write path?

