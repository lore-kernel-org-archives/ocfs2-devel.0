Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F943B14C3
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035593; cv=none; b=McKPQmllL0LdqEU9d16ypqeYEnfEwGvfreJeKRTTGEOPCaRCl6JBUY4D7jnhc7Pj5UNMhVX+RFgU0dEB5MjrAgVlMzUg0SVcSchWO/5RDLVhvHAcxwilYrIMbTD9+iu3UEKtqcnNgLSpSfaSgInumSNJtHgG5kYDNBjXSGdeyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035593; c=relaxed/simple;
	bh=D13OR5xsYh8JEaA5aDJc/1Dh9iYDdCdoFjWLWDwwfds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3aIXtGOOP4Qd6zkgAs5xObkT+EKyX7D31T5XkmWyz2WqZX3KSSTgjswGl0VfRIdm8XodUgeJ4KMtuhjtXmdDo8srUXTRyQxJBxbW1zSYFuMGiKB5VFIB50kGFdACQKHPokJiqcBxsOV+yreBmGWKzgBSnt1X5MhhlWXbo27ZyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gj9J2Nwk; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gj9J2Nwk"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5c2c46a428eso1704187e0c.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035589; x=1786640389; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rb7ASnE8Sx91CLFoiOKNMQmqUcK+VC1xbbyNQo6vc/k=;
        b=Gj9J2NwkjtnIwHQBRidG6k4zHNkva1IxB3ONCz8NXQ7pf6D5jH0JJL0/sdGEraH7rY
         vVD6mSf5tg6D6jmufdV1uwxOrwYJxSk1ECNFvA4fzNTrAg3GwfUqgLI0/TN4l62+sQPU
         xNI1uVs6jj0HDBWs4uFcw7dLgikGj/BTasVRr3icHXdMsKpCH3ACdvvPKmyw6o+PAWoO
         zWeN9pAQPM+eUf+ZPF/4Z/eBIB/CZ4VhBL2GCTY1U+PUOvpR2TaqkQhTl7ZxLNkS2dVv
         4W49dptt4XuJXdjc7UZRuKsEPbPoKcsRQFLUIR8lAqefKm2XVC71OYetAyRigjsdAa5A
         xV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035589; x=1786640389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rb7ASnE8Sx91CLFoiOKNMQmqUcK+VC1xbbyNQo6vc/k=;
        b=Lhg2V3CAUexqqD67LtpS5MXNLTuuLGxZ/rN2d/sIDs6DhwWrxx/17devjFY4yGsyJH
         xWAsHYXvLsO9iR7xPi2RoPR5DVlyDSF9wRuNPsEmyFUrF/pmXQCiJ2jejoDHiybcktvq
         k1gkOFhGGGDuN4d+PrebDx2zN2Vv68bhuhwM+iLuy2SgF9AhFI1NiZ8kj+A2pzwy4271
         v5e10Mtci6QPMuEHl3wNADECcsPEa9Pp///VgrL/b8naJKu8ckGil3aO7fG00oC/gHUU
         UQL7QI6eOfOlTnfYuPu3lg35bIYRQR17E+CnrmURMA11T8cmcp49DTWlgvunWAFXtt9h
         noWA==
X-Forwarded-Encrypted: i=1; AHgh+RoTIJiSgLDxXY6B8nTEBd41dpC4X6vxSvui3hvkNKutdWYCOE6JFBjZNfYTPXlFrRY3diHK8WVYhEbInQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6AJbF10hJl1lWUNTpM6LJ6kKRLWAhAkof4+mvUsw7jKHnUKCh
	doIX9QIPlk0r7pnpcY3QH/S/le51lsNbtshaHHR56TsE2agz1oR+iJVa
X-Gm-Gg: AR+sD12+rONUQbcUUjsV4K6Di5fkzZ1Kg7Xb41MgyEblZ1jTB2R9AdiEDZSujrspZGR
	Wxojjoc+/5UXizXKXp+Q0yBxzT6F4XpsFqQK7DDb4LYmzkRYimk/vMo7nMDsHId3t9TX5d5CncM
	O1+raXEFE0Xcwr2RMoSXeJyK1uK0WL9W/4Czv0vu+5IcrwTTh8ktFfbbshcpEqKOWXLXk/5Cbey
	pQWWODONiMnbRvQK9NBfUJO8Jf/5JFtbDQ1GZl97CxINUKWGU+1rKs4nK3Mal1ZVbt80+NU4tGb
	2ynasQEefOc+jDxvhTVo8o+sOIiztxJU3dNUFCfakbz98xVDtfaysCGTOOMpw70/zL7keHcvFlD
	7o8zqLCsXZDwRii6V5DBsR18UoomDl7SZggKUaSIHe/CnxOOWDCQABvOOskPwCzPh5UJM2DAeCF
	Vv70DXL78bGKAdhjMJiIp8Gy3DiG+67q72O9O2wP/Vddr1KzP54otk1weMEEYC5+BYEFW7q90mG
	G1S+/E=
X-Received: by 2002:a05:6123:2e6:b0:5c2:b8a4:95c9 with SMTP id 71dfb90a1353d-5c3d924e663mr477877e0c.11.1786035589499;
        Thu, 06 Aug 2026 09:59:49 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:48 -0700 (PDT)
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
	Zhang Yi <yi.zhang@huaweicloud.com>,
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
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 11/21] exfat: check for a directory write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:34 -0400
Message-ID: <0784ef63a525434e7c0aff730eca7b43e043095d.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

exfat_update_bhs() waits for the writes it issued and then tests
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

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/exfat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 6f11a96a4ffa..dfd0bbf31c94 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -187,7 +187,7 @@ int exfat_update_bhs(struct buffer_head **bhs, int nr_bhs, int sync)
 
 	for (i = 0; i < nr_bhs && sync; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0

