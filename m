Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496CB241CB7
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Sep 2025 04:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757566582; cv=none; b=Y/g7ngLKKQ3EmvYLIEBcs+YhZiUcX/jtH1MHBuLyDIVza+/JSGaTR7mfY5wSSZ/+FkfheLKdS24n8jj7fAtz9UTMRigk1fA+914rHHU6Ep9a2VSpYzXhkNC41laq1xzwtd4FGRmofkenelSxAammNkqdaDnCO1bL2IaFO/XlY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757566582; c=relaxed/simple;
	bh=+OpnHav0x6JMfHFpFQpCzutgMoUi/ESeVF79sx8hjFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C41Ca/tl1SjFipnJ9sPCi/utQKmeUGMZg/w0Oxs5BA9w73vJe84u0DbVSsDY4Xw0Bk+eAEECaWhW5hrYJvP18Kpd/un7tWpHyCEaECdHLqg92WcdW/d0rrWZntfD+3rkRpaZm85uGh3Wep784Vg/WDeyLZXqd6EB8LPSKEUCQOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeAZ8sM1; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeAZ8sM1"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e34dbc38easo122510f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Sep 2025 21:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757566579; x=1758171379; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YLHicn9dTH5/070mxiYCI0YLNhb1ob9gFIcwBqIMYE=;
        b=jeAZ8sM1uDUw8Ss7dSyzmhh0ZxyksVSH5mkObhL5GhY9Ih/fQnmbtUu54RbJCObZrg
         zHMKjeJp6Sk0AbKzLMT8FPXa2f4JNB2dJFEydY/xyFBa0N8O9UkrDkc8aoLF2qF6ybCv
         BucgXqkBrEW2PuBV219chIg3IGiJXnH1yAslSJuyPBXuZBwmtb+Y9oNVx280Vg1/1h5O
         ccHLTxqNvWtwkX+fP/7i7/94eafOD2UyD4t92lXPunmlmJHngIsgZ4IdYMkdGwmikgOH
         DLKpq224dWfFOTwxtrqHl4N979YQBChjKKntPZiyfwRFdZdvVXyn45cT2vE5XAJWBrIP
         +fIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757566579; x=1758171379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YLHicn9dTH5/070mxiYCI0YLNhb1ob9gFIcwBqIMYE=;
        b=GDshAXFU0GTBKmUhaE+vczl3odFL96/cXsMiRJI2V59EHomZ2CgZY5kuLCL9KBBYNL
         uah5yLECRI2bdG686I8bu7dePFfNO4NdyRinUFKk8qtTMSmJIjqWpKz9lBQKPOQkMlQ0
         Y7btDsV8x/rQHt/pEXXvhwIx412zW1Ioyo8UKTLr8y9LonMz47L4MS1/e5KhxtOMiezf
         Nq3NNy6b1wfiboCYSjY+V5ainnVK4s1Y8LhvHp14mdfIZM0a9Vt77lGygMkA3OMf4CKQ
         FD03TEvisKqfTsflvHIeGum0Fh94LeNsZxFPgVtIDgS0AQHSQQmlaW3e3jgnEyO1aMXD
         SFpA==
X-Forwarded-Encrypted: i=1; AJvYcCWNaK+SQXW9jep4ZQPJXON+EG9sr28E9U8zRI4bx34v7BCBFvkqn2K70j+2YEt2/smNzzWRNhOSPbYWWw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv3AsUKuPblFSdr470YkDZOC9fQNA+KnV2CuzAeaNLhiD72YYI
	Jhln2Lm+NsbX20UVrFzTzboMsJPAk44SwNakmXNqyoB3A5HdAZH05X+2
X-Gm-Gg: ASbGncs8jSIwC7eEP1iodgCXXrdJP+HASN0cFK6JfyEH/yTtKnnmpCuTXseaT2K6O3p
	tZyTe/8/MtzEKpVV9Y41n4ARiO556CWElgElRDhPV+W2edDayAgAoDTZz6+JAOMh526Fvc44bfr
	ZXZ+RII2W7dtIT1adf8PWPAhiB4TbT6dkCkfn4p0L9i8Lue6PNhFlNjbUVq8VavfkHsH0Tkgcws
	Kibayu/QbQBtRTkWjWFnC+0t+WzFc+HHx1Fg3Ys3bdrnubc5IHSy+gkV6mvZfoX+GBJZwcgzdLU
	0aZ1v0vUBbrgr+69RJ2jLQZa3X5wYT4g6MGHIX5ZqlAyFZNftIsxJ/LILJLGKVjQlZmX/XieS++
	bydQVekuWpquRNjF8ovZ0btcmCdN2tHabdMbMz9dC+po5uEcbL58Fpq0t4KokTA==
X-Google-Smtp-Source: AGHT+IH43UmBU64jK+xL3m62yMA10v9nozy9RFWM7cuwJpC5B1nBbx9LsGq+u1ZXEjc4PtCQBy4Z3Q==
X-Received: by 2002:a05:6000:178e:b0:3ce:a06e:f24e with SMTP id ffacd0b85a97d-3e64c87e0a1mr12521762f8f.52.1757566578594;
        Wed, 10 Sep 2025 21:56:18 -0700 (PDT)
Received: from f.. (cst-prg-67-222.cust.vodafone.cz. [46.135.67.222])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e9e6asm889419f8f.62.2025.09.10.21.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 21:56:17 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v3 4/4] type switch
Date: Thu, 11 Sep 2025 06:55:57 +0200
Message-ID: <20250911045557.1552002-5-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250911045557.1552002-1-mjguzik@gmail.com>
References: <20250911045557.1552002-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 include/linux/fs.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ed482e5d14a6..fd8e68352fbd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -782,6 +782,10 @@ enum inode_state_flags_enum {
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
+struct inode_state_flags {
+	enum inode_state_flags_enum __state;
+};
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -840,7 +844,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_enum i_state;
+	struct inode_state_flags i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -908,44 +912,44 @@ struct inode {
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	return inode->i_state;
+	return inode->i_state.__state;
 }
 
 static inline enum inode_state_flags_enum inode_state_read_unstable(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline void inode_state_add(struct inode *inode,
 				   enum inode_state_flags_enum newflags)
 {
 	lockdep_assert_held(&inode->i_lock);
-	WRITE_ONCE(inode->i_state, inode->i_state | newflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | newflags);
 }
 
 static inline void inode_state_add_unchecked(struct inode *inode,
 					     enum inode_state_flags_enum newflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | newflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | newflags);
 }
 
 static inline void inode_state_del(struct inode *inode,
 				   enum inode_state_flags_enum rmflags)
 {
 	lockdep_assert_held(&inode->i_lock);
-	WRITE_ONCE(inode->i_state, inode->i_state & ~rmflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~rmflags);
 }
 
 static inline void inode_state_del_unchecked(struct inode *inode,
 					     enum inode_state_flags_enum rmflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~rmflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~rmflags);
 }
 
 static inline void inode_state_set_unchecked(struct inode *inode,
 					     enum inode_state_flags_enum newflags)
 {
-	WRITE_ONCE(inode->i_state, newflags);
+	WRITE_ONCE(inode->i_state.__state, newflags);
 }
 
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
-- 
2.43.0

