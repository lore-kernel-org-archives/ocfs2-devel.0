Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5801442FB
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 11:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711883890; cv=none; b=aAJ0Y/+T/fEcUu2Rx1JLbQjnGV5b7NFdAn+OBLEwoEkv7hUDpMpCA7epvJQ2IS/wlxx2pibigwAM08hxRrua8Q4qWaoyzyOMu1IvoXrueZ8DgnnvEIbmIUPxxKw9/dMqRhqzdM1hedgQt9laBTE7T2ZIcnT7CjkL3ZbimJQF4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711883890; c=relaxed/simple;
	bh=x6JLtm8Sf3zx2Py1Y+VuKAT0lqdhYgzPaqeckXKrIak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1Fu/Qr1Ie+OPBeZxcu8ZB3cy9ImezPjUVuqzAfjppRf2iiqKHpWseeM8qPvoVjcQAJD7mgNhn2ViopyzCUKjWLGrMhGcXUf6e6/jW/IFNjRrEM/Dbm/qRQAUJxLrMWvVO65X2wXDDvEH7VoMFPRzkrfGQZoS4ZLPS/MdhJDUqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cn+X8Yc/; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cn+X8Yc/"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d71765d3e1so24629551fa.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 04:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711883885; x=1712488685; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cumCWDcg1MxEGQtU/LvG8hvdSYOJzxllEA+Nv723TW0=;
        b=Cn+X8Yc/rrMFiVyvJXyvnskb3FNdt7KASp78Db8dhBBAtnnL4ZjVVqphtMKvo+/e/T
         HbHfsFLvYW0QlgnFO6I1GMiCSO+yrrzhgFvewmEYt7St/waQ/tUSQ6GqwdltGdHjSAMJ
         fX3veV65YNOHVV+hLb5chCDEk+H7OoNfI1KM8IGrPBBe0SC0nd+3PH7z1aEDKZdmE4TJ
         fNN/wcUJ3pDtGTVr4jvL+JtPReIu3jdvmAYJ7QmIwefvzEwKOXQT4mZgND90umMHwyb8
         MT7qZbZ4ypGKRv1pv20ev+n411wIir5Hoy4M0GoE4O11UYzPThU2zvh2ji6HLKmL8Njs
         npqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711883885; x=1712488685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cumCWDcg1MxEGQtU/LvG8hvdSYOJzxllEA+Nv723TW0=;
        b=peCT6sLsXdzYXdoAxt9txef63Ks+i4o5TheXB6buZfESQufJRd79PTQaaU9PsclNOs
         U+CFskeIFg4TT/Xqunw6bpDtRxHKfG1qyrlIjPfh2nvFe9uk1YgBfoR8lElsK32qICQf
         JSyeqv1PcbDP9vy50ctVBst10bS+ELZzSotVXYPt3ru1C/nmVLlqOgkAlifv5isY1m6H
         VW3Yowq/0X1eTUc71MrHPK5Ot+lBbT6MR72H9H/Nqoeyy1eZUGUNpNWDkhsLls+csbIT
         kYMr8QF6vry50GZ7WyTwsDidt9zwABkqbPELTcRCgTyUkxvNjf1/WEu/NsxenMNi+mHW
         1VmA==
X-Gm-Message-State: AOJu0Yx44gnhe+TMhmy3RGAsUYuOk8698RcOjpmqKSWTUxAuRyQI9nZE
	8oaFHDZ7mNIhrtF7IOdyPvJ2QwprWqP/8eoD6lHmnqlxtI3LogUXRIUUofJywvqL9m0xuEwdBLJ
	Q
X-Google-Smtp-Source: AGHT+IGLepeq4xciyru0kPen4g9eVwwE/uIPw9onQzrcZgrupNKxsubnwxxjOwjDt3JZkjpQkhLXlA==
X-Received: by 2002:a2e:b8d2:0:b0:2d2:42ff:483c with SMTP id s18-20020a2eb8d2000000b002d242ff483cmr5091963ljp.33.1711883885580;
        Sun, 31 Mar 2024 04:18:05 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b001dd82855d47sm6675406plb.265.2024.03.31.04.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:18:04 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 3/4] ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Sun, 31 Mar 2024 19:17:43 +0800
Message-ID: <20240331111744.7224-4-l@damenly.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240331111744.7224-1-l@damenly.org>
References: <20240331111744.7224-1-l@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

transaction id should be updated in ocfs2_unlink and ocfs2_link.
Otherwise, inode link will be wrong after journal replay even fsync was
called before power failure:
=======================================================================
$ touch testdir/bar
$ ln testdir/bar testdir/bar_link
$ fsync testdir/bar
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
=======================================================================

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9221a33f917b..55c9d90caaaf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -797,6 +797,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
 	fe->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	err = ocfs2_add_entry(handle, dentry, inode,
@@ -993,6 +994,7 @@ static int ocfs2_unlink(struct inode *dir,
 		drop_nlink(inode);
 	drop_nlink(inode);
 	ocfs2_set_links_count(fe, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-- 
2.44.0

