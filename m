Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD033F3
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126691; cv=none; b=bUGjrhO70w/BdXZ6gcsD2cSrOwsF3zZtgxKySI5eGgJcDu7LpXqBnOm6o/o0j4kjmUBANOfcldZSdgGl1oRAmWbmk7bE2ggKuU99X3I+j7HmIFgKyXAL6WcmaS8+1eaIpJ8v6JOXLk8ds7orlvh0kVNSNml5SBY9/EkNLt1/euU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126691; c=relaxed/simple;
	bh=znU5A+8VZXCo7Tt8b7kpt9R6DpphHbl1H0lXUcGjyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I8BWrc3Lr+4wgwhLiHot8Lryg+PsljedQ4zzXq9pm2ctTtfEXB+AtNEKdZJWK9Awq58gCymCXf6QSHUvIAV3soSIRYPXmqcYtTtn1rbIScR3CRoPf4FWBnsGJc1WrZbu+82VUIT5rrNvvtUAHoEdJU4Bkq3UQQU+lZ6BkZ2x0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B1jI3iGW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1jI3iGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730126688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=znU5A+8VZXCo7Tt8b7kpt9R6DpphHbl1H0lXUcGjyZk=;
	b=B1jI3iGWoe6e2MrvhiPs5AVftU0cAzOj50tDDPPJily0AbR0jsFaPLBEiKw4i40yp4QKaV
	RFKdqjw5QXJHpjOp45K3Zg3zVQvm+bIZp6Fdt9bKT8LhXs09mj+V+ZHKDdkre/NUYuisqr
	wVAHH39OnMRP8a6OaFGCpqmjy+txrgM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-k3-gyxwzMOGyeeuk_mTvTQ-1; Mon, 28 Oct 2024 10:44:47 -0400
X-MC-Unique: k3-gyxwzMOGyeeuk_mTvTQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4e86fb603so27332865ab.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 07:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730126687; x=1730731487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=znU5A+8VZXCo7Tt8b7kpt9R6DpphHbl1H0lXUcGjyZk=;
        b=pvh2zgBvIgMDMmdqulyTEN7JKuZMWdnryYqY+ZvO7OmXD/se5NI5Um5kaLzGxv7ovF
         YKPuIf2JtPMKMHFTjj4L9Z5xUnYzXasVLJ2OxyczJtbJC2Ynapsz/LGyOq9QejcnEQJJ
         951VAxP66LBUhPmmPUtG2evwWuoE/GKEHl7gWwYaE0r8qluk+v6maINtQnaRIWK2Ivm3
         hnovF3UTavNKVke/UqOmSbWmO4kNdmehkDSfHUt7caFDtBd3LbAYhzqBUFeiIbKlCWgV
         c95L7SlTtX+waXQpAcNQ4Xgr3ZNa+zxeSR7Uy5dQoGoBmkSZfOe57oRSfNzx/0+HAdU6
         zrBQ==
X-Gm-Message-State: AOJu0Ywel9MBvq8Gpq5+WTtigRan3DyriTRe4MecCJQcD3oYo+xIgBEC
	PtqOUyeg2/9U/BH0fPxJZz5XxiLW3E0gzJWspBKrlwO7glaGWQtNvzUGJWe7septdttB5Nu0GmX
	hl+3+L/oQSPN5lgX+c6QQQaEoDnFzZbBXXyKblOIOPDtuBgbbmyvJQcbpyQelE4Il4pZIJ9ixON
	nItEy7KzAEqlN6F+iM2ks056N7NGoaVl0K0SFQI4z+h6KHJQ==
X-Received: by 2002:a05:6e02:1a4e:b0:3a3:b4ec:b400 with SMTP id e9e14a558f8ab-3a4ed2df0f2mr83772025ab.17.1730126686978;
        Mon, 28 Oct 2024 07:44:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF87O8LsyZUwTn9FgOP3xZY1o145Wta1hlaECM+jAnXGlKB4BxGWkS1jcoc3kmurJb1Mo64aQ==
X-Received: by 2002:a05:6e02:1a4e:b0:3a3:b4ec:b400 with SMTP id e9e14a558f8ab-3a4ed2df0f2mr83771455ab.17.1730126686316;
        Mon, 28 Oct 2024 07:44:46 -0700 (PDT)
Received: from fedora-rawhide.sandeen.net ([65.128.110.20])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56c62sm16760705ab.56.2024.10.28.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 07:44:45 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	brauner@kernel.org
Subject: [RFC PATCH 0/2] ocfs2, dlmfs: convert to the new mount API
Date: Mon, 28 Oct 2024 09:41:13 -0500
Message-ID: <20241028144443.609151-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This has been tested to some degree with a local ocfs2 mount, but I am
not able to do a proper testing in a clustered environment. I have
confirmed that AFAICT, random combinations of valid and/or invalid mount
options on the local mount behave the same before and after these
changes.

(Just a side note: I had to omit "ro" mount testing, because simply
mounting a local ocfs2 filesystem as ro, then unmounting, panics the
kernel with or without these changes. I haven't looked into why.)

Any feedback greatly appreciated, thanks!

-Eric


