Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9619E45D93E;
	Mon, 12 Oct 2026 08:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793946; cv=none; b=QpzpO6/eYHDr5jDiSEhGoCSgISybDFSBJEMBGuQX9xjWWw7Hezmj4830UA/LO9fhfFJbbSFHLO4noAiCkzqhNx/R9vHoYqBeoubk4y0SSPwOWoai3dYz5vTFC0YCYVGKIaPcwtLWd3HaBcthB9/3lRJXU4qPzmulJqQzzFxB53c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793946; c=relaxed/simple;
	bh=o6YHAXisXGPkGT53HiacCGlu6MfUwDesnH3olIPjqw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSMLU4L+trzk0ovb70xL0Zcob0iyQxuD0WR9rPZjenscO+gjGtlGyCcAkXLTCGDME/z5r5EcgygIH7qAYvVg5v0JPga7WkSnHaJx7Nu59tUPfHqTWQjd1VW3SdXK9mC5EN16Hnjs/R0+v4xqPlwvt24KPwhC3a8Y/WAPrFLTtuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otHfrfC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otHfrfC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307601F0089B;
	Mon, 12 Oct 2026 08:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791793945;
	bh=Y8nI+QkYa0pCoJRDR/dlPZUfNU87uUaFMumLFtNaSNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otHfrfC7yAVpNDJMJnRACWzZ1OEU/6MrC2aLl0vm4X1UTmZS28WBNZoVYmP7ZFQTS
	 /3yj6td+nkay/ZTUNxgprz9adLe2ZXOiSsR0TX7PhEbPqDnRlmShL/fR819ooaWKIl
	 GdSWuqBqpYUvZgnkbveSrIhMBQIZxul+a+G8uYHoFTO3PsMDi176kPmYkuafJ/mVU3
	 Xj/GQbhNga5cX93nbt4ah7pIWBHm36aLvBPPkEtWOudkk0XS5CCobzAcm6cRcshXhT
	 k+Vr0McOUs/6au3O17tr1Yx2cI0hKersu+0HayzxQMAh/DGvCF0z0WY7S+X0ZRSfZa
	 +f7J0aZTYNNHA==
From: Christian Brauner <brauner@kernel.org>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	rollkingzzc@gmail.com,
	jack@suse.cz,
	rppt@kernel.org,
	kees@kernel.org,
	akpm@linux-foundation.org,
	hexlabsecurity@proton.me,
	sunil.mushran@oracle.com,
	Cen Zhang <zzzccc427@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: Re: [PATCH v2] ocfs2/dlm: Protect the recovery list during debugfs reads
Date: Mon, 12 Oct 2026 10:32:17 +0200
Message-ID: <20261012-kassieren-hausordnung-flaute-81acfa151ac2@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <pm-ocfs2-objects-candidate-0049-v3-184e46c47f5283f06191@gmail.com>
References: <pm-ocfs2-objects-candidate-0049-v3-184e46c47f5283f06191@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1280; i=brauner@kernel.org; h=from:subject:message-id; bh=o6YHAXisXGPkGT53HiacCGlu6MfUwDesnH3olIPjqw0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdmS20P/djbQtL1NMjgmf6fzZNtdaKl1q42rHnzLUlW euY1u843lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRCzsY/qlcvae6w0rbhSl+ b6zch0ubJu1tPaE6faHIs15rX8b5xW0M/z3XXwhhka4pdO+c+a7ctq3R9cm33NT5rknK5m5p4Qo m3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Sun, 11 Oct 2026 23:35:06 +0800, Cen Zhang wrote:
> Recovery participant records must remain alive while debug_state_print()
> walks reco.node_data and formats their fields. The formatter holds
> dlm->spinlock, but the recovery participant list is protected by
> dlm_reco_state_lock. In particular, dlm_destroy_recovery_area() detaches
> the list under dlm_reco_state_lock and frees the detached records after
> releasing it. A concurrent debugfs open can therefore read freed memory.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] ocfs2/dlm: Protect the recovery list during debugfs reads
      https://git.kernel.org/vfs/vfs/c/6fe32eb34572
