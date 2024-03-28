Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5284656776
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614600; cv=none; b=QMY6zNjUcH5qYJErTwRTCjhv721MUzJUrGH933Ckp/KiCaSmD6rEZgXB9Fii4qfBYAIW4xQRfpW0l7GMrxWAg4CmXDWnmhDqnPk8bReNzanlLWOjRCF39mHFVblNPnK5nbtN9/1RRLvx/YzDJ9zq7rq0AgBxIRnOreuxjTwFIYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614600; c=relaxed/simple;
	bh=NSJFaOQ23bAK8tQpIJTgiSndKTRLSUaSWOl7vl3z9jI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBAHwXbT5W4biokjzekpiiT6kOsLawgi8ZM38/I7KZJNlIolPLcgUSH0LoDuvBG0pW4bnr91Q67L4G+C7KygogXgjFz3ghBejTrrX8x+/vnUXommuOj1rVhu1B3Yo0LL1S64270Lef484u1tlcSLh9Mg/FP7fPKvUISDv+vx8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bcjy0Sf2; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bcjy0Sf2"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d700beb6beso9033601fa.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711614596; x=1712219396; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waJHyZTwvpRtmdKk2tBHOXWq4ofdOGtQuc7yBZ7KBOU=;
        b=Bcjy0Sf2EmZ9Vp1OKuUEBmm+dXw6ZMXeY7ObxNlcorYx4w8zsE8VeVWHNnYtYuubB+
         jK8EDE4bwp73rfTExLvJCxyA3fcuanr9mH0WSTtIaufNIyzQa7q1nvfAXhZEcvUTl/mf
         ErHBqzlmHcHvX8GXoQ7jz8NW8Y1UPIQTeZVLbnoXMIwsDpdY0TevkRkIQQ7y+jJP1izO
         99Hny02v4+3XiniYGCsxbyL+qPn7y+5VpfhODybimRd+I6K2V5W98Q8NrPWnG1VjgcUp
         BTNDbuXjHsKKIOU3T2JIFw+KhD5YGVPYzw12S+FAvKHJex9+AsAca7L5i08utzANNNwT
         kIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711614596; x=1712219396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waJHyZTwvpRtmdKk2tBHOXWq4ofdOGtQuc7yBZ7KBOU=;
        b=D0MUx/xjk2HuaxzhzyJEWXI0tWN/inrukYhMWagf33NZBnrwSZzT1RtewymIbdGGOm
         FjCdw0uT4AA+fEfK6EQmJcJ6h4cRACrxF1XIy99jdlg15igJcHEyxijfbIkswfi5hdzL
         x37pJARi90Z9ejOJlBHjQI6+y1+lRppeslITNn8BLv2wcIGdpT1CiKz9gcIW/vgg7/iZ
         ljgVJOSBK6vFVZLNmZwgqqFKAfZpn27Qv7REIKqCGvX7omXSyijmEh9N0FAzS++CZjNG
         OiYkCYFREp9k2k4ydi2E/SdUQYO2tYStf0hdGwUTk3jqqh5e0xtFdaMjFEw6DaHWe8DV
         1a7A==
X-Forwarded-Encrypted: i=1; AJvYcCWQpWf/LlM/jE470D+sJr7swDpX74aBIZiKpzJALp4TQo9e81pQEtQMMfVWPnZERPo3x7i6ysJg4h/oR0B6hE98Me1j4826WHOpYSc=
X-Gm-Message-State: AOJu0YxkP++Gi2vaKtJQygILIKEGIeKpWJcs1HkEIa56DuG2v7L6hpVo
	LkTFSp4wm7sKytDlBQJ4Z7i9zQ7kf2RdIhpYHjYsNKImPwy0fs//ZVNJXchm2pM=
X-Google-Smtp-Source: AGHT+IFTw7b1lMM1rlh8W/coW+7xfjLx8gsmXaKNuzggc8k/cw/1+8ISkwjRYyUWauwUl+1qOAgzXQ==
X-Received: by 2002:a2e:8913:0:b0:2d6:a1f7:2a12 with SMTP id d19-20020a2e8913000000b002d6a1f72a12mr1512898lji.38.1711614596541;
        Thu, 28 Mar 2024 01:29:56 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b001e014627baasm955120plk.79.2024.03.28.01.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 01:29:55 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v5 3/4] ocfs2: speed up chain-list searching
Date: Thu, 28 Mar 2024 16:29:42 +0800
Message-Id: <20240328082943.20251-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328082943.20251-1-heming.zhao@suse.com>
References: <20240328082943.20251-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add short-circuit code to speed up searching

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v5: 
- split 'sparse warnings' fix to a separate patch
- amend the commit log according to patch change

v4: first version
---
 fs/ocfs2/suballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index fc80cb3dbcd1..823e2ec38b2d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2008,7 +2008,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
-- 
2.35.3

