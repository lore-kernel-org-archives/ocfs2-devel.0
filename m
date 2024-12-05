Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389622391A1
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 10:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395725; cv=none; b=eVQ/H6h6I820qvioRFUO8/jI6DxeImvYhe8BIKd0/B9F8E05eZljrI4i60fcQdHqiPJtRm22kWqC6DiPPniDgUUhi2ae/6v6ADhrLA5wIStGSWAInbPGOX+f/7dGCc2SldnGaDSiS4A2nR4kjfGhQq4Tx4Vf4Bu0lYxhuOX38i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395725; c=relaxed/simple;
	bh=EeduxSC3p2WPRVniwtpk/GgThtx5SbP6VMRHMxe1Zb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qXw8kUW4uez5/7npekMlF5exVWtV3V+DecNMbnZNdfSsf54h55yUXW8yJfqJ6ouEUXAQFVAplBxmCRTqMKSLMiIHByN5iA58ufy0v+sPzzJ7HUnE5v5V9MtGub6gZw++cD4zTvE9Kgjrk8Nl6iTuTsWDUu67UfMvQRsI8s2/YE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OhtQVxjJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OhtQVxjJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385df6d7493so21047f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 05 Dec 2024 02:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733395721; x=1734000521; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gwGN4mLWP7rXlc3slo/VflI3K7kQURVq4K38ALW1H3E=;
        b=OhtQVxjJTIPx5VKOOiqQ/GnjAGulwXVYA8kjDjTbhgBNZepNPeXiMt8sIA2BSR81sr
         qYTpIHkUJOk4cmso0K10WvtrjqWDye6RjhpS3MR7xa5m+H5l8vAMZs7cgJkXLRa1tKSQ
         rJQbLRJUn3cpb0S5eXi8Xbfe+flLaueCEHvgs5LPJOVZvMl/1XfVos77Y0VdQi6VUwMn
         O3HNQU6Ao3SuZMRyf1E7+T41lAqM2bVReYAKG8CY2A56Z7up/CD1eprT7+uxJpNqUqu9
         xw25WFju01yOW9mDnmSDhwsQTYDy3NgoUvFjGOwJB2dBtFY5ulTKESXvz9cpfEj/Zkpd
         Y/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733395721; x=1734000521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwGN4mLWP7rXlc3slo/VflI3K7kQURVq4K38ALW1H3E=;
        b=mikCw5Z52VotRo8l7MT5yQgYxWgk6KGdtOgmjROVK73PhjXDHVyQw3Ty9kZ9PCdMZs
         uIAERSRsuq48bAbIQY6IjXnsNdiWhcALlCAjcMryvQLa65jBH8oA/BPgEo4lOn44Kx83
         dhMesrM85BR/Bbkd04V7jdxXjR/p3JDxpG6erZu95pOJKa3MagJmwT2xE10xPll7CXnX
         G0wbTLg/1FJaBD4DIFcA2hpVkgzBU1rCMt8/6J1flwzq+Oe1HO385OGW9zEhqiQtNTdj
         EtdKL7gWib47mbY/0dE58ySoPQzNxWNUmYCxapFSUWZxk+AJ5GArpSCJZma2ww3nirrj
         dUvw==
X-Forwarded-Encrypted: i=1; AJvYcCU/BPnmMMSmschtaTF+50Jj/qms9ykRC6KK3i8JarGV8bo+ci1R79jL4nKFSgUtNkgoAPgXfZEqbyaCMg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ1ZKQGt/AdSIkYd1E5HyUMdx8C3xFArwRWPWOH9IhUoJpj1aU
	SzqX19RNY8HRLdiycN/LTMwqqaDNn3UeZ2hMPJWB652yb4xLp6PJv8elfS2hKGA=
X-Gm-Gg: ASbGnctMQ5VhYU4lp95Z9PI2GjvtVOBmv9uyQIzJjFO49K3AC8hMt9YqH0JsxZeJ+9L
	dcPjHtpbOWSgEpOOGcYT9bt/i9Zxv1955nd+l0xdPzdSjUbeCIVFVbI/ecdB/LCjNyt8ZFj8OY5
	sFflAtFhN6AYQfiozv1KDYyXZ1qENuSdQ6U+0EQfRtoGrXQLy77UqP0eq4KQF4NgV8ISFrNjFrn
	0mESNVo5wpjzLO6tw118MwC7shcS3Gp4gGIOPjEm9P7h8g99xpgy5giCjcUp4ZK
X-Google-Smtp-Source: AGHT+IHjqgkJp7AQ470kPy21BVG4bwS2VTM8RP2jGp8BDGX3K9R+8RFbhvLubHU0utP1L0Hl1oZhyw==
X-Received: by 2002:a05:6000:4008:b0:385:f72a:a3b1 with SMTP id ffacd0b85a97d-385fd3ce97emr3064092f8f.4.1733395721483;
        Thu, 05 Dec 2024 02:48:41 -0800 (PST)
Received: from localhost.localdomain ([114.254.73.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef4600d14fsm1081629a91.45.2024.12.05.02.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 02:48:40 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Revert ocfs2 commit dfe6c5692fb5 and provide a new fix
Date: Thu,  5 Dec 2024 18:48:31 +0800
Message-ID: <20241205104835.18223-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SUSE QA team detected a mistake in my commit dfe6c5692fb5 ("ocfs2: fix
the la space leak when unmounting an ocfs2 volume"). I am very sorry for
my error. (If my eyes are correct) From the mailling list mails, this
patch shouldn't be applied to 4.19 5.4 5.10 5.15 6.1 6.6, and these
branches should perform a revert operation.

Reason for revert:
In commit dfe6c5692fb5, I mistakenly wrote: "This bug has existed since
the initial OCFS2 code.". The statement is wrong. The correct
introduction commit is 30dd3478c3cd. IOW, if the branch doesn't include
30dd3478c3cd, dfe6c5692fb5 should also not be included.

Changes in v2:
- revise the both commit logs
- following Joseph Qi's suggestion, apply patch [2/2] using more concise code.

Heming Zhao (2):
  ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2
    volume"
  ocfs2: fix the space leak in LA when releasing LA

 fs/ocfs2/localalloc.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

-- 
2.43.0

