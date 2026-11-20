Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199707;
	b=O1sIuqM2aGZnJZuKg5mX7guuBEYsmuSuKBuhISw1bT8k+xi8YJPda9FgVNZGXfWO8vEY
	 82xTeaM6PI/tEdYGXczoGzMSndm2rFfTgQBaAyHwNfiPnKlvreme7UP50xASINZa5cSrQ
	 Q/rHsELF7trPk80fUyzvFqulkCtXDH+KVS1P1kFnACUmEwHC0h+wPudC+ZOBgxCbzvMVQ
	 g8Bcz+3Ex9qrR0fM8w0ULD5VDeonREUyHch1SVTH61Acr/kodmbqoMs937RIayfYK0gk6
	 rHa4Ase0fojAPly1bvLwz11thH6SpWQ2Jr9DOnKlbmMb7puXnjO8iLsbMY4hwkh34/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199707;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=r4OqJGPmhA+Xhu1nzoX+TSKGoy8IYPfwwWZBcO7mwrt1bQFx0ELIR7cHP4u+iAU4z5OP
	 HmbfWFqdhGFHbYglojsFW7Tt/spWspPqezy8oYG68rxtUafDzy1/ZYvutaveH/D7w3a+f
	 c7iVF0pjGYXRuF3m7C3/m8QcAtGqazWKkm3b3EuIXRri5ON++5yMRPZFSPQCHoYk70xbr
	 rkBoYW8jld5jeUSiuZT2udr4jNAnfnpzy8cuh4KZ1i4Aj/W7rNHRpuzWz23saztUU37m0
	 /D2mRHdXQpfHQRrS8GIypW9AiT+XKiCNVnGJhYQtvYccin65jc2zbVJvLm3ZgHAX9eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA1360A260F
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 18:35:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DA1360A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 934F86732A; Fri, 20 Nov 2026 19:35:01 +0100 (CET)
Date: Fri, 20 Nov 2026 19:35:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v9 2/3] ocfs2: switch DIO read path from
 buffer_head to iomap
Message-ID: <20261120183501.GB2450@lst.de>
References: <20261120060014.12087-1-heming.zhao@suse.com> <20261120060014.12087-3-heming.zhao@suse.com>
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
In-Reply-To: <20261120060014.12087-3-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
