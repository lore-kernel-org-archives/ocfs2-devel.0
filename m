Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3B3DC861
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 07:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785916593; cv=none; b=GqSESUn6REu06hro8jc/SKPVyfUFMRKmgcyYel14Uc7EG1vOvcpztjgNPKYO1A9vnS9ks3yGwsiz5HyPnifBkKYKkFNOZ9sAfaiXmjkqAihR1Bx4UA2gXthwGvktV3RWo3z8QTz6EaHb6ymFh7jNeADqymyuqCKBW/w4p+pl2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785916593; c=relaxed/simple;
	bh=1tsZOP1cJe1vBjHWkYNRr+dqkrAkT4Whnc/9jiAlbZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdCtPVG63uj8z/UdEHH4GsbCmb62r9E2BwKsHTzUnq6E5OqOBEWC2cfA0eDHGDQ7Cq9l8c/qQc38rff0mFiGcS9xqIkkzt7XrQtHCNm3lG9CsjngT3FhZpxHZvyjscjU+eYkMvwqZl/Gz+cQRB2OVtVOBFbI5Q38+G02ObTFCaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESR8vysA; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESR8vysA"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso782991a91.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 00:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785916591; x=1786521391; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0WUaISw6qk3Jf0zcCDZtifF5pf/akYlS+Jfhu1wJBuI=;
        b=ESR8vysAsof4jPS0yh5bZoT6ifxMpwy1Xoa49ocX93WTv6LRxPW90qUEIwGUe2pMq9
         qHCMbjwpxl0VVwLgDYyn9GpXCsSjEqzTRo0Iu4Uq2qDuvfqkk/iSKBufcrnCwDaT3wPd
         YbBO2gOkttACPzcp/6Q6R8ZYCPdKVfCC5jgsGHb8TiZguQckCWpq4m7aLhRitROZaXG1
         jNZHiN0o6+STWGmZFSVzoJpLu2xRJ72QvZNMLYcKbYTpQ62s/jOqNX4mhlNX38b1cMw/
         IYWiVu2XbQlIA0OlA45C6yejy7MDpAWCjIa6yspQl0ZZXDUNsfizjOd0tyhiskJluJRX
         uh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785916591; x=1786521391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0WUaISw6qk3Jf0zcCDZtifF5pf/akYlS+Jfhu1wJBuI=;
        b=P9q1dd0pubzArdsge0FX3PtwUb8L6LH3o7fMQKqzdFGaLH5cn4pHid/i1vE5q0QAat
         jBS/urcl6NedTe7SfDnYDtn2zjkO0FlJ3oxuxPJK9EEc7dIsOa83f29UC1YjmaLPt4Ob
         /orXZ0R+IpKSabFYfTmmQEtx2AAOftAcy6PJBgl7LMW41uTYuta+1Ir0mRyPwum2KV+U
         MHf2AW2GmZmVHu4rVdUoFJXHAPEpGYx0QJfO6tATBQxEU4ip179szwuNw/1jOlllKLxb
         MM7bBJ2QHKPkfPr2jqwitnA/txhtV/+jWYlQLALpF002jkO9nv4mBIyp78GKPs7nVNGA
         wizQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpj+mA7ItNSjS1eVYGUn+SptHShhuKmG+Bycta7eqJosJXZk2tNqwjeM48LwHG5+aYYGb4Ouicouc+I8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTJ++WJadsj/oEsvyx9YIOuX/MwbM5r8uVJZaNjiJaSlaFXvMv
	XYdeVbr9JLIpdf0q8V4UTzPOfv6d4IeADIguu/S3NNdKzly7t7gSA/TZ
X-Gm-Gg: AR+sD11lP0H4ymS14XtIFF/XnZZzHkYfUvYQd/Nt43fB7Ud8zuP1NGICRmLFCMHNeGf
	GfQlQxiDKVNljcCzt7af9l3mHQ5//hcCQgtaEBJlzK2r0+TdOZK4vihcvy+yhZTe+KBPS8jEmPR
	tdglHheNVMsp4813VmUdmfMn+LLW7GUdKeVMjiDG17QNYxLyg2ibCN3O8xq7unpU2rto8m1FxbE
	T4KwIHDfSsb4MNIcGf3MOnd135wG9Mizaj3SfCs3Ci8uoFTEtYGMexSU31Y9pEWJEstcBDH98UG
	UBi5ZgBhAjz8kLLcUDqvJUW568F8F7V9VSKT8aT0h/Jas68SYbC8OhZXdeeQykBjC96FlvYwz+o
	NpJoyjhEuW/M+7RZzIFSApgnWi06dOBU2q7NzBB06vbDcM90gekPnE0F+hzwqwwNGtcaYy03lTp
	pedL6SLN7ymuyDNSLrNFDEKRK0MpktnoVkQfeeGaDgdPxTjX7X9ZytuHrchUqgZ1axfFohFn+By
	8VgODxUHBY6N9ZHnYyhXJtIUP3rLFgB2b7mdCBNNkMKwB4JytXBlpBCIqd3pVTwwndK66cD8YAB
	j8+pNAWg7ktmDKYvxY7XXurrhKtNMyEnmZyTUHKOvS79am2qa5Ow
