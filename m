Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA4399002
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567319; cv=pass; b=rAswFaQGOdJlLjAbiu72F5vHNxGqPNulaoP/lRbJ0W2oAdLvrt/TrC3Luzs+a68xHub3v0hD+I/fun9Ty2VoAdXDtAfky64OlLu6M6xbxNEqvOQEsnYpXGPPRXqOjtDVIj8Hb29ESKzHGZk5z5ieH4sPAiBW5AsRnVel9W/bm0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567319; c=relaxed/simple;
	bh=jAAPr+NzkcF2+Oosp8LKgy5a74mmAcQ21+C08Ruro/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qj1uDFV11apCziOXP0IW8W9JoNvPr9ikio31S8UUX6IfrhwRd9+iY8ZQt3l3Ye8bGgUmRVf6X3GDH0sb5FH0TwaBWigt3jbpIyeQuWadU3IhKZtctJCCsV9sVRa6IjvwlJGV64wiCgVzUiSY6yEcRng9L7xt/04EoPPjIh3xTJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=baT3UPtC; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="baT3UPtC"
ARC-Seal: i=1; a=rsa-sha256; t=1784567313; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=SzfDqKeOLlt/lE1+eZOcJiPT7P7J3Dky+E/Uw0Dme6Hy25aEl6X5n9DR6paMyrNuv8ayC8yCb/5h3Nh2LbUHWfDLTz8VEMvo1J6rsotA8pJb25kTtRw8YAP2If+G88nSE0f+yj1rM28YoeF9K9Lj5KLNpKpcit4Xr8MDlIAJAwM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784567313; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Q+odzwMiVWZ3Eq1b7HuOgOgBPZLqMNN6vIgDe0sl3xk=; 
	b=kbuijMIrSOwBSS2Uw/lAdlXUt9M29VWM36cFqiuP13inmpU2va0mU0I8n63/Cn2W2h2oD/XORrFEgouLCzfVgd4ZUyqjb1zeMGA+1rQn5+9c3vapaUZw4wLBgBWrt7UtMUK34xfoXfNH/LgdBiZiCTCmDiUODv8FRWzuUmF6Ye0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784567313;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Q+odzwMiVWZ3Eq1b7HuOgOgBPZLqMNN6vIgDe0sl3xk=;
	b=baT3UPtCIAQgzZQuUY4DP4Z4Fyuf/f3WPLZEzmmgP4bZMAxItjicGpTfUvIH2MTz
	RFKMmssBvn6NjztE4mlH80gQnKnN7Gu2OYwq8xhVrppRq1tE1gSAfFAnuwecs+vb5s/
	xY4Qg2XiwzQWd6QpW9MQE701N3wMS+PeNqFF5vXU=
Received: by mx.zoho.eu with SMTPS id 1784567311239469.60805300631216;
	Mon, 20 Jul 2026 19:08:31 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2/dlm: validate lockname_len in dlm_mig_lockres_handler()
Date: Mon, 20 Jul 2026 19:08:28 +0200
Message-ID: <20260720170828.11476-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

dlm_mig_lockres_handler() handles an incoming DLM_MIG_LOCKRES_MSG o2net
message from a remote DLM domain node and copies the migratable lockres
straight out of the wire buffer:

    struct dlm_migratable_lockres *mres =
        (struct dlm_migratable_lockres *)msg->buf;
    ...
    res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);

mres->lockname_len is a raw u8 field taken verbatim from the network
message (dlmcommon.h), so it can be anywhere in [0, 255].
dlm_new_lockres() forwards it unchanged into dlm_init_lockres():

    qname = (char *) res->lockname.name;
    memcpy(qname, name, namelen);

res->lockname.name is allocated from dlm_lockname_cache, a dedicated
kmem_cache sized exactly DLM_LOCKID_NAME_MAX (32) bytes
(dlm_init_master_caches(), dlmmaster.c). Any lockname_len above 32
therefore makes memcpy() write past the end of that 32-byte slab object;
the maximum attacker-controlled value of 255 yields a 223-byte
slab-out-of-bounds write (CWE-787) with fully attacker-controlled content
(the bytes are mres->lockname itself).

The o2net receive path only bounds-checks the whole payload against
nh_max_len (cluster/tcp.c); it has no notion of the lockname_len
sub-field and cannot catch this. Every other DLM message handler that
consumes an attacker-supplied name length already guards it against
DLM_LOCKID_NAME_MAX right after pulling it out of the wire structure:
dlm_master_request_handler(), dlm_assert_master_handler(),
dlm_deref_lockres_handler() and dlm_deref_lockres_done_handler()
(dlmmaster.c), and the equivalent check in dlmconvert.c / dlmast.c.
dlm_mig_lockres_handler() is simply missing the same check -- present
since the file's introduction and never covered because exercising it
requires two heartbeating o2cb cluster nodes and a joined DLM domain,
i.e. it is invisible to single-node testing and to fuzzers that don't
speak the o2net/o2cb protocol.

The attacker is any node it fully controls (or is on-path and can spoof)
that is heartbeating in the same o2cb cluster and has been permitted to
join the DLM domain. o2net authentication is limited to cluster
membership (nodes list + heartbeat), not per-message payload validation,
so a single rogue or compromised cluster member, or an on-path attacker
able to inject on the unauthenticated o2net TCP stream, can send one
crafted DLM_MIG_LOCKRES_MSG frame with lockname_len = 255 to any other
domain member and corrupt adjacent dlm_lockname_cache slab objects,
leading to memory corruption and, depending on slab layout, a crash or
worse.

Reject the message before it reaches dlm_new_lockres() /
__dlm_lookup_lockres_full() if mres->lockname_len exceeds
DLM_LOCKID_NAME_MAX, mirroring the validation idiom already used by the
sibling handlers above. The check is placed immediately after the
existing dlm_joined() gate, before any use of mres->lockname /
mres->lockname_len, and follows this function's own early-return style
(dlm_put(dlm); return -EINVAL;) rather than the later "leave:" label,
since at this point buf/item are still NULL and no refs have been taken.
This is the smallest possible fix: one bounds check, no change to wire
format, on-disk format, or any other code path.

Reproduced on a v6.19 KASAN-instrumented kernel with an in-kernel
injector that calls dlm_mig_lockres_handler() directly (bypassing the
o2net accept/heartbeat gate that otherwise requires a second heartbeating
cluster node) against a live single-node OCFS2/o2cb DLM domain. A control
frame with lockname_len = 8 completed cleanly; an otherwise-identical
frame differing only in lockname_len = 255 reliably produced
"KASAN: slab-out-of-bounds in dlm_new_lockres", deterministically and
with no dependence on timing or allocator state. Full network delivery
over a real two-node o2cb cluster was not exercised: the injector proves
handler-reachability and the write is deterministic once the handler
runs, but the o2net wire path itself was not verified end-to-end.

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
 fs/ocfs2/dlm/dlmrecovery.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9b97bf73df22..ec7edffc8ca8 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1366,6 +1366,12 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 		return -EINVAL;
 	}
 
+	if (mres->lockname_len > DLM_LOCKID_NAME_MAX) {
+		mlog(ML_ERROR, "Invalid name length!");
+		dlm_put(dlm);
+		return -EINVAL;
+	}
+
 	BUG_ON(!(mres->flags & (DLM_MRES_RECOVERY|DLM_MRES_MIGRATION)));
 
 	real_master = mres->master;
-- 
2.50.1 (Apple Git-155)

