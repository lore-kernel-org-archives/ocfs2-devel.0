Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A0637EFF3
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621691; cv=none; b=OpsFwN+atXWdCL6mfnJNKXpMsneulNTSZ5UYpoYcbBTTwFWVvOZ3DvNke5lK5zMOrPZm6Ime5b+GXy6mlzpRL1rWRxauWlTY0RTb0AocFZ8nyw1pjsMDWT16InzXwBpSMHlLWB96NU2vhO5ki9LpiZ/3P+GCYt7hzViliYNgfNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621691; c=relaxed/simple;
	bh=8eaNHjlxdd2m/7vaM8HHzpWZ1ndxEHRbTTCO2KCwplQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esaNEs4RhpFn5l7gRjDIUazTygpGGebYBcfemCjV1znInrEHHU+B6XSmGHZex1jR8vIy126qQbfOzhvn+zcJrfUucGvfqD80oNB+62wWwi/T8nDjBJ1m5d2iq1EFLShlLFRS4zpgD3U565JJknD7aX8FlYM7cRHCU92DSG+ZkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IxeRteRz; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IxeRteRz"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80cebd41372so32695787b3.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621686; x=1786226486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pK8MlUvCqFzPv9m7RxaKBOJ8dELfs23G8cRNXDTowI=;
        b=IxeRteRzuvDRh6EaNFcvv7wOvyGKQbdN+6K+NyZ979d82C24Cy+DN3uSks2h7Snv/v
         rtu5xSHGIW4Pyes/sVRJLUjZ0kSeE0bZ5E86Kn7DsOT5/OT+wWeWP0GddvLbKS7MMY65
         nvwsQGPKsvKBLYFk7lMc1qkim2n8e2NeBrnidle3GB/TqVpu8/4MuGisMCCbGyws38SJ
         fjTTyWCRPldNxaG4tbJQzDDioRcUWrF7CNUaowKu4WnQRaYZA+KAyPebw8ZO71apwCeQ
         nM3c9nX8ucljRRdgyEWYNuEoCcYCSmP4nU3SGsL/8FenAvRTBjmjLoAV1z81krsx1p6S
         7zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621686; x=1786226486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3pK8MlUvCqFzPv9m7RxaKBOJ8dELfs23G8cRNXDTowI=;
        b=PjeN3n5EQooUICL4v41dZDQBCKLPrTsUHgmSk+3Wqf/A535wGXeIQm5+Kbyg1Lerae
         E4Lf8Pqp3UTOzPTos0in/rI6ruId9Dvt4WbpLYokvsMF4I/VIklfb3jpXTd2Nio/XYX4
         pnLDT+VWfW5x2/Vj1B6m62pxwrWlS/LoIuH9nqvL+xzVLP3gzEkf04ldZc1BMbq7ZGHE
         YpjhObptQXLloJvcDMgmoVR6jiMSeKGySt0pGH8dCmNX07R+voO6mZXU3Eebjo/Ck8m6
         orj9z88lXbJzDigBxpic2t0OHQ0iLwpB41erMxWb9oZ+JQ/yXwZPPS9Ig6nP4nEu4cS6
         yb6Q==
X-Forwarded-Encrypted: i=1; AHgh+RpeavzaV7szNnukcqpXNYm2A/+RsYK1tUwehNetGWOaJciAPsPUsb7REt6b2HXAUebgoSgjQgT59ftroA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwMm7gv9wBjpO7yuD9ipj4UBEr/zkLmWtLlHIqebvq5nEjd4pe/
	DT3SLiMPDNHPkHzpH6bJVgaxNPvassfjxbsBbP647EZAdg1DfeJR5Br5
X-Gm-Gg: AR+sD103jJoIsn2LKQ5iDFXXPdrgnc8nySPvkjPLZGeDIMREQ3Du4UdMjpuG0iFK6fH
	q9whYk1OA3aDIldyKPwTvw3ULsvrUCX7zZpxR0hFFqrSox31Sl9EsY8ydBVRSXRXaC4symfLbXE
	Xr4H7giTYLLlGBJDWvh926LwInrEHt8ed7MZQu3cSAZztD6FpEci8IHhrYO7r9aOnxePfvZ29GA
	tyBOeiOP5MHZameeAhwClI1twa5zqvj02jf6kxP/QuZObs3Ibq7DkdTKM5EmHoPpCEdYbIagP+n
	WlkoX68s2FnsAg9iiS6g++KLf9gL9YqCW0ov2pKcq4EyTY9haNsvMo4+q9to9DFhL1WYdGXmPGg
	RDvLpEdctBBhZEX6LXqqLFRP4gKpCNbqVv2rHw0z+0wUFrkT7TVxd2x/G1/jxjD2e862XQGxj2A
	dUp6hFnmkTeW+pp6W5HE/YdNAC45XNJhlra1gR0fx3+8/Mz7ILNtPf9Zb7GPQ9AKKUkwg1jLey6
	WtBmMM=
X-Received: by 2002:a05:690c:6f10:b0:80e:5236:b930 with SMTP id 00721157ae682-81fd4c9064cmr74857937b3.36.1785621685651;
        Sat, 01 Aug 2026 15:01:25 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:24 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 11/19] fat: check for a metadata write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:55 -0400
Message-ID: <202c109fe73ff6899235aab9dc19ba15eeda0d5d.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fat_sync_bhs() waits for the writes it issued and then tests
!buffer_uptodate() to find the ones that failed.  That relies on the write
completion handler clearing BH_Uptodate on error, which this series
removes: a buffer whose write failed still holds the data the filesystem
asked to be written, so declaring it not up to date is wrong and makes
callers re-read it.

Test BH_Write_EIO, which is what the completion handler sets and what this
code actually wants to know.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/fat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index be18f6b5819b..4a4cd0111e47 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -356,7 +356,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