X-Received: by 2002:a17:90b:17cc:b0:387:d5bd:622f with SMTP id 98e67ed59e1d1-3903c6fce95mr2091676a91.18.1785916591024;
        Wed, 05 Aug 2026 00:56:31 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febffb2ecsm3770582a91.8.2026.08.05.00.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:56:30 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	glass.su@suse.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix cached cluster count after suballocator reclaim
Date: Wed,  5 Aug 2026 15:56:25 +0800
Message-ID: <20260805075625.3518094-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anLkDGTDDzVDMijK@p15>
References: <20260805070837.3390148-1-matthias.goergens@gmail.com> <anLkDGTDDzVDMijK@p15>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Heming,

On Wed, Aug 05, 2026 at 03:38:05PM +0800, Heming Zhao wrote:
> Could you share your test case, I want to reproduce the issue and verify the
> fix.

Sure.  The test runs in a QEMU guest on a snapshot-only virtio disk (the
host image is never modified).  The image is a clean 256 MiB single-node
local OCFS2 filesystem made with ocfs2-tools 1.8.9:

    truncate --size=256M accounting.ocfs2
    mkfs.ocfs2 -F -N 1 -M local accounting.ocfs2

The guest runs the small program below: mount with
heartbeat=none,localflocks, create 10,000 empty files, sync, then unlink
them all, sync.  That drives four suballocator reclaims on this image.

To observe the accounting I used a temporary diagnostic, added immediately
after the ip_clusters update in _ocfs2_reclaim_suballoc_to_main() (not part
of the submitted patch):

    pr_warn("OCFS2_RECLAIM_ACCOUNTING old=%u disk=%u cache=%u cpg=%u\n",
            tmp_used, le32_to_cpu(fe->i_clusters),
            OCFS2_I(alloc_inode)->ip_clusters, le16_to_cpu(cl->cl_cpg));

On the stock kernel the first reclaim already leaves the cache at 512
while the disk holds 2048, and later reclaims underflow the cache.  With
the patch the cache matches the disk at every reclaim: 2048, 1536, 1024,
512.

The guest reproducer (statically linked, run as init in a minimal
initramfs):

    #define _GNU_SOURCE

    #include <errno.h>
    #include <fcntl.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/mount.h>
    #include <sys/stat.h>
    #include <unistd.h>

    #define FILE_LIMIT 10000

    int main(void)
    {
        int created = 0;

        if (mkdir("/mnt", 0777) && errno != EEXIST) {
            perror("mkdir /mnt");
            return 1;
        }
        if (mount("/dev/vda", "/mnt", "ocfs2", MS_NODIRATIME,
                  "heartbeat=none,localflocks")) {
            perror("mount /dev/vda");
            return 1;
        }
        if (chdir("/mnt")) {
            perror("chdir /mnt");
            return 1;
        }

        puts("ACCOUNTING_TEST: mounted; creating files");
        for (int i = 0; i < FILE_LIMIT; i++) {
            char path[32];
            int fd;

            snprintf(path, sizeof(path), "inode-%05d", i);
            fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
            if (fd < 0) {
                printf("ACCOUNTING_TEST: create failed at %d: %s\n",
                       i, strerror(errno));
                break;
            }
            close(fd);
            created++;
        }
        sync();

        printf("ACCOUNTING_TEST: unlinking %d files\n", created);
        for (int i = created - 1; i >= 0; i--) {
            char path[32];

            snprintf(path, sizeof(path), "inode-%05d", i);
            if (unlink(path)) {
                printf("ACCOUNTING_TEST: unlink failed at %d: %s\n",
                       i, strerror(errno));
                return 1;
            }
        }
        sync();
        puts("ACCOUNTING_TEST: complete");
        return 0;
    }

I also have the full harness (image builder, initramfs builder, QEMU
runner with a log-checking mode) if you want it; happy to post it or send
it privately.

Thanks,
Matthias
