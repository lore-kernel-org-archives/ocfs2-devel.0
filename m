Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C44DF4A0
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449067; cv=none; b=pX4Z7HxuVvGv+EShdMquVnjEGlqjU7P+QPQTyIZD10T3D95Kp1zL/SmZbYEeU7JCN3dBJYaxvxDp8feNmRuJAFnv3NqZvt+OEml7LoxCm7cqMV9mqiYMDgE9ycS1E6LppjUtQdGn57Omb8mFZSqQ1zVHPQH3VMPpOxrQTtG40vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449067; c=relaxed/simple;
	bh=hiRQlPpIGglFRXty3EYqUEUerglqeZb/X1JgjZonIb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Coj4pwEdht4wUHBkODiooLAvIsQ3iWnUnFJ0dWwDuMvxByz1TYBaL762dM03y9DNxFc+SjxbBXjwJJ8Qzz4Ah+88LQyVgX/yKdXgRdLOwCyEZVx/stOlWmC18dSG/e1XXPIRwybMYo3XRpKQTIUEj06OZv1NHgO3YB2as8W04HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iciyZ1Je; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iciyZ1Je"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499c0879d51so1849255e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Sep 2026 08:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449064; x=1789053864; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKRvoFT0iXNtYocSHfeIp3eZzwJLnARoSnyrks3zVww=;
        b=iciyZ1JeQsCBcWoJ4q2tY/jpTgvPsuZ4PK3fLyqESukuKEWb4XNPCpdhYHoQJjGUB2
         GPUxapjthSfJBl7Qv2s2vbLguqhFwLYgSw156toE5VKRpBqqUjYSIQCLojZv7nskw8ku
         tKhUGnEbHcvCKP1nfjd3keQpjLWHJ4b+3pNZf+y7rrOl9jpFEvHY/Zz43UKTPbhdtv58
         2c3j7+cQ+NaU40XvVuhiLtWw596V7B/EsISJ93RPyCrCqWngiMk5k5MGkVkVYaF3SsOT
         6ZdGZTSkRVuKKKbqAlX/wmneYpLLiKtjFhvK+Kv42NUF25IHogAG+cs/vrNAQTXBxWwS
         DILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449064; x=1789053864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKRvoFT0iXNtYocSHfeIp3eZzwJLnARoSnyrks3zVww=;
        b=FEjodBK5YAwXd4oKFX3IqQtaefRV7W84fI4hMPD0+DifpL3EVItwUzX8l1VEjEeqPS
         b7jNvG7UrajtVJRVNM4Tce7FREaX5vetY1/lXnIPqR9o6Az/qqQr0bIFGPSioo5P707r
         QuHPY1+VQfs4JoU9M2VPNmD8BGatvJXQaaVQMJxP8GqTWI7oGZPsdcH3bfnYrmxIaWpk
         ygW5xbfwn36ItZGSXeJ2hccvyoQ0ZEV4NVtnYrZ3gfB/SuAArM5mtn7s3Vc06zAfLcpF
         Sqrb9SHW0TKaBiJTxN5pVna5CQdZK9FS7HE2FOVoRxaQYJFEfKZtKIk8ZUrqu5K/qfc0
         qCOQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTuXUyuoxw80TF0ut1auoM9RVTr1Nqo1/BaDzlrskLywIwQTQk5vs88t+bKyzm/94ZjB/CbhnA3lW+FA==@lists.linux.dev
X-Gm-Message-State: AFuF++lhQndP/Fh04DUJMDNuWIY030bPye4jj6xpYqff0C+C/RPuPCuG
	/gLKJ8wTpUllykhlkiZbF6u3pLPXxoLxiDOWGErpU69GfHCdDLN0wJyw
X-Gm-Gg: AYBFou3YptTYwA6EVAOIV8C1zQ0js/QGAK4qikbogBkubHAm3G+/HbVVIRWPbQ1NuDf
	R4rj5VX9m1kSKwjTEEKlCAt0d6gLfuBfoCuV8nGv7pUaLkGT+fGdBJqWU6BvjUFory7TeWO79VF
	/6aM3pF4YrUgY53jA0RPBZeAW3U5gFtGZmbsTsS6YrL6Ay74NvOiC2LNlGccwoGXjNZX1RSw+SM
	uUSK8kZJUKZZUQvSXOu69x8HQe9XHc4wzul+SYZUxobx5LqD32rsngaP3l00tngIWuvN51Adwv5
	HFNfs3y0XIO8hRSj8BB1Ae+4uOoy0l+UTyUhfkSjQPZqKb/Tsw7Op3xk+mP8Cc+VSlelSt3Y1uh
	W15OGq99wtrHA04/0JQ6gJubJu+ZxFfrfZjshua7zZyzGh1FQV5n+Hh8GjFV8aIOUOhWXaujdvP
	hVxgsRaM+4b6wknHEgRA1LkxsxoD3vAnZZM8h1yZ6bj7fSmpKfTtw91o7aH+IXIz6PFNu73UmWf
	rd98Bqg2r04a7zg8S4FnYpv8+s4sHzdNY0dap5bnBogsyeJ64SQpB/PVuyXngNdCOomyBgtnSk9
	npaFRyDyDgtU1Q==
X-Received: by 2002:a05:600c:310e:b0:49b:9241:7ff0 with SMTP id 5b1f17b1804b1-49ce558f8d6mr118094475e9.0.1788449063470;
        Thu, 03 Sep 2026 08:24:23 -0700 (PDT)
Received: from pop-os.. (98.102.222.87.dynamic.jazztel.es. [87.222.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee60bae6sm96098935e9.9.2026.09.03.08.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:24:22 -0700 (PDT)
From: Miguel Garcia <miguelgarciaroman8@gmail.com>
To: stable@vger.kernel.org
Cc: pvmohammedanees2003@gmail.com,
	akpm@linux-foundation.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1.y] ocfs2: fix deadlock in ocfs2_get_system_file_inode
Date: Thu,  3 Sep 2026 17:24:21 +0200
Message-ID: <20260903152421.1801322-1-miguelgarciaroman8@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammed Anees <pvmohammedanees2003@gmail.com>

commit 7bf1823e010e8db2fb649c790bd1b449a75f52d8 upstream.

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_fill_super - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Link: https://lkml.kernel.org/r/20240924093257.7181-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
Tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miguel Garcia <miguelgarciaroman8@gmail.com>
---
 fs/ocfs2/extent_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index bb3a56b7f9a7c..5e86c7e2c8212 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -981,7 +981,13 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR,
+				 "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-- 
2.43.0

