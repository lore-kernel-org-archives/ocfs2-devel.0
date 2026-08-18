Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871243F0B1;
	Tue, 18 Aug 2026 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044576; cv=none; b=MPXbDV0wcIxkRqKvJ3lTagKKLhscKar3lGcnmXyadEIQ3/uEESbO7rcRhZsKujnsIWP5CMxmtNnRhm7UZ0GufqIuTDsYjllC2dnvoZ4SNB2XI2guwtfslwo12yAnwMut1sMEerfKgCThfsHf5WwVLA40Vf/5QSheWrF/5VSmJ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044576; c=relaxed/simple;
	bh=H0mpcUa8GpkOPZ8m0m0qKErQYEeBOvzJeSQCOCXD4+Y=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=T7gs6qg0nT9gYn/MteUlRF1EAj4RAnSnQNRizamFL9HU+M4fBxkzA+JPrlNNygX/VHSuGiUvjaxh6JcN/nKDtI03bCU91gZ4yMlYh3TGSlZCSIyMq2gwbweREZ7n4jjkNcBsQ+BA7KTHmSuAYtXVb9KscO2RSZr1ssIy2fPgwno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHMXpEvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHMXpEvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5BF1F000E9;
	Tue, 18 Aug 2026 09:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044573;
	bh=DUVOVngiLkxaJNLS6Dc0QbJcxUHKc+hbxsNBPZ/JfUs=;
	h=From:To:Subject:In-Reply-To:References:Date;
	b=LHMXpEvzGwsUfZms27qiNJiQPnZFB7iqqEK/CeVWoxITvzPbO/bl4sRGN7NgPLJRd
	 FO9kd2zDp9KR4trT6GLYxnnU5JuiouNOjJWnuSGswuK6N0g6sAci3UKgT2HugBqF/u
	 DUnuKfnoKId3OHZiV+x6aJ5U0xAlWK7yvC6+yic9pZUZ1zq2V0P8jtlwdeALDsFK3y
	 NwiyyTOOqDL8HDfVYOmbEJvQiP3pPLOBxKxm+fDhTnobfgUOf071sAmm5pL3Bw79cp
	 xI8X9FWkWjXl+G/BeyV469yAEYmdTVunRd59E8secDyYiCL3NlQQB92xhsqwPzTYlD
	 zxxjzIczhxAzw==
From: Thomas Gleixner <tglx@kernel.org>
To: syzbot <syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com>,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, nogikh@google.com,
 ocfs2-devel@lists.linux.dev, syzbot@kernel.org, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com,
 syzkaller-upstream-moderation@googlegroups.com, teddy.astie@vates.tech
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_remove
In-Reply-To: <6a839722.f7a79266.2f965f.002e.GAE@google.com>
References: <6a839722.f7a79266.2f965f.002e.GAE@google.com>
Date: Tue, 18 Aug 2026 11:16:10 +0200
Message-ID: <875x17lrfp.ffs@fw13>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 17 2026 at 16:20, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
>
> commit f24df84cbe05e4471c04ac4b921fc0340bbc7752
> Author: Thomas Gleixner <tglx@kernel.org>
> Date:   Tue Jun 9 15:14:45 2026 +0000
>
>     time/jiffies: Register jiffies clocksource before usage

That is completely unrelated and fixes an early boot issue which
manifest way before you can start your test case.

The lockdep splat is purely about OCFS2 internal locking. Your bisection
took a wrong turn somewhere.

Thanks,

        tglx
