Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961982;
	b=Qq3bnZxX+3IGrZq12Lfc16SzpgKLgCXa7T4TKmV8tOQGwHFowA/LxRUfw5DgrIi5xRs3
	 5hXh3hqn6e3ZvvDXOB+ljk/HNQjDMZoD6CpRAXHCT/Q6gHb0QpJxzVDxV3Hl79KZ16rQg
	 4mA9rAj37mYxI3ajUzMd2Oc2II8m+0NwEtYeMLmn5wXaiQ1+pNtlWHoDdj+L1vAhX4D4s
	 pNQdsiy09KMi+KfSu1w04zjrfk9sRo6kfDeLkA0wSh90UO5KbGKNeWoZpVr63extHFZ9a
	 h4HWKYMV0wPebWryHV7sMjatNF0R0kwQvssLoqahOK3ZT2ZXL3m4gUW7EC587TneISA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961982;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=J7UI5nLZkT5qt8k8Tf21m5WtN/wrTPJmSDvwvBhEOrg=;
	b=l2nB1SnT+sMNO7hWFd0IQXg/iJO5ZnXklU6a9gG7hZibiPixMVuJlnycErI1Xh5C1EdM
	 ImNBvGzzktaYYYe+MKVuUzgUlpG3AO+Wk2FRNkVr/0zhbRg0+RIRAUqIEa/87hxWhB6Ia
	 fq3GNHdBqpzCWjcGUDbMXN3/rtcqs+bBWyev8CTh0/I2wzaBafu0p4CvgYw/46O5P6KCc
	 PU/i75puA2guGrF5dC+0VbiaC0OnF9qGjTLtYW/eCaApzzT1lgzmG34MUL9cfajtYq36o
	 1wTRiL8r1XJ5Uc6BVuhcTVxpkY6xziu1/kjmC4gWtiC+o67d7MvpbBiwHXGf0Kx10Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328AB606A32D
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 328AB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C39768BEB; Fri,  6 Nov 2026 11:46:17 +0100 (CET)
Date: Fri, 6 Nov 2026 11:46:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 0/4] migrates ocfs2 DIO from buffer_head to iomap
Message-ID: <20261106104617.GA5746@lst.de>
References: <20261105071930.16399-1-heming.zhao@suse.com>
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
In-Reply-To: <20261105071930.16399-1-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

s/migrates/migrate/ I think.

On Thu, Nov 05, 2026 at 03:19:24PM +0800, Heming Zhao wrote:
> To simplify iomap development, we currently adopt the simplest approach:
> retaining the buffer_head style, where only one cluster is allocated
> per iomap_begin() call.

Do you mean you'd otherwise need changes to the core iomap code?
Or do I misunderstand the sentence.

