Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139913D1AB5
	for <ocfs2-devel@lists.linux.dev>; Sun, 27 Sep 2026 11:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790507373; cv=none; b=PrUdrtphKyrjL6Ds8yftOS0qsHA33UWvAYh9wdqaReCyKJtYMSgshZeC55zkGNW9MNv8PWDrJWfJgo2DaxrPChIuPozm3gj5eFmqWQwyoKG8D8E2O92VZ26ciwR4FU9v4yJxYZUG5n8cs0ALGn0sW23q5iOglR4s+vQzvDy27fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790507373; c=relaxed/simple;
	bh=Z232fkqmBSqnY/i4iSKSELPwmDRECacG3kEOk3fm3Ak=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Uowcup8y4ksw1cI0VtBQFKaMgqjTlukScdrIiaD9N4jhUhGhB5oP9KlaDvvvaAWz1TQU6iDQYu0TzaP09j2hveIe6KcaTazwSok66NgiKgV7ixKopsKub/Bw3Z2EUh3QYtUxtt3x0Y/uEGPXEiSR1aGQrcNbWuGBEZ4I4Rf+G0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=SXabLuGR; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="SXabLuGR"
Received: from mail.ispras.ru (unknown [83.149.199.84])
	by mail.ispras.ru (Postfix) with ESMTPSA id 4E38340ACE1C;
	Sun, 27 Sep 2026 11:04:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4E38340ACE1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1790507045;
	bh=pEwqmaQGVJMOUs+I+q+ouqHz6Y36+m3fssmb0zfY2Fo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SXabLuGRuw2PZglTQ9WoCwbLOS97SfREFBWpDGBWWZh3W5vJnX+HkAYn5a5vUSX8N
	 gfgqu8hZCOk4z2ZegiAqwKd5+O500RuCuEyPZP2tO5jZ7yTTNKEnwr3k7Z7RbE0F/j
	 xrQjNO9rZLn4ikxXGeQOnYb4VAo6C1AJ/RY8dQG0=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sun, 27 Sep 2026 14:04:05 +0300
From: d.morgun@ispras.ru
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: validate la_size before ocfs2_clear_local_alloc()
In-Reply-To: <2927fd14-46be-4cb1-8dac-0f4249f16014@linux.alibaba.com>
References: <20260810113508.8513-1-d.morgun@ispras.ru>
 <2927fd14-46be-4cb1-8dac-0f4249f16014@linux.alibaba.com>
Message-ID: <e13b47fa02d27dbf4c44ae300fc082a6@ispras.ru>
X-Sender: d.morgun@ispras.ru
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/26 9:57 AM, Joseph Qi wrote:
> I think we can validate localalloc inode during block read in
> ocfs2_validate_inode_block(), which will drop the duplicate code in
> callers.

Hi Joseph,

Thanks for the suggestion. I moved the la_size check there, and it
does catch the current reproducer during mount. Before dropping the
duplicate checks in ocfs2_begin_local_alloc_recovery() and
ocfs2_load_local_alloc(), I'd like to raise two concerns:

1. ocfs2_begin_local_alloc_recovery() reads the inode with
    OCFS2_BH_IGNORE_CACHE, and ocfs2_read_blocks() skips validation
    for dirty buffers. I traced through jbd2 replay: 
ocfs2_replay_journal()
    calls jbd2_journal_flush() right after jbd2_journal_load(), and
    jbd2_journal_recover() itself calls sync_blockdev(), which should
    clear the dirty flag before ocfs2_begin_local_alloc_recovery() runs.
    So this may not be reachable in practice, but I haven't been able
    to confirm it directly. The current reproducer hits the
    validator with a clean buffer during the initial mount, before
    recovery is reached at all. Is it possible to confirm that the
    buffer is guaranteed to be clean by that point?

2. The check is gated on OCFS2_LOCAL_ALLOC_FL, but
    ocfs2_validate_inode_block() doesn't receive the inode's expected
    type, so it can't verify that the on-disk flags actually match
    what the caller expects. A corrupted local alloc inode with the
    flag cleared would skip the check, even though
    ocfs2_clear_local_alloc() still treats its id2 as i_lab. Is there
    an existing way to check this correspondence? Otherwise, this
    might call for a separate per-type validation helper that takes
    the expected inode type, which could also help elsewhere.

My inclination is: v1 (the check directly in
ocfs2_begin_local_alloc_recovery() and ocfs2_load_local_alloc())
has held up in testing so far, with a small additional fix on my
end. Both call sites operate in the LOCAL_ALLOC_SYSTEM_INODE context
and check la_size before using id2 as i_lab, so they do not depend on
OCFS2_LOCAL_ALLOC_FL for deciding whether to validate la_size.
Returning this new error also made a separate, pre-existing bug in
the recovery thread reachable, for which I have a small follow-up
fix.

If the two concerns with ocfs2_validate_inode_block() can be
addressed without too much churn, I agree it is the better place
for this check, since it would cover every caller uniformly.
Otherwise, I'd rather keep it in v1's approach.

Does this seem reasonable, or would you weigh it differently?

Thanks,
Dmitry
