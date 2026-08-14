Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6421485510
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Aug 2026 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786721768; cv=pass; b=cc26so6SIXcC2C7ZeHhq/jjLTy0IxjoVfE4o641pf/O0J3Z9tpyarebc0yIbLpsSbaWrOsP1b+NI49wq8SmYC0rGVcSMm4/7gXR0gI4ORw6Xdg+XUwd5vs1jl/5q1hQlQ8sfZMnGNo585ZX2fa8fuQL8T7zB2ghxHhjDYTArX54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786721768; c=relaxed/simple;
	bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g9X3hODHNmvJpNlCvPRnXjbGPaLtYj3+MKmmsmGg0lasBKqzZwBAA/p5we91IaWPI1nOMUefYv07UQfPIWMrJTME+Nw1Wnec6ULP1Yaoli2ItsqgWPDgc+cV0fkU+2YkqxyNAzMgxCrII7DDAR2g0y1FQRTvER6wJPVwOMynxQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3eAzf4K; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3eAzf4K"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6aaf3f54dbeso887961eaf.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 14 Aug 2026 08:36:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786721763; cv=none;
        d=google.com; s=arc-20260327;
        b=hZeG/cloAf/CAiJhaAGpKcqZOg3NTijbuUC73giN32dFo0jDB/RjUXdQQEOo08LbJV
         Z2cb52mw7O7IxZRukukcoEGTT344NUgkJ0oKpcCU0emTgNSvGsNN18CP1ivfAewDsRuq
         tr0zS2JcOVspOIIQVnFY4kMPW6uvGdApweqeANA8aonXPsi6lMWRRjCltsHJ0+TCM2I+
         Ae1831cHQ7l3lsK29bg8ueUWgSMJbBAHOeCWAegxDXDB4BNKMRL89NNOQ5n5zMWtE4IB
         BD9OnaHP41pagHtQaEuY80tNlkqog8DjORfvFf4CnCq4ZDxOtNlu065JayCHwbRQflTk
         Wxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        fh=y7frJYl11Dz8KF62Cjp0OPXpgJj4NnKhwplvh4WVBPk=;
        b=cVrWR6iJo/LLai60Q24hMrYfrB70uVIZa5ZZ3JMdvrrGVGuxES53AvVY/knrRvsLkB
         hR1jA/4qK3nYAr05TmS7evrAOK/Iz7MDJQlGL7xDrCO6z4ERYwyY+YGi/K9Kxf/cB+QZ
         tx/qxXEkEUpw7vsvCaXcWuwKWxtWshYk7z4lsI8cEekQMn0N2VB/c3o8taL2WBbYZ091
         4Nf/B3fic6coJZuE0mpppSD1Mzr8dEQ2ssfc1+XuFvCw1Una7M79SootTnD+cW7T2cxU
         3YuRRZUh9xAAiNm2qcn0jy4y+W+0lNrFdtJM7oKaIKYx8CvZZf4eEjht7LlT+Lap9gWM
         3Wfg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786721763; x=1787326563; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        b=L3eAzf4Kz2VK+xDiFpJy2I7OsbaepYtV0Ifzk1p1w3bdv8w4HCXd/pqZyJvXXX3wuf
         IXZqRjIz0KomeyFDls8nOf4km2j3Um0Zn7LpeSkO7mmVI+OW77cqA0R/XwtvteXRxwhv
         /vImuHVtvcvSpH1Rfujoc7Xh83lFa267c0R/FcBj4ZlBw8my5ejvWKSMzb2Z6a2haZAQ
         Ip6gQ/eaGExYmsfaxxHVfqPjYazmGTiFg2dwcKhtMcsHrYecAV5yGPRKaPgRZWI0OPod
         RvopV94VcUZTrckVBnzrXGek9f1B62fXKgIvzHwN01ae811C+LhhRTRIpLRF5M6q7fvt
         JB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786721763; x=1787326563;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        b=BtWkryiXUKGmsv53iP/DZWUJaQOdqHxhi3XDhmP3WgMoBrlJgjfRegytfrNzoqHp4U
         8wIk/Pcbm+8+nBVoGvo6+hGgoeVPohfpmHXr4xbPO2xJmDehdTAO0LT7lTvoJu0AX7KE
         HBu0A/HZkU2xhkk8xriI77zQVcFQ9hq98h9xE9J/j1nFIqggybWRHqndNysk37Ewxevj
         5d1uv2xBGa5qTg0PtH+ZAOKcZc/mJMXZ8TZp7KXr4SmpR9HIC/+ewZQ+c0FrWkp+SWjQ
         1LrP9PUz9OcHPD9VYjqqQvDd+3SdGdjsIPYA9sDA9zHKnmSxZ7IeJHu+qufKJu/bQnYd
         5F0Q==
X-Forwarded-Encrypted: i=1; AHgh+RooGSn4dah6MIV78c167y8oWvtugyhA49D4ndwqBurNOzUXYkRXT+NWM/LZYUeoLJaQ64GepWljfls/Ig==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi7AWWvZ7W3dLonbjnbE6yacbaEl8jVdsSITLubpXLUN1hPpmj
	PqeqRvmoshoJfVvD0PSonr0ie8LY+K6CxDvkCQFEOyhMX9AFhxdXuC1coh2ZPbSOSaFz22OroIy
	GC3EckumbvQzKykTP4sLOX+6FcILm5FI=
X-Gm-Gg: AR+sD13qc93aOsuYrHsdKlBFewbC5EZCMh60uP1Vhaxy1vMjG4Byww35lTYerAlBngx
	VF5HTOybOwTsNQa4JWX80JlCbDiOiu40ABb1ISJ2fo3q0EGy14cKtMBaBb64NtVEZ4VV1pxA2QV
	2cBnf0zEyAP1M4bZyzb0aeDMZ3Ivgp24XQaDVQbYjb0DqdBbG4gNB/M7KBPSqM2zeMm438Yve8S
	UWKjK8aOvQkypBg/qqK2oKhUXu2aGZGreCtIf5gwcHpfm2c0nYYjVPjpXDoapsxcv/ogf54oLi7
	LkupcJ0piXwyws8XRn2RK2FLCHjsdhmlrLUXP8FmubPztpEfoSt90VA=
X-Received: by 2002:a05:6820:150c:b0:6a1:47c8:c86 with SMTP id
 006d021491bc7-6b0d6139eaamr5716989eaf.10.1786721762684; Fri, 14 Aug 2026
 08:36:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785951556.git.coshi036@gmail.com>
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
From: Chris S <coshi036@gmail.com>
Date: Fri, 14 Aug 2026 11:35:48 -0400
X-Gm-Features: AUfX_mzYtb9BIJuMN8HL5w2k5Mt2S6D9ha7J2YgkZZzhpnVk4PtV6PYfTcDSSaI
Message-ID: <CACd_6n2pG1UO=e_zbySWNMm_3=btwstaPY9T3+2QR3C-dXhO2A@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] buffer: stop clearing BH_Uptodate when a write fails
To: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Content-Type: text/plain; charset="UTF-8"

Gentle ping. Please let me know if anything needs to be added or
changed. Thanks for reviewing.

Best,
Chao
