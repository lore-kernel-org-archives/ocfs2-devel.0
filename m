Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F613AF2
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721198676; cv=none; b=pM9gdyD/IHDcgHtzUAaTEec6YGgV7cesIg8a2VPNKmBzBI0Q64u6oU29VUxmh4EA9irN5iiOuGZ5E4PAWXR+hESAHvLwcJMhuuAOUgF/Or54LeiyMWkj6EHpIXum7nqVoJnm7V5sdgiWAHELc9Pcu+T2nOh1lDEtkLmJ3sl8674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721198676; c=relaxed/simple;
	bh=nKY9GdqqPL4ItFVQVruzZBovVQ73GZegyzIuZYmtIuY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BCq9xTxAikxBa6L8rrr0keTIKI39z0j00r1R99gAxgYvpFZuEOmfBfNfZQ4bDNSpFG9CLpdlB3xNkpDsct1xvnPEqcw2772cD1+s/PYe2Mc+J4aGD6y4J48tBU0hlb6RjQGYQPNHXjU2LgqAASEHZE6ATIPkkW9Qrimjs2xHJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJZm1oe6; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJZm1oe6"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2eeef45d865so32870921fa.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jul 2024 23:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721198672; x=1721803472; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ebv10443xM4d3fRRsimsjH7bWathIFQbxGPYegV5mB8=;
        b=UJZm1oe6K1SSc2SJwYMQYyNDNiDw7qTNL8/xDJx6ceOy9BP1THa+iH5N1INoy+0pve
         7yFD9wwJQvTbeyjgycwQrzz1BWV0CDHhOuaIsLHvzzt1f8+cImCzRzkHkyRX1lxmOOFW
         XTOwbgeqBXApKQ2CyXsiWTq55VS/vtDxV/rmoula1A+ly6QbEW1CfYCJhl5Gaj5AwaCM
         sNZngUGrvR6wbTTSK95q21K7f7BE3njxSq7fp9wzKzY1bXNC0qnaJ7m+1Uk7+bm1lynJ
         TF08spD//hzetqRCI0LF6fzJHgB69TCt0HaUsNjNs9SPCRpp+CWTbZSPW4pSiFAkOYJ2
         ojFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721198672; x=1721803472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebv10443xM4d3fRRsimsjH7bWathIFQbxGPYegV5mB8=;
        b=PHToE0oimWlf4Msd/MCyhPLwV44dzvy5r05hqvRRWo9m+C7WJZaEqTqFYTOpPklNSW
         YPFP2nuPBFYsQdz65aIAzFYSDDJ91tVT7XuqtYNMxMR+qrczk1S6pw75hMvtkp/rXE4p
         9qzbzIgsMzzct+eu52K8ncdiNt1pz2mU3OvhyPHZlpkmE9am8FDl9Rp/NqaBmJqrWwKW
         CaNnNabk0cZsljFuHcBn/1NJDXw1UPSf/0tvFhp7MjarmkLX+OwnNiZqMaKaeP1pwFx1
         vkrxE7CXxudfQpEhInG7JBJn2WAZR1jTapE2bDrmPWVjiaMhhbC63Wn4AZli9bUWC87d
         1EiA==
X-Forwarded-Encrypted: i=1; AJvYcCV0XsBMVLZtO8hEp99q0dkAUqUXOYFbHiQYC83ShDuSWqbw9SjYj4OwyFOjt87aXMrRuWTOhpY/U7pDYOxEbuTosZxlPynYu8wNjB0=
X-Gm-Message-State: AOJu0Yz9kJoNOu2UKSI27IhoS/OyTxT/DaNNLODGkiXe4hX5METIB0vX
	tv1gBhMKkZT/1D7kBap4vHH/vrNfnUPnAiYKH7Db6jC9IxuiFen+7i3W/5fTWZo=
X-Google-Smtp-Source: AGHT+IFq9KKyAxWdPxG6/w2zDWWEopfb5xZeXYhhsWqSfm2KeoyYrlyL1/Nen2W4UouF0qZbvsSaHA==
X-Received: by 2002:a2e:a496:0:b0:2ec:6639:1210 with SMTP id 38308e7fff4ca-2eefd04ac32mr5747181fa.8.1721198672374;
        Tue, 16 Jul 2024 23:44:32 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ec7d963sm7399486b3a.130.2024.07.16.23.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 23:44:31 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	glass.su@suse.com
Subject: [PATCH v1] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Wed, 17 Jul 2024 14:44:24 +0800
Message-Id: <20240717064424.11090-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bug has existed since the initial OCFS2 code. The code logic
in ocfs2_sync_local_to_main() is wrong, as it ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the
LA window size space on each umount command.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5df34561c551..0c45b139d9b9 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count && (start <= left)) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.35.3

