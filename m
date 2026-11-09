Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257504;
	b=iJgja5MIePWKv6fbs44RqOoMR7xxtx/0sDHFlyn653USN5AE98o/FxHgIzbzdmMGeCBr
	 nu2IS66k+4LmR5c7q7Tz+sMkwiswhKEHMdjy1Fevpc+aJQ+KOnExFU0qrCQ07fEQ9WBZN
	 3xuiDYfQraByi4WRbwvh0Yvi0U3nGFrhmOyPUMATM24PUAaVhkmETfrJyb/ss97SkXHWa
	 OwpUq3PxO+Xc+mfsFmKBxNmWEn92BBkC0WOekC5IP3YUCejYY8Fmdbzw3zMW5eLLokemf
	 gOXyb1ItJ72WajoG1//i30WfsX0ZqvEj/hi+iy1x8rKJv/Id+KCbcQnE2mr0Kw2tXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257504;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Pnowon3ySHj4s3V7gApt6Sl7sdIOH1Z/iRJmVH3LDsU=;
	b=2Z5A4/VQTgtmbL9lnHA/2cr/TEOd/OtQCQWqEDMCaOmcljd+lzMlJSrLIpuQgtaCHnA8
	 8rYJJl3WeXvCio8NzhHxa3L9n7ncffOcbgH0kMEIagEaAdKkmkCUw2ePk8DCNj2JqmiSH
	 bQ0BNelcJc6QTDC/dg8zJS22AZMtLXhA4lyAoSFtVFtQF/+xP6riO8B12GTnRDP04aaDO
	 w9TwS1oDstROVWFmBeeBmuNcg9nTucSxEfYXAAE4Yz2JutqwF+rxR0JeeUBXAGQpuE0U0
	 wAJzmmFLBcZM6IUv1+Vhej4hT6ZlC2X9tZLG5SaTJFIoUZtC32srHxX58zQbRQb0piA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UPIT6fUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685F4606A32A;
	Mon,  9 Nov 2026 20:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UPIT6fUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B911D1F008A7;
	Mon,  9 Nov 2026 20:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257503;
	bh=Pnowon3ySHj4s3V7gApt6Sl7sdIOH1Z/iRJmVH3LDsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UPIT6fUfZiq8RipkCFzj3P+Ku/kbsEdGf3X6gZWV41Egn8T0Nfziqhx5LNiLBIAxe
	 F6zx3yc4rQ8Yz1zrbzO5EktuS2YllrOIuO69L1PzRwp77hf2g9p9bQ4FwNZ6nEZ9GT
	 1nUcEaGg9FVkHQuhVBNG+qc710DclTG7AOr8n+V4=
Date: Mon, 9 Nov 2026 12:51:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel
 Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/31] ocfs2: split dinode validation into shared
 predicates
Message-Id: <20261109125143.4e1428ced7368e1255394a5e@linux-foundation.org>
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  9 Nov 2026 20:20:50 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> ocfs2_validate_inode_block() is a flat sequence of about twenty open-coded
> dinode checks.  The filecheck variant duplicates eight of them but reports
> differently: mlog() plus an OCFS2_FILECHECK_ERR_* code instead of
> ocfs2_error(), which can force the filesystem read-only.  The duplicated
> conditions had drifted apart, and filecheck silently skipped the rest.

Thanks. I'll add all this and feed it into linux-next.

Sashiko is almost happy, one thing which looks hard-to-hit.

	https://sashiko.dev/#/patchset/20261109122121.21473-1-joseph.qi@linux.alibaba.com

I'll hopefully feed all this into my LLM-driven live kernel testing
setup, which is pretty comprehensive.  First I need to address some
reliability issues then make it not take 48 hours for an "overnight"
testing job!

