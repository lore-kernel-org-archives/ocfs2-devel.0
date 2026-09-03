Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBD84EBAFB
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451871; cv=none; b=MgFzRIBiUEGBlNP5gCUNAsGRlaJdLvnfuFo4v+fS0CKNDNbEjPJDjenWFjnzKyIuJqMSBl6LGQn6WnNcyY8uVT62GqokX66ypY5xYQRuXkyxPc0K4u5HgG1xvm9ADOkfbCmd4jyPTEReMgcynynOT2/KnP5nf/AL8b4PItkK2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451871; c=relaxed/simple;
	bh=7y/YeoTdXNEh7ZIpzOeizOv9NA3RBjXR7PfihMVPEKg=;
	h=From:To:Cc:Date:Message-ID:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SDxQs7KoHhIKA0iZUzMqTWUNiBjjf/iwl19BRHhCGAj6pGrNTyXX2Vzbj/vo+1nUCTb3wyItxH6RySe4WZudt7iH/88MM5yDgPFtcnmsBBHC6HycjmH1TySihCrw47p+9b+1B527WfC9lRfTx1xVd3BrSBMdP1X0v3oTWH0VFn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMDVvGyl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMDVvGyl"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4843886fc9cso3311f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Sep 2026 09:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788451867; x=1789056667; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7y/YeoTdXNEh7ZIpzOeizOv9NA3RBjXR7PfihMVPEKg=;
        b=SMDVvGyl3l9UOpc9eWoyMGkaRiDD7WGvHCIXXnZKsmb0KKmz19Er1bGoxBZ4Krx7wJ
         adgJBUjB4Kgl2f8gIQGL8Ci9ZFQb2sf0VkKg1chHYh1KOloAQ0xrwGGu7h2Fpnn5lagU
         gg0rvi72dW59DXhithneQWwGtaiawAiDPKhc0+DI0yaCHP4TRhnUzGyOOCs/d7SeL3W6
         1xjfoDYF2HQaV62IJhZQYwte2IkoTw7ma6kfPMpOCzvo5/maeYM+av8P9go76vl4U+dI
         WnMiYrK0fpflfRhM0RPC97Sjq+f8ce4bvCIaskMFVUNglBnHF35CGyiqtaBF01ZpqRzZ
         GQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788451867; x=1789056667;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7y/YeoTdXNEh7ZIpzOeizOv9NA3RBjXR7PfihMVPEKg=;
        b=CF/BN78AruLV0CaD3n1//QCX//f2axVGIoRwKPQW0hA6DlKJ/ASN6sIHvXVlxQsArY
         LbK4N7mc29wENqlPzGcOszK8WL2yzXXorjK+dSszZUtwU7Pgj56FA9gBs3LQh6I+ekjy
         eUSFydPh5v7Te/X9qDM/CtggieHXkk/RNG9T8IS82MJpRXhH+7QuDsFiYUx6lI5xyFRq
         AU3XutjNnXKm+siLdRqlF/VlafMPZnS6u9hHPnWYJrrL7rgETaglfxhR/YR70aTBBf88
         cMl8aF6ezg9Abm06a8GmeKBq6CccqJxZ/eebyrrD5CNwX0mr3JbDON0IqmdSyX731Ks6
         AaIg==
X-Forwarded-Encrypted: i=1; AKwUvBwEW+fE2db9qFKBfG5XCLl8jVNSQQ6HkEXJuR+SJfnv9KulqNXFeU3yN9RhxEBEVIBr4rCu/devwoL7pQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kCQIVmSiZDAB28PHM0HnfkAH2ri8B+YA6gIkPjK/tW47npqDCD
	qkVQ/BWL/3aATW0jzCgEuwN6994oCrVcQbBUXfG0Rl9e5v5qSYkVltXb
X-Gm-Gg: AYBFou0SjDG+WjE6BfcvuxIIIgG0H5pHeFTRUjWNiyd6FKJNq5938HsM2mOPisx6cnH
	CzWLiCvD0X0NmlwPHDH5agPAS8mrp7pjeaIdgNJYg4mrdwFzGROdbeE/a9RIl4VCBcvsPFfdD6q
	7KADWgdGqDqLYUL+TKJgFyv2jXzwKI1zTAysf9rZgXJ4mi8RSDDK/dHABFGUPY6wgSDMU+u/ENC
	NI0ge/xjgcWil7vJeKurS/7+Ej+sOOzgyunArKjvGs5j1upLtqAA6G3oBeQAYhyo2KXECPDj0D5
	MeipZxc+AUAtuZ5lLJ4LB+tg5ykz5sM7He7ZF1/vnqyPMfyYe/FoUi5HML0zoVB0D1IYoEShgkx
	6p47aiXKTCG+te3d+P8DmwSZYyb0hhpH46sn4JzjuhLTStVfhZYMFpsjilrQ/WIP4biAPREt7lh
	yvZfExdMAtMidD1OXxQB/q92/cLcRdgHCWUAy0F9e26MQUjG7mwyRBj2xzdaUyAg5qQn4C/SHpY
	60kSYwkLzr8k7i0nWF3ol07diJhHCziXsT/XoYZeoWWwLU1VK6w57qkAqNM6JH1ZVrNreNzheB7
	UrcGWCEmPi8d2gFS/kb07gux2WD78gktvg==
X-Received: by 2002:a05:600c:5253:b0:49b:916a:e553 with SMTP id 5b1f17b1804b1-49ce558f53amr119012195e9.0.1788451867490;
        Thu, 03 Sep 2026 09:11:07 -0700 (PDT)
Received: from [192.168.1.144] (98.102.222.87.dynamic.jazztel.es. [87.222.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf2abe1basm49686565e9.10.2026.09.03.09.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 09:11:06 -0700 (PDT)
From: Miguel Garcia <miguelgarciaroman8@gmail.com>
To: stable@vger.kernel.org
Cc: pvmohammedanees2003@gmail.com, akpm@linux-foundation.org,
 joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Thu, 03 Sep 2026 18:11:04 +0200
Message-ID: <178845186455.1865019.13911237622799207209@gmail.com>
Subject: Re: [PATCH 5.15.y] ocfs2: fix deadlock in ocfs2_get_system_file_inode
In-Reply-To: <20260903152435.1801594-1-miguelgarciaroman8@gmail.com>
References: <20260903152435.1801594-1-miguelgarciaroman8@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Please drop this patch. This branch already contains acd5768c7363, a backport=
 of upstream f5b1910e23f1 that removes system_file_mutex and fixes the lock i=
nversion. The older trylock change is unnecessary and can cause failed direct=
ory lookups. Sorry for the noise.
