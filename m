Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080591AA1D2;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709304; cv=none; b=OgWFKmFHL1sjTSpsl7Ddd2IIGB/zOHU1NzTEIkrz0UKZgfQ9dHlyD5bDFaV9W+s9cRV4SWWrtQop9O+U+KrF8yVasNdsXDplc69DVE7RVT8Bk2gJmYh5NTOg1ZgNIgv0lXc1pN0BL142a3lyvjlM+8m0pbYc4xChgRjoZKhT6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709304; c=relaxed/simple;
	bh=aUQVnYie4deWagKziM6M9UWm394s24qUt20cL2e0mOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YgGu/7GtUnzogW4FPi7XRy/lHLcar8qQVDTn2/1utcU3L2uFQklCteXCS6ZzFySOeP5fNlHM5YA8jZse90Rco7i+wW/Z+IJD/V65SDceivZwLXjF/YkpZwv6vei9pwTC3lPzsXovXRkU3PjDDCpPCcIsEX2faeMEnVhkdEFefLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vjn2dDp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vjn2dDp2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C97AFC2BCB8;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782709303;
	bh=aUQVnYie4deWagKziM6M9UWm394s24qUt20cL2e0mOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Vjn2dDp2ypSxHK2WfeExWGMGANMyW4EvwkX4o5Mpj/Sb+yzcyxK2OVfWSak3Fhk4b
	 OEzhR+oUvYnGXhohWeonNcCHM30wgHbeYDQldCQ5nLMT/YnrHHbc33xFhztuFcZQC6
	 jtMd9PdjxTr6OQfuT1nFmfTpcOxzuUiCN61w9/KLtdXWKP+PYRBfVy71WeoBDYcWof
	 PVJ4WcQGdnBECYXr0t7sB4G3/AGPMUwb/7MO1KFCad1mpA/q/dA8+G1f0FH3Ps/OuX
	 AjuUkZBHMFIAXj5c5bCSw3u/YXpWqcgwY7DaRbaFXKB6jcYvYZISc81Wwhlm0xrQXr
	 XJM9oVpkqs/Ew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9982C43638;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Mon, 29 Jun 2026 00:01:44 -0500
Subject: [PATCH 2/2] ocfs2: validate lengths in dlm_mig_lockres_handler
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
In-Reply-To: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kurt Hackel <kurt.hackel@oracle.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782709302; l=2129;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=n8/U132yn/sKTeFUcvnEZBy26KB8iGkXZR1WnhsgTJk=;
 b=YG+hbSlxbkwERxe49x6W6IxslN971ryVZwQap7HoLlMdGOSvrvWn/L0YM20mAqtzMEZygzPZs
 k0NNPgB865rDXAfllPpZcXBvyw6a3lP6mW9N5a1tlD5ReFqV2zP0j50
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

A node receiving a DLM_MIG_LOCKRES message trusts several fields of the
peer-supplied dlm_migratable_lockres without validation.  num_locks and
lockname_len are bounded only on the sending side, and the message is
never checked to actually carry num_locks migratable_lock entries.  As a
result dlm_process_recovery_data() walks mres->ml[0..num_locks) past the
kmalloc(data_len) copy of the message (an out-of-bounds read that ends in
a BUG_ON panic), and dlm_init_lockres() copies lockname_len bytes into the
fixed 32-byte o2dlm_lockname slab object (a heap out-of-bounds write).
Both are reachable by any node in the domain.

Validate these fields right after dlm_grab(), before anything uses them --
including the not-joined error path, which already prints mres->lockname
with the unbounded lockname_len as a %.*s precision.  Reject the message
unless lockname_len <= DLM_LOCKID_NAME_MAX, num_locks <=
DLM_MAX_MIGRATABLE_LOCKS (the bound the sender already asserts), and the
payload is large enough to hold the claimed locks.  Conforming recovery
and migration messages are unaffected.

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 128872bd945d..14d4c7c3eebd 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1357,6 +1357,15 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	if (!dlm_grab(dlm))
 		return -EINVAL;
 
+	if (mres->lockname_len > DLM_LOCKID_NAME_MAX ||
+	    mres->num_locks > DLM_MAX_MIGRATABLE_LOCKS ||
+	    be16_to_cpu(msg->data_len) < struct_size(mres, ml, mres->num_locks)) {
+		mlog(ML_ERROR, "%s: invalid lockres migration message from %u\n",
+		     dlm->name, mres->master);
+		dlm_put(dlm);
+		return -EINVAL;
+	}
+
 	if (!dlm_joined(dlm)) {
 		mlog(ML_ERROR, "Domain %s not joined! "
 			  "lockres %.*s, master %u\n",

-- 
2.43.0


