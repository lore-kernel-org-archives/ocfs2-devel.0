Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08148267B07;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709304; cv=none; b=qxmwUArBZ8htNjBBQ+JZV7qtMJPKCXukGdp/aSvkghpZECTnarKY8Rly65F8T4KxFjYbqIYXdWPiyhTmuY+qTUIOIHiEw0G1AVCGtZ0y2Go4MdM3XkaxTdQhaM9zKhfmKAkCz7M9NfG8od2KTnOtI4mhIxWEbYDR+9YusgzrK4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709304; c=relaxed/simple;
	bh=QRC85QjJCODr2M6Df8FYZbSd0taCEHDGAXP7z1N3doA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hA8sJ3NniOAusp5o+w7qoe9GmoCrSCgox87SdiIQBNobyOIf6eAQsYfohCFnbykrGb+3qauDtpCCPp10RGhKa70d/+cDNtLlzoxx7Y685AZ13hPSUlSpKQwQYa6I4eyyJkBlGCm8gtNKLj/niRaU4nF/kUix6tw484wprO6509w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RF3F8ubb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RF3F8ubb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3B35C19425;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782709303;
	bh=QRC85QjJCODr2M6Df8FYZbSd0taCEHDGAXP7z1N3doA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=RF3F8ubbL38PtcunEMuhm7ATEfzvkmwu3VvFjUuGpH8LoUElG8KSLxA8wSSp0JJW8
	 jGQ36NzXatzOG2u/h2uP7xlDqhoVKTOsHXihoJvaKBAQHbGdYH1yGvchXOBIlGFP67
	 Jo5XKbequspza9P+NwSNni5A+yevGfVTrVUIrt4fQAG1IqZPPHd4ghyvooGnHBZ+5s
	 T/ZdS8HlqML7tzY7QHca+gLB6PT/67fSlI6SVQ7Crb0BSWUxaepO3QrMHIZ8Wx+Tvx
	 UsRG4RPEbfq2ZSlMsdifQDZ7nfe8RyFWU3bYh7IZ1RGdpGs/UCE5qKs4VM+TJVK6GA
	 kmxgpqiwzPe8A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6E3C43458;
	Mon, 29 Jun 2026 05:01:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH 0/2] ocfs2/dlm: bound peer-controlled lengths in the o2dlm
 receive path
Date: Mon, 29 Jun 2026 00:01:42 -0500
Message-Id: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADb8QWoC/x3MQQqAIBBA0avErBvQwYy6SrTQHGs2JQoRhHdPW
 r7F/y8UzsIF5u6FzLcUuc4G3XewHe7cGSU0AymyytKE3mCQknAy0duBNCoXHdEYjDUbtCxljvL
 8y2Wt9QO7/DBxYgAAAA==
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kurt Hackel <kurt.hackel@oracle.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782709302; l=2796;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=QRC85QjJCODr2M6Df8FYZbSd0taCEHDGAXP7z1N3doA=;
 b=EY6HzZVDv9k60pLY4oE86V7dLXQqTimlL7jYAVJXz3XeTCDNKmW5d0IIAyHCKH0n9+myckmjT
 AL/6lUQsDavCSc1QgHPfCL5v10sZDEZc8xw3PjIlkWM8wJvoFasAw6v
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

The o2dlm receive handlers trust u8 length and count fields from the wire
without bounding them, so a node in a DLM domain can corrupt or panic any
other node with a malformed message. Three defects:

  - dlm_migrate_request_handler() passes migrate->namelen unchecked to
    dlm_init_mle(), which memcpy()s it into the 32-byte mname[] of an
    o2dlm_mle slab object: a heap out-of-bounds write of up to ~215
    attacker-controlled bytes.

  - dlm_mig_lockres_handler() passes mres->lockname_len unchecked to
    dlm_init_lockres(), which memcpy()s it into the 32-byte o2dlm_lockname
    slab object: a heap out-of-bounds write of up to ~223 bytes.

  - the same handler trusts mres->num_locks without checking that the
    message is large enough to hold that many entries, so
    dlm_process_recovery_data() walks mres->ml[] past the kmalloc(data_len)
    copy and trips a BUG_ON (an out-of-bounds read ending in a panic).

The other o2dlm receive handlers already reject an oversized name; the
migration and recovery handlers have omitted it since the DLM was added (see
the Fixes tags). Patch 1 bounds namelen; patch 2 validates lockname_len,
num_locks, and the payload size. Conforming recovery and migration traffic is
unaffected.

o2net authenticates peers only by the DLM domain key, so any node that has
joined the domain -- including a compromised or malicious member -- can send
these messages. There is no local trigger; the attacker must already be a
member of the cluster.

Each sink was confirmed under KASAN with an out-of-tree module mirroring it
exactly -- a kmem_cache/kmalloc of the real destination size, then the same
unclamped memcpy/loop: slab-out-of-bounds Write for the two writes, Read for
the recovery walk, and a panic. A userspace AddressSanitizer build faults
identically under -m32 and -m64. Scrubbed logs are available on request.

I reported this privately to security@kernel.org and the ocfs2 maintainers on
2026-06-20; with no response after the standard embargo period I am posting
the fix publicly. I have no embargo requirement.

Bryam Vargas (2):
  ocfs2: bound namelen in dlm_migrate_request_handler
  ocfs2: validate lengths in dlm_mig_lockres_handler

fs/ocfs2/dlm/dlmmaster.c   | 6 ++++++
 fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
 2 files changed, 15 insertions(+)

---
Bryam Vargas (2):
      ocfs2: bound namelen in dlm_migrate_request_handler
      ocfs2: validate lengths in dlm_mig_lockres_handler

 fs/ocfs2/dlm/dlmmaster.c   | 6 ++++++
 fs/ocfs2/dlm/dlmrecovery.c | 9 +++++++++
 2 files changed, 15 insertions(+)
---
base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
change-id: 20260629-b4-disp-94fb6521-0afa227d464c

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


