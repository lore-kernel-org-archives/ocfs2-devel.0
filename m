Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660130;
	b=0Uq+M2dAhEo60lZJZmaCMyjgSmX5pD4BHLBgV1Nd/L5tILbB3xGOdIcKInzItOvp2oQp
	 VnEMu4Lz7jBIQhyG+y8LmeXt3P8FUAmZxhy83/pqwuI1a8HRfxHKq//FiOvVlo2Ej7Yhc
	 VS/qRAiHxGoWY9Wc4Fi5mco3N/sMH40ghfmu7OgUvYseHdNa5M5SFoNoTtKRcgp0CpyQg
	 9BX8pTUKMswmdBNp5WaWF1DunelFCjBYDhUE/3VOGQYe+zcDSzZqsj9eRkW71grff0lU8
	 KXMQMJMXDzptJuPF34q9SX8k03q6/UVqWGl59URsZYBoEG2Yk7N+VDTy3V/pS4WfYSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660130;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RLwjd0wA/MWjFh1zhTci1SLIdCeLzV5/hu4CPoq8FCY=;
	b=sr/oIVxtuQPLc7/n2EPPeHc+lUzpP75S+d8H+zmsO+Cdk9NACzipu2wd8YLasV0brAey
	 2p3RAEw1X2G/e+vaQJ++HioeQHKFeYPRRv7onNevIaC8nAu2w3fGuNNrvgBghSz9+UiJE
	 /hzear2G4ZFU+jzyYlUaQCFGbZFWerohzEJ1ggFoSnuSvPar48eAOBjCR4xye0GILrvcV
	 335bplNeBjAved8bmiQkHmqkQwrMw/OW377TYuPCiaDWZlhEfYxZWnA7rIemM56REqQyM
	 ltoLN1eKG/MHeQ07Khj82ds1s4L24sbA37ZdqqUJKL98t8EDT1beCOD10Jyy3YS1VEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iG2eVTBB;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0039606A31B
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0039606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iG2eVTBB
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso952404a91.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660129; x=1793264929; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RLwjd0wA/MWjFh1zhTci1SLIdCeLzV5/hu4CPoq8FCY=;
        b=iG2eVTBBkawuuuZJl4bRxitSMQ5uo9TMf5AMsiJMeQwm5CijVdiT25JvtTpvq6ATyP
         9AjGkIaLnYVurmPlI1nxrqAvRScRtegTU9BFlNHdf18O816+pY1FX60GfdLR3ciPJ6HF
         bmdQI0bZHQt6v5P0EV3y8GxsBJx6xczptD7m3gDttBmqSNzSW77tPnwdzjnLWjq1BWPK
         NDWR/Dyr402T85w1GuIQqNUl0I64StXhN0bEMT+7cj0DeMWuH2xPxpLPxwo9eq53mi4O
         MzsmNm70nAfp3I3P3ai7qzRZR/oULTP2jOp/scTiZgYe12NYa5l4jIAh/7xhJQFFvjmQ
         e9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660129; x=1793264929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RLwjd0wA/MWjFh1zhTci1SLIdCeLzV5/hu4CPoq8FCY=;
        b=A+yG2QrpJiPX7yw/Iw2C0VztIqKTCK7A9PBJclVe14BVW5jyl2yWw/OVUP02d4E00g
         MEHh54T0wnmFYrp+Iz6di2XLGwCWfQAoQMX4002basM+EReym2Wvho4p8czO0niRpUqX
         35k9YZZiNjA9cKwefjwoMdX227Gf87rqf297hqz3m3wcrBqJGtfmXbSdinqde4usYh9P
         UEVOEevOu/5eK3+iYC0XqhqKsFGi8SUQr2/aANoKBZg4WXiFaAB4HfQ77xCdBCFMRPfH
         T2ZAfp3X+sXiAznxGY6WV31i4CQ0onWItwyVTkItuSn2K5NX09laUCujX+ng9Y6fNCYQ
         Zhug==
