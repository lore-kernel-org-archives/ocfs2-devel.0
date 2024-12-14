Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F327E18FDBE
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734190369; cv=none; b=ey9rfI+1HydKIuMvYSdhVWrA2mrf7lg1vEYGaB9/UOAdR7wQ50EaclCFdRsqOb3VOy3VhVo38tqEyZ/bDTm3TMmUKV4gQUwJN1o3BVqYO3vV5DNWTsPJylBRXiJJ9A2na5EiagK5Csi9LMkA57M2PsxbcPrvTKSzN3ndAA/aTT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734190369; c=relaxed/simple;
	bh=dRuhxtAvpIxcJXAexAYuCl9JdIoBxBgs0T4nB3KS15Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVM/zVaC159lsQn/wiyvjKzvMyiN7nzh9eVJ8iiQmxq0vjri250wbN+DT3QcFWP0Dg+YJvaWrZzm2sLZSnXO3htfMzaNv1ztSpeVeiCNfzevF2bdNcNTJCwVmgJ2Qwx0upClew0ahs26B/2Z/IWltmqlSNSoIpy3WaEi2ozKU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kYqON7ff; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kYqON7ff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sGfiMeU2kaeTGFWIPrVnZhM5DL/J/1u4P6coYrEpvYc=; b=kYqON7ff4cODIilNNGbDtX6Ik2
	ercDWOJD8l+01xfv9R88fGoIxfaXUpLjOX6FBABLHsMtFocXdOXwFpBhucjT6mtv3RNbqXywic+eq
	QYbFfJIzBpuBsXkzc0bO+yF1F0kFEzNuebjKu8rePJcPZ+uiWHT2U7k+dEC2Zq5CmojNg44EbCEmj
	jiW+h5OExbkX8hW97OEmfdG30sMcc0lQJcmQwGbn/AtMMcxCXA6JaeaZwcbaFHqmHVkudswBKyP/D
	qXx/qugF59H1h+56RViZyBiYppw4GbZ1JMY9nDnw2r2AmgW6LKyDuCi+HbbmGoNYjP+LUMkY4uZmY
	nqW74fRg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tMU8K-00000003TFm-11Ow;
	Sat, 14 Dec 2024 15:32:44 +0000
Date: Sat, 14 Dec 2024 15:32:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: akpm <akpm@linux-foundation.org>,
	Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH 04/23] ocfs2: Use a folio in ocfs2_zero_new_buffers()
Message-ID: <Z12lGy7V8MX72lBF@casper.infradead.org>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-5-willy@infradead.org>
 <bc0eecab-bb1c-45c7-b1fa-504bb56a8b06@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc0eecab-bb1c-45c7-b1fa-504bb56a8b06@linux.alibaba.com>

On Sat, Dec 14, 2024 at 10:01:20PM +0800, Joseph Qi wrote:
> > -static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
> > +static void ocfs2_zero_new_buffers(struct folio *folio, size_t from, size_t to)
> 
> Don't see why we have to change 'unsigned' to 'size_t'.

This is just part of the folio conversion process.  Three reasons:

1. size_t is an indication to the human reader that this is a count of the
number of bytes in memory, as opposed to anything else that an 'unsigned
int' might be.

2. Prepares us for folios which are larger than 2GB in size.  Yes, not
likely to be something that ocfs2 ever supports, but on arm64 with a
16KiB page size, hugetlbfs at the PUD level has folios which are 64GB in
size.  So we need to use size_t within the mm & vfs, and we should
continue that into filesystems.

3. It's actually more efficient.  The CPU has to insert a lot of
zero-extend instructions when calling core code which is using size_t.
