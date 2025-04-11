Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8D218AA3;
	Fri, 11 Apr 2025 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744390846; cv=none; b=PAwqOFUTpR+8Qz3Y4t91erN3bSJYmwXMS5P9m93NBejLmheOZ4X6aQ1OcsFjjBLUzchB+UemVxU6gQRNMmODWFJoT1o6snN8TPQ6XxH4I0WHkCNYu0FVuicD2kgW8myMP9JFymWMh1u3zYXFP2o4lYaJy+gm6RrJ5v8PWRzrNuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744390846; c=relaxed/simple;
	bh=fZeDnoqOlwr6bqlyhmVYj+EY+7kK1TudkJ7IdmQuhOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4KVmO4RTuw9WaeBiDaQboDlHfNv4CSNaRrNSV6MlkHDbd8UNJPz9uTDdt9kLOV89UN/EPMaKioKFnzuEDta7KxK4s2U2COOwx1IOKaNEujfH4PAPXud1IPGku8HEfM5BLZqQJmDgCl3sqQOOQshxvor2IZk9XjyI+MYQcCIWpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=COrk7dQE; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="COrk7dQE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RDQBmqFaBhPLuy5MOPb6NXUgzBLRWU65tfq9yYBm5Ts=; b=COrk7dQEdXwylGHipvmANu2H+0
	O5nOA+nAXt+yzBLIXdtnAj86LhJvZLgGK5XMs1F3ZRGqtRgtP2DHGj9DhZogvnLa8iP3CPXKP4lsK
	DeRjkP6OsILi+FLqSBWI1CS/JuB6YGcoUthOypMzXiLNCDsuYACYWHbsqgSTmAbciGilGI+5cm/qF
	tqyUnNjICNFqlMMTkcaQ5cUWdVTUIgLinQQuQ2Xk7cA1I0HHt0NTtTE4qA2WT6aoARHLZ5czNqqO9
	k2f01jFopz24pGTBUlYYEQ9Qp0ksYLyhQ6chNRA/gYbINdqKlTNjmQD1dgzAj9HgYS/NiYum8+xJL
	cy90pY8A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u3Hk8-00000004eQX-2sQ8;
	Fri, 11 Apr 2025 17:00:40 +0000
Date: Fri, 11 Apr 2025 18:00:40 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, stable@vger.kernel.org,
	Changwei Ge <gechangwei@live.cn>, Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>, Mark Fasheh <mark@fasheh.com>
Subject: Re: v2 [PATCH] ocfs2: fix panic in failed foilio allocation
Message-ID: <Z_lKuCZM-k6vk1lQ@casper.infradead.org>
References: <20250411160213.19322-1-mark.tinguely@oracle.com>
 <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com>

On Fri, Apr 11, 2025 at 11:31:24AM -0500, Mark Tinguely wrote:
> In the page to order 0 folio conversion series, the commit
> 7e119cff9d0a, "ocfs2: convert w_pages to w_folios" and
> commit 9a5e08652dc4b, "ocfs2: use an array of folios
> instead of an array of pages", saves -ENOMEM in the
> folio array upon allocation failure and calls the folio
> array free code. The folio array free code expects either
> valid folio pointers or NULL. Finding the -ENOMEM will
> result in a panic. Fix by NULLing the error folio entry.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Cc: stable@vger.kernel.org
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Matthew Wilcox <willy@infradead.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