X-Forwarded-Encrypted: i=1; AKwUvByGP9Ll3nZ1o64QQOZ3OQUR48xZ3mGhNh8GqNEBaQisCyhFyCFmvA9XTCaU7EAgLVmkXxdNEpNBLwp7JA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJmuWl4i7sxwmLaHexKJ8tVj2ypnByaQH39MDytGixjIgydBxO6
	qWH99Fcn8oLUOOfmr5OSaiRiuD6J6OGjVQOeRSWAG+mMV5uv2XVg298V
X-Gm-Gg: AYBFou35xk4sw+RiMs1eMmFFVvslD+vTV83nfnva5XTpAMiWNMm02xyVhTSxLJUVIAV
	eL12K67OAA6QSD87UFGPxX8mRDc+64Xvjx6+n2lYD5eiJr0h2lmaN+GhRVuK9jDxZx+mnyWi9D4
	njlG9eVl05S8+MtJZNKgBo+sitOJv9JJd7c/bheteXovmPW31phdDtj4bniVildYR0aOIc2yp3Q
	pbFw8mOzh9StNbga2zOqtWwE3hu+R71AXPVxT9MQmbpYluDUZV0sOcQ/GcXb9gDc/O6Dl2WIhBg
	puKbekDs+E6NK/vWLJEdwXky9jw6w2oJQLmRT8K5CHSxi5+cSt00LvKyd+qOC4TD3DfdYIE3wjj
	NdZdceL+WcNH7OcgS2NuIcvWjtnl32aCFSa8/yYsIbm0njGb3qD8U/MCd9/EdLbKpkA1U0n5SAG
	v913uAa3GmEe2f0whrIAvwQUjbS06dd7ZlsNww6OQgqMZykCCl2yvV33XcM33hp/A4gmS9Yui+p
	SwHJJGakPY/r+6XQh9UWjAAxjLPrB885Y7pYZgr2nZedhyNwQ4=
X-Received: by 2002:a17:90b:1b0e:b0:3ac:a993:5b5c with SMTP id 98e67ed59e1d1-3ad86afc038mr4100221a91.6.1792660129150;
        Thu, 22 Oct 2026 02:08:49 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490c096sm3325111a91.7.2026.10.22.02.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:08:48 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v4 0/2] ocfs2: stabilize dentry names in file and setattr traces
Date: Thu, 22 Oct 2026 17:08:40 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Snapshot names at all six users of ocfs2__file_ops and at the separate
setattr event. Patch 1 handles the five ordinary file-operation callers
and setattr. Patch 2 handles release separately to preserve its locked
open-count sample and take the snapshot outside that critical section.

The release explanation distinguishes its existing RCU lifetime coverage
from name/length consistency. It does not claim that the ordinary
callers' external-name UAF interleaving crosses the held inode spinlock.
The release source change is unchanged from v3.

Patch 1 also removes the read callback's redundant NULL-inode check.
The two patches apply independently and leave trace formats unchanged.

Cen Zhang (2):
  ocfs2: snapshot dentry names in file and setattr traces
  ocfs2: snapshot the dentry name while tracing file release

 fs/ocfs2/file.c | 118 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 41 deletions(-)

---
Changes in v4:
- Add a name snapshot to the separate setattr event, including the
  same-directory source-directory rename case missed in v3.
- Remove the redundant NULL-inode check from ocfs2_file_read_iter().
- Clarify that release can select external names but its held spinlock
  already delays their RCU reclamation; retain the inline-name/name-length
  consistency rationale and the unchanged release source fix.

Changes in v3:
- Cover all six ocfs2__file_ops call sites with two patches, grouping open,
  fsync, read, write and splice-read and handling release separately.
- For release, keep the trace and open-count sample under oi->ip_lock while
  taking and releasing the snapshot outside that lock; cache the
  event-enabled check.

Changes in v2:
- Replace d_lock around the tracepoint with a dentry name snapshot so trace
  callbacks run without the caller holding the dentry lock.
- Pass both the name and its length from the snapshot; keep the event
  enabled check and release the snapshot after the trace call.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v3-d628f98bfcb6784a0bfb@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v4-a9a0df898afb4fc65fa0@gmail.com
Link to v3: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com
