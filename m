Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080DD2580E1;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709304; cv=none; b=R0tWPN+cKiBDauHBgKWpGx6gaE80t31mddLu+wPaezS31r2yP/nMFfNLRCdKZW8zj1o9oxRjKRGYnqboJQ0RBLoAAUM1igiR/junDOAMSfA7p9wiXZlgzmuNlqg30tRBUtQdVYoF21a+f/cTdRiDieDaqCxMVAoNATUhJWRpQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709304; c=relaxed/simple;
	bh=B5hZ+dVQ7sJLmtVEd4q7A1QtpuJWUnbVM7wi1GHHZVg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QbsSXBHjDjAPjmKdRFTBvla+OyXb9/hWXUPGeme9HEqed5yOgp3WbJOj8aQ+vl+tE/1HI0A97e6CX3BmeGOtcLNs6aIRCQ8AyMYgqjBRWLQSvk7j/pD2U/nWmi2uqH7q2/VMWP1nMb0KvkZfNLLIdcWldej++7kcn93wiRB+EHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qBs666k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBs666k4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDA71C2BCF4;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782709303;
	bh=B5hZ+dVQ7sJLmtVEd4q7A1QtpuJWUnbVM7wi1GHHZVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qBs666k45NPoB11Br69p4be2bSmVPB33fJmvwe4iKgQ0kn0YS4cD9kllKMay6d4jS
	 IU6DzWDY8FcS5RtIhNHimYAk87KzbvcjRzu+JZ8pUSloykr/oli0oInNjedBTNy+oI
	 GUirXDezHTSlDx4wFIQMXgvpZHnWS4P4Ld3l2t0LyaEQ5Hrj0BOgBSgKfz9iQevfAS
	 O2VgjXJzzXjh5O8cdnkCKJSiKBdzPanTnfq6E3My1n+MSn9jZ81ERaGolEuPvlwcQQ
	 XoAdbU8WFiGJn7yujHl87QO+5sQXmQcxQWG7ohrZBC2d/gyI0Qa752UmdQz+kiK9M0
	 Njvyt2xPFwj4w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0F5C43602;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Mon, 29 Jun 2026 00:01:43 -0500
Subject: [PATCH 1/2] ocfs2: bound namelen in dlm_migrate_request_handler
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-b4-disp-94fb6521-v1-1-6953bcc0421f@proton.me>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
In-Reply-To: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kurt Hackel <kurt.hackel@oracle.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782709302; l=1498;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=RtRvTUqLTTNjHItBU2QlVnq+fOoWouPL9E4x4+QRNFc=;
 b=Z4xZ7puaiaDyfsGWJw9bz9DOZTmFFRTsMZEfQi4T4Nnn/MVE/gjpT6YLZQmFBJYrk0+I4GR0p
 cEx5Xhk3FbICudEU7s8iHdC+3JoLm3Upw3K+tRD553SLsfhFdmm6PXX
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

A node receiving a DLM_MIGRATE_REQUEST message trusts the peer-supplied
name length (migrate->namelen) without bounding it.  dlm_init_mle() then
copies that many bytes into the fixed DLM_LOCKID_NAME_MAX-byte mname[]
array of an o2dlm_mle slab object, so a malformed message from a cluster
peer overflows the slab object by up to ~215 bytes: a heap out-of-bounds
write of attacker-controlled data, reachable by any node in the domain.

Reject an oversized name, the way dlm_master_request_handler() and the
other o2dlm receive handlers already do; the migration handler omits the
check entirely.  Conforming messages are unaffected.

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 fs/ocfs2/dlm/dlmmaster.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 93eff38fdadd..bd7623cc6e77 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3100,6 +3100,12 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	name = migrate->name;
 	namelen = migrate->namelen;
+	if (namelen > DLM_LOCKID_NAME_MAX) {
+		mlog(ML_ERROR, "%s: invalid name length %u in migrate request\n",
+		     dlm->name, namelen);
+		ret = -EINVAL;
+		goto leave;
+	}
 	hash = dlm_lockid_hash(name, namelen);
 
 	/* preallocate.. if this fails, abort */

-- 
2.43.0


