Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5605A1114
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 01:40:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 783071F8B4;
	Wed, 28 Jun 2023 01:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1687916435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DTwipPwdW2/LXsLE72OtUM8pgO73fvfJDGprJTZaU/A=;
	b=ukMVLD1JxK5JkOIKj0T7+pZi6x7FIajELpw6NRFWpvn0o6o07YxS+Nhu813jTDN/glbC+0
	nMF1OLejbfjr7FhZZRkw/IB58ddSOFjK3E3u6XVWTJqT3xs1Qj55QZ1IIlDpJDPt4m6oEN
	nn2Z4x/8zQ5pli9lo0O5Mt+gyfxBJR4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 071E7138E8;
	Wed, 28 Jun 2023 01:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Oba3OpKPm2TpLQAAMHmgww
	(envelope-from <ailiop@suse.com>); Wed, 28 Jun 2023 01:40:34 +0000
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 0/2] update ocfs2-devel mailing list addresses
Date: Wed, 28 Jun 2023 03:34:35 +0200
Message-Id: <20230628013437.47030-1-ailiop@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ocfs2-devel mailing list has been migrated to kernel.org, update all
related kernel documentation pointers to reflect the change.

Anthony Iliopoulos (2):
  MAINTAINERS: Update ocfs2-devel mailing list address
  docs: update ocfs2-devel mailing list address

 Documentation/ABI/obsolete/o2cb       |  4 ++--
 Documentation/ABI/removed/o2cb        |  4 ++--
 Documentation/ABI/stable/o2cb         |  4 ++--
 Documentation/ABI/testing/sysfs-ocfs2 | 12 ++++++------
 Documentation/filesystems/dlmfs.rst   |  2 +-
 Documentation/filesystems/ocfs2.rst   |  2 +-
 MAINTAINERS                           |  2 +-
 fs/ocfs2/Kconfig                      |  6 +++---
 8 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.35.3

