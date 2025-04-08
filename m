Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EE422ACF1
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Apr 2025 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125803; cv=none; b=alCBNotgDRYdZ2wOta0dKtJXjNgUdw8RQWFejLFT24cP4Cp1Ld1HdWCkGkU/AYPwXL7hUf9uXJZdOkSQGXYUHPheIBQ1RkfzplcJgZigQMb8wimXFezqD7aqTSl1TBXmzG8jRQVcI2M7eF7Q6feYqD5O/5lKJeteQI57x7Fic5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125803; c=relaxed/simple;
	bh=0NbGjHFA/Uw+XeBsmtArNxJmAVRgP2VG06NNVhzxbEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lvl7GnFNZeJtlUwmzI7QQmKIO7aCKJEBijVgU3SbpxqbrJE3SuxFz0MdbMNSvkiNGydqYt0Q/WB88UGg4RwN/inOkztqslYOrYDxpTErWC73xZmFRuKZwNou26vO4VI33UoiJYVVGtD33ueBZ7eD8IMOLXqzwPsHlxXLFGCvqvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y7L1je7F; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y7L1je7F"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3912622c9c0so563953f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 08 Apr 2025 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744125800; x=1744730600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bz+Bs3liGXitDac5fSoKdGCUlDiZD33IBG8oiYGkQEk=;
        b=Y7L1je7FMxh+7Ty4ucAePI6hcwprYWyBY6NhecGYBHk6aN+gVPy6KCm/tWbpe7AjWh
         zcll5q7HOgsW7zn3rIOZLsqXwfGrxm7+iWKR22p0/GWbBfgGRO+/BKjTZUNzP4co9Cqn
         BMlGMEYnEi7WYrXalA2CHeCFPkgWDqF2rtzUWfX8dD+Ap1K491JQ42elwQxVojQvrMMF
         PcKJACqZT7tRdZKqpX3c9TVgy348DCJz1pdcAye/J0D3/cr6HPdy9WVDSVpmtwehcBfW
         Ee2OH6NE67nbUxhpBv8BArtK1Bb17jbl5xfd8jRBTwgimDKkniJIJWcYctPl0UwV0GjE
         rn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744125800; x=1744730600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bz+Bs3liGXitDac5fSoKdGCUlDiZD33IBG8oiYGkQEk=;
        b=AvKt5FMENYhFAGIgZKzFsA/q53jRTgba/Pb7upq1WcYGRRdDIHdw+anKVMf3fziJ6a
         Hp52ZvTKrPfTTlyjWkU1mgSsZZlqwvjocJoG60BG0bbJRG4+MyWulRkvveIiCqVetQUM
         28Fb7CryfG580n0n6vuxjoIvr/g8pfUy0BFDuZucWSlYKOUYls246+aYLAMzH3BDiY8B
         BAdPUDOnaAn/ppugPRL1S+JJQ4V9O90ltD1r8UuIM4ClPeNv19Qy5gG61X+3UpTt1VF+
         vMzvuMNVmIAb4SQOVOEbR6i5xohfEcXGfskSKgqq6BR3LEEtkiWiS2HGJ+kGO5tVMYGQ
         P4Dg==
X-Forwarded-Encrypted: i=1; AJvYcCW0M0xQ/cprawfjrcIViR9zdbiakGME0qGNKQM9ZOM9P/yT3wEe2r79wWuX34zKf9VWNT7LdQHXzmri7A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwR6Lb2DPzGT8I9/3Xq2P0LQRI+gBeNbCyIgoTfCaytiwRJd4NH
	uwvEf+L4m5DTqYHum77FBj5fkzCJin5zSGCG4QMVHViyHoAvonqCXcN3fgt5rls=
X-Gm-Gg: ASbGncuEsSgGIjWHe6EaHWoOAZMonajRvGr3hQSR4S5s8Var/jQfdmUy/eje2UcRKBj
	AV9jSMC+LgRbHVU+8aUhRyn1TFMwWV7FbuCbrLqsFWUCAE+hwY0FvX7HkanBxbKctkQ7Ctok9BG
	Lm6C0m6HIoanl+fJi5MpaMkbEhMYhTlEZ6hunfm6Y33Xc92IJVTO64pDp3xQsi5eAEtrp1nWwSY
	i2KSYo3msqqfW42czFWKAoQxajY5O4UIVp5vI0DUcuNYP6Q5E2Fphz//JmZLvYB2MZM97TmLm5w
	KUfAKpnZcWFb8TmNAL8KWWAXzTUl0H7fBAp4TS3yEnlYbg==
X-Google-Smtp-Source: AGHT+IEz9HHlBEMjwmttz4NE6nz9WMJmIdm2e9g2AbIGCuNCiHrT1FJw1r1H3ZgrQAhiBTgM/eUf7g==
X-Received: by 2002:a5d:6d81:0:b0:38f:27d3:1b44 with SMTP id ffacd0b85a97d-39cb357b616mr4976593f8f.2.1744125800057;
        Tue, 08 Apr 2025 08:23:20 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9e9dc9dsm10990155b3a.96.2025.04.08.08.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:23:19 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH 0/1] ocfs2: fix discontig allocating issue
Date: Tue,  8 Apr 2025 23:23:04 +0800
Message-ID: <20250408152311.16196-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First, I submit a PR [1] for ocfs2-test package.

Then,
When running ocfs2-test, I found another issue about discontig
allocating extent. the previous patch [2] is not enough, so I
send this patch. And note, this patch code bases on [2].

[1]:
https://github.com/markfasheh/ocfs2-test/pull/21

[2]:
https://lore.kernel.org/ocfs2-devel/1f3049dc-5536-4a27-8768-b264be062f7c@linux.alibaba.com/T/#t

Heming Zhao (1):
  ocfs2: fix the issue with discontiguous allocation in the
    global_bitmap

 fs/ocfs2/suballoc.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

-- 
2.43.0

