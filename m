Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FC13431F8
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 09:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782984464; cv=none; b=tsVc34D6S+RaBHZLOk7CtayHl+gCC/zHkqCBOdog/zWgTGroWAxFWomb91vh6Zld/CYFaRe3kWVFIB30u8h5u6rsl1RtUUyDQHpKH0sTCTILAoT4EP8o7JbDH0XaT52cde+0WqwrhTGf2s60vt86P530BAXKhCz9kV+Vp5663Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782984464; c=relaxed/simple;
	bh=TKHe5uD8HbZ0vxoS4cE6zN54uESH7opw6OiZstEHxkA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jA/kHJD+XJKP5w1T7Hs9xt0lpkp3Z+twXpTRK4Y9Vtj3wVCQ/iqqiEECP1AIIRwc9Krr38MUalskzDoSwbtBH+fZwJwzD9C/4/TOWy/K1yaNk0XvbyFV2lrgeqzZ9DFeNz5Zm5M+Ya6YbB23l5eGEK+cGZKggIkkpkNA8XyXQZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=CkkEhkSj; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="CkkEhkSj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1782984445; x=1783243645;
	bh=hJHbY7hmyNV7Z3Zn4irN7YTH0PyWSAs6MO8WJ2LUyMU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CkkEhkSj1IIYvWAWztcnLmVb3l4S8d0SIKkNFqMiL1alQu9BOktHCDK3oGQ4Qe4+z
	 dQmYAxJh1WlltsPUSPcDAbnmsyTzOAYwVXCrWKJNoucaRF45Jg5wLEKf7a0vhLfmUD
	 cU9+/FaeaLKvbQ7NyrnynlWDxmXNewPs/Vkc8Mas7ZJYQD2A3F5a0Nyy9vKP1kb0e2
	 7gjqVBwgTNE+kzaIoD46ytCIzWZJOfuHrNFxRgmYcJKvujWHrA0vYXV2UIRWVjvM25
	 cTEiF5j8zI4YAmvyoD+nTwGszw46lym6ziVFl8WHPJP+V2Qca8j/fMedWKrzkYMruS
	 ReQCN0Pg5zL0Q==
Date: Thu, 02 Jul 2026 09:27:21 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH 0/2] ocfs2/dlm: bound peer-controlled lengths in the o2dlm receive path
Message-ID: <20260702092714.303785-1-hexlabsecurity@proton.me>
In-Reply-To: <18449469-291f-4f39-be62-faec1513645a@linux.alibaba.com>
References: <20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me> <18449469-291f-4f39-be62-faec1513645a@linux.alibaba.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 076fc4e7cf373a5fae4b236cecf6bdb7b24065ec
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jul 2026 13:56:00 +0800, Joseph Qi wrote:
> Ocfs2 is always deployed in trusted network, so how to trigger this
> issue in real environment?

Agreed on the precondition: there's no local trigger, and a random host off=
 the
cluster can't reach this. The sender has to be a node the cluster's o2net l=
ayer
accepts, so it isn't remote-unauthenticated.

The real-environment trigger isn't a malicious admin. It's a single comprom=
ised
member: code execution on one node via any unrelated flaw, or a node wrongl=
y
admitted to the interconnect. o2net admits senders by node configuration, n=
ot by
any secret -- so "trusted network" is the whole boundary. From that one foo=
thold
you can corrupt the kernel heap of, or panic, every other node in the domai=
n.
Node B's kernel integrity shouldn't depend on node A never being compromise=
d.

> IMO, the patches are reasonable as a belt hardening against future bugs
> or operational accidents, but not overstate the risk by framing it as a
> security vulnerability.

The DLM already treats these wire fields as untrusted, so this isn't a belt
against a hypothetical. The lock-operation handlers reject an oversized nam=
e the
moment they read it:

  dlm_master_request_handler   fs/ocfs2/dlm/dlmmaster.c:1426
  dlm_create_lock_handler      fs/ocfs2/dlm/dlmlock.c:469
  dlm_convert_lock_handler     fs/ocfs2/dlm/dlmconvert.c:450
  dlm_unlock_lock_handler      fs/ocfs2/dlm/dlmunlock.c:416

same namelen > DLM_LOCKID_NAME_MAX test in all four. dlm_migrate_request_ha=
ndler
and dlm_mig_lockres_handler take the identical u8 field into the identical
32-byte buffer and skip it. The patches just make them consistent with the =
rest
of the receive path. Here the sender's u8 length (up to 255) reaches the 32=
-byte
slab buffer with no bound, and the sender controls the copied bytes too. Th=
at's
a heap OOB write.

The framing is your call as maintainer, and the fix is identical either way=
. If
ocfs2's position is that a joined member is inside the trust boundary, I wo=
n't
argue the CVE -- but these two are attacker-length-and-content-controlled h=
eap
OOB writes, which is why I didn't post them as robustness-only. Either way =
I'd
like the bound to land.

Thanks for the review,
Bryam

