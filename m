Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C20395AD5
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 May 2026 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778652836; cv=none; b=PaX2m2s3ZUfMyClwLjFJL+K+N8tLgyohor6iCo08B7SfBnXctWHdw1WBBiQbDKQn583qgLG9V3/IEMgces24b7U8jS3DPMxdtIrbMsGbr9a7z2QwNgI6MaP09dJ5vkSQsMmD9lJHADww/OYGybkXnVSSSX+JBkoBLKTdzgoDQWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778652836; c=relaxed/simple;
	bh=Xnfz1y7FbvcRge/3X/bd9hBO1VLlEbtq0jhXEAdBNN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4hUUwghUuwosDgijLdzBPlU8Bi8OeEQfuyQxUKOFnMT0CeQasqPQTxAMN7MiRSgcIJ3a1UaPXVb+u2/1dUOGPmfICI4/gvdqWHOjKptilfrVPC2jjBJRUELH79tyLb8iG4TV4UoiCPBR7oRxP4UruaHI2liBPLOQ4zTqdZ5TNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAHrWiTFgRqWJgWEA--.30032S2;
	Wed, 13 May 2026 14:13:39 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	jlbec@evilplan.org,
	kurt.hackel@oracle.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	xujiakai24@mails.ucas.ac.cn
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested during unmount
Date: Wed, 13 May 2026 06:13:39 +0000
Message-Id: <20260513061339.1389978-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <af0ae50e-1bcf-40cb-820f-aff07af156a5@linux.alibaba.com>
References: <af0ae50e-1bcf-40cb-820f-aff07af156a5@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAHrWiTFgRqWJgWEA--.30032S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur47Jr45KrykXr1rWw1kAFb_yoW8GFWUpF
	1jy34jyw1kGr4xAr47tr18XFy0vr17AF4DXF18Jr1Uuws8Aw4jyr93tr1UCr1DZr4kCw1U
	XF1UCryUGayDZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUnyCJUUUUU
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

> In generic_shutdown_super(), it clears SB_ACTIVE.
> So it seems we can check this flag.

Hi Joseph,

Thank you for the suggestion. I looked into the SB_ACTIVE approach,
but it seems like it still cannot fully close the TOCTOU window.
Let me explain my understanding:

generic_shutdown_super() clears SB_ACTIVE and then calls put_super(),
so checking sb->s_flags & SB_ACTIVE in ocfs2_inode_lock_full_nested()
would access the superblock itself (which is still alive), not osb.
That part is safe. However, consider this race:

    Thread A (inotify_add_watch)          Thread B (umount)
    ─────────────────────────────         ─────────────────────
    read sb->s_flags → SB_ACTIVE set
                                          generic_shutdown_super()
                                            → clear SB_ACTIVE
                                            → put_super
                                              → kfree(osb)
    osb = OCFS2_SB(sb) → osb is freed
    → use osb → UAF

So even with the SB_ACTIVE check at the beginning of
ocfs2_inode_lock_full_nested(), there is still a window between
the flag check and the actual dereference of osb where the
filesystem teardown can complete and free the osb structure.

To be honest, I'm finding it difficult to come up with a clean
solution for this race. I wonder if you or anyone in the community
might have ideas on how to best address it.

Any guidance would be greatly appreciated.

Best regards,
Jiakai

