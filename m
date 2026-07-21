Received: from sender-op-o18.zoho.eu (sender-op-o18.zoho.eu [136.143.169.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D348A2CD
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784634851; cv=pass; b=o8IKmxfC1N/a1k3+FrGnd12zy8VKktNQw0QvzzvavqGTceH2Bt0ZCfAbdZWVZo1okEnrM5/Mu/nnjRgyOHB8LjLpY58YX3bgaAE0UBxOouml1r8pj5Gs0UrRmvx2MxJGA5fRoSZf1Mz2UGfaYsmdOXQCfAGb/Ah/+CovJd1lKNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784634851; c=relaxed/simple;
	bh=xhNSpl0BrxHd2cKBgtFWTxPLgaQfDsL+dK6E9Epk+NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocR4aXPiIZlfBzVvkLubl69BYrLfOtkfVG8ariMOPThW8ubiS6lYuFq21eogEMIhTTrCUUnSMjx2HZq0nxt0NUXedh1JnSTcNMHBYCtG1+U3sxrrdPN+hGUyOvBPhomfRaGklPMMkLWcmbKA9+rUmT1dLVn/7xWKgLrfb5WWPXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=WJlSTXd0; arc=pass smtp.client-ip=136.143.169.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="WJlSTXd0"
ARC-Seal: i=1; a=rsa-sha256; t=1784634838; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ioAvo02gpCl9PPVFuDExFaj0x6y+cwZxnEoayZ2Z6zesnHE2mX2ojRd0HEPalZTl5hHjF0BFj5OyFxMuPn9wc9KDQDFIm9lagFzzRfdLxqwLXAAjS+ffMxvOm/mqEhleud6OcvsT51xqPEgilrj8BjSK5Eumg6fKiFNfB608PSU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784634838; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xhNSpl0BrxHd2cKBgtFWTxPLgaQfDsL+dK6E9Epk+NM=; 
	b=O/yoLihwe2mt8GYepFNw/n9fgC55wx1+1qWvOjxqjrjG26j8ft2oFFH0SAwzKviigHP9ianhKOssU8ykvY8jMdJjBdHSXpJur3dxGUnkEoKcelWH9T2AGWiEFhAfFvoOaeQl7RWnrDUj62jo8qGSNbQg9eG07R7w6wHYVdB+Nis=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784634838;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xhNSpl0BrxHd2cKBgtFWTxPLgaQfDsL+dK6E9Epk+NM=;
	b=WJlSTXd0uqyhEQ0MAujxigMs5MWrOXDyRgpUV/Xid3Wi7eyPNPtp98K/QhZM1gwH
	Indh77dzSo9s1MG0+4oNfJ4R9GjWsMk5ZxJ5rMiHakPH2wqqm4pyZ4w49qMD8n2g1Vb
	rFgSnUC6E2TypFL74675mLugZfprTdpouQoSw9RQ=
Received: by mx.zoho.eu with SMTPS id 1784634837310921.9226982488001;
	Tue, 21 Jul 2026 13:53:57 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/dlm: validate lockname_len in dlm_mig_lockres_handler()
Date: Tue, 21 Jul 2026 13:53:53 +0200
Message-ID: <20260721115353.17272-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <b5657937-3c3a-4d85-9df6-80ebb6feeb24@linux.alibaba.com>
References: <b5657937-3c3a-4d85-9df6-80ebb6feeb24@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Thanks, and sorry for the duplicate -- I missed the earlier posting.
Please drop mine; the queued version covers it and I'll follow that one.

Ibrahim
