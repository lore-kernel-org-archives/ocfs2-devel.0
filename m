Received: from mail.spsk4.lublin.pl (mail.spsk4.lublin.pl [94.230.25.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A663EA96
	for <ocfs2-devel@lists.linux.dev>; Sun, 28 Apr 2024 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.230.25.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714301859; cv=none; b=IiUbBvLF/KzZBkexkzP7Hl7UQTA25KaKGVPsos+8YQqJsRzCrIU+em8rnR6JlX5gB7O2tXF3MHJedm0j0IsQycyuZIcPyhMHfBesewu1WehdkmeUsl8kcxK3bdYMNCSb9/zcGzqw20hmGb8zIgOsD2efNMpX+Wg4OySBwc5YYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714301859; c=relaxed/simple;
	bh=Ib7vjcptqy4dhDzw/2OS3hTNZUSstZyJq+40bpBRSA8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r0LnkVJnMJ9Opqg3cXetdv/yE19J/1m7Q4XFqoUAK3zUBV6qaxKIUbIrsMtYpOrkrsThPSU5MhTinpykzGOVzELHJPB4e/Zy5Jivtjz3qRI6eZYmQDjQUI8x15Uo7brJvxt9AkicZCAOP4cc0uTzcC8Sfg0RLol1bHJRWF/3fsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=spsk4.lublin.pl; spf=pass smtp.mailfrom=spsk4.lublin.pl; dkim=pass (2048-bit key) header.d=spsk4.lublin.pl header.i=@spsk4.lublin.pl header.b=cw+MwEyc; arc=none smtp.client-ip=94.230.25.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=spsk4.lublin.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=spsk4.lublin.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=spsk4.lublin.pl header.i=@spsk4.lublin.pl header.b="cw+MwEyc"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.spsk4.lublin.pl (Postfix) with ESMTP id 36BE828349
	for <ocfs2-devel@lists.linux.dev>; Sun, 28 Apr 2024 12:57:33 +0200 (CEST)
Received: from mail.spsk4.lublin.pl ([127.0.0.1])
 by localhost (zimbra-mta.spsk4.lublin.pl [127.0.0.1]) (amavis, port 10032)
 with ESMTP id LMlpugUdWL7Y for <ocfs2-devel@lists.linux.dev>;
 Sun, 28 Apr 2024 12:57:33 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.spsk4.lublin.pl (Postfix) with ESMTP id 12905280CC
	for <ocfs2-devel@lists.linux.dev>; Sun, 28 Apr 2024 12:57:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.spsk4.lublin.pl 12905280CC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=spsk4.lublin.pl;
	s=0B6D5DC2-FF57-11EB-9505-2F96557CE46E; t=1714301853;
	bh=Ib7vjcptqy4dhDzw/2OS3hTNZUSstZyJq+40bpBRSA8=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=cw+MwEyc0rp6WXviKrkg0RkbJuIXOLRvrniAjSuGHBo1NTKb1TQYH1rPHDDBLfzau
	 0V5mxlBiB6YhsHLC7L+2z7ENVT0VEcLbuEYgzHGlqYoc79Wq7AN8D/62fi37JGzu7q
	 Hzth2kHsi2phiyZXDbzHlEiimsT6ovBM4pNHIgTrvlUVVZ1ks5xbRG/IqRbTFePQ1h
	 g5LzXBIRRrUs+IiK24e23VrToY3SzQ2c3zbBhPBq0lV5Y4wO2zQJsOoEv5WgngXNKD
	 k5/M7BGaV6hY6hwkbviyj6HxSyLE0oPwx2ujhHNI/0I9uTAymTU5wTRALy7Pj4m0Ei
	 rNtDThI8bB+zQ==
X-Virus-Scanned: amavis at 
Received: from mail.spsk4.lublin.pl ([127.0.0.1])
 by localhost (zimbra-mta.spsk4.lublin.pl [127.0.0.1]) (amavis, port 10026)
 with ESMTP id kyrQsjVL9YOG for <ocfs2-devel@lists.linux.dev>;
 Sun, 28 Apr 2024 12:57:33 +0200 (CEST)
Received: from spsk4.lublin.pl (unknown [69.67.148.71])
	by mail.spsk4.lublin.pl (Postfix) with ESMTPSA id BC65B28343
	for <ocfs2-devel@lists.linux.dev>; Sun, 28 Apr 2024 12:57:31 +0200 (CEST)
Reply-To: cheng@xinyisolar-sale.com
From: "Cheng Kin"<Marta.Orzel@spsk4.lublin.pl>
To: ocfs2-devel@lists.linux.dev
Subject: Re: Representative
Date: 28 Apr 2024 20:55:43 +1000
Message-ID: <20240428205542.1B0D235D8CCFF82C@spsk4.lublin.pl>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello ocfs2-devel,

I apologize for my cold outreach.

My company is interested in your service as a company=20
representative. I have also reviewed your profile and know your=20
eligibility to work with the company.

Have a great day ahead.

Best Regards,
Cheng Kin
Executive Director
Xinyi Solar Holding Co., Ltd
