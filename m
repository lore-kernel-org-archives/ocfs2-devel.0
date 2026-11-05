Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872171;
	b=a54revP/NStcWgEC8PzjubXhgo1xxXzbyW0+PdNtmEpNo/YWgOzVxn4Hi8F4KuQi9qJF
	 KL5VpqVq4h3LTfCVcfgQ2xkd5N/K9EjXKV5JAfmG1B1yGtXmhV6ID6XsoXGL5p1zEVjpp
	 u3/28/SW5uxKNtjOp1xFWoYddLpxWbTfKETAOWWTbzImJRxTVpUp/quprUb2ZGbhTe/CK
	 aTSyJzh11sKLJlJXQSW/cTZ7KHD0Z1sCbSzCksOp+UYTfV5Uaatxd0cKZrMYl3dSreeiu
	 9iYhKd+dCfRg38txhbj7GcPipJ4eQoGm5aCNx1AeSDRVtyoluDa4NCE/dAGEmq3D3bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872171;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6pBoDKtOrThTmnbZPlCKEUfH3xI7nK9JsGtcwaKLx24=;
	b=PS00kuvpm0QYlTzw7eGs9x5uvVRRUqH91z9Yv8D3c3y8lDOY6feZQImRBrs0BTCnfhmt
	 HH9ZxxkQe6LJIkqj5+//PWU1nuPGS2o90oGOi55DMh6TBM8OJPzlxnHcW8C+CGHGVyQkT
	 bxHeRFp3SiIGNKA1Uev8ENScRWrhdjlvm+MrIRNbm4/nesBI4eWoXYwCKNLLEJpnmolKa
	 fZrJw7gZ1/09TsJ8VciSbX/NcbUH6EUmzh+D29ens3plqhzl76PBLUCY5LFG+87xoT3HV
	 kqoTDnVNHCgOn81HLSjmCwire3qK6CmHjDK6HBqXEalVuOZIKAvpfy3M58lsdD3BW3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VjmIiB6I;
	arc=none smtp.remote-ip=115.124.30.112
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07485606A335
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07485606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VjmIiB6I
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872167; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6pBoDKtOrThTmnbZPlCKEUfH3xI7nK9JsGtcwaKLx24=;
	b=VjmIiB6ILsAAF9noApPFbhZfR9sa45JZdSEml+9AbGLcAE7Lme3/HXUhFs+GqOSNn+NIw05L7bs1FDNDtoZKfZ9rYtTKPiXbXe+EtJ8Lz1akv3JfHVLUw6aFwOVe8egIPFn+egMeDUhVHncOHwC5BjNaOdO8s0VwI46cJtbTNZQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZVz_1793872166;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZVz_1793872166 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:27 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 00/30] ocfs2: split dinode validation into shared predicates
Date: Thu,  5 Nov 2026 17:48:56 +0800
Message-Id: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_inode_block() is a flat sequence of about twenty open-coded
on-disk dinode checks.  ocfs2_filecheck_validate_inode_block() duplicates
eight of them, but reports differently: plain mlog() plus an
OCFS2_FILECHECK_ERR_* code instead of ocfs2_error(), because filecheck is
a diagnostic interface an administrator points at a suspect inode and it
must not escalate into ocfs2_handle_error(), which can force the
filesystem read-only or panic.

The duplicated conditions had already drifted apart -- the two
OCFS2_VALID_FL tests were spelled differently -- and filecheck silently
skipped the rest.

This series splits the conditions out and then brings filecheck up to
parity.

Patches 1-20: pure refactor.  Each condition becomes a static bool
ocfs2_dinode_has_*() predicate returning true on bad, following the four
helpers already in inode.c.  Return codes and log messages stay at the
call sites, so the two reporting paths remain distinct and no
ocfs2_error() call site moves.  One check per commit.  No functional
change intended.

Patch 21: a separable fix.  ocfs2_filecheck_repair_inode_block() proceeds
when validation fails but then returns 0 unconditionally, after repairing
only i_blkno, fs_generation and l_next_free_rec.  An inode failing any
other check is reported to userspace as SUCCESS while still corrupt.
This is already true today for the mode, i_rdev and size-without-clusters
checks.  Revalidate after the repairs and return the residual code.  Drop
this patch if you would rather keep the filecheck series purely additive,
but it then widens the set of masked failures considerably.

Patches 22-30: wire the remaining predicates into filecheck.  All reuse
OCFS2_FILECHECK_ERR_INVALIDINO, so no new error code is introduced and the
ocfs2_filecheck_errs[] table with its userspace-visible names is
unchanged.

Points worth a close look:

 - The fast symlink NUL-termination predicate bounds its own strnlen()
   against ocfs2_fast_symlink_chars().  The open-coded version was only
   safe because the preceding i_size check had already bailed; i_size
   comes from disk, so an unbounded strnlen() over i_size + 1 bytes can
   run past the inode block.  A helper should not inherit that ordering
   dependency implicitly, especially once filecheck calls it too.

 - The inline id_count maximum stays a signed int.
   ocfs2_max_inline_data_with_xattr() subtracts the unvalidated
   i_xattr_inline_size and goes negative on small block sizes.  Caching it
   unsigned would turn a negative maximum into a huge bound and silently
   accept the oversized id_count.

 - ocfs2_dinode_is_fast_symlink() is deliberately not shared with the
   similar test inside ocfs2_dinode_has_extents(), which additionally
   requires a non-zero i_size.  A zero-length, zero-cluster symlink
   currently falls through to the extent list checks.

 - The suballoc range predicate keeps its != OCFS2_INVALID_SLOT
   exclusion.  OCFS2_INVALID_SLOT is 65535, so without it every system
   inode mkfs.ocfs2 creates from the global allocator would be rejected.

 - Look-alike tests in suballoc.c are left alone:
   ocfs2_validate_group_descriptor() deliberately permits
   OCFS2_INVALID_SLOT for all inodes, and ocfs2_claim_suballoc_bits() also
   rejects cl_next_free_rec == 0.  Neither is equivalent to the new
   predicates.

The inline xattr check is the one thing filecheck still does not share.
ocfs2_validate_inode_xattr() calls ocfs2_error() through its helpers in
xattr.c, so reusing it would mean threading a reporting flag down into
that file.  Left for a follow-up.

Testing, on top of linux-next 20261103:

Patches 1-20 were checked to be behaviour preserving.  All 27 log
messages, all return codes and all ocfs2_error()/mlog() call sites in
ocfs2_validate_inode_block() are unchanged, each new predicate body was
compared against the condition it replaced, and the disassembly of
ocfs2_filecheck_validate_inode_block() is instruction identical apart
from __LINE__ constants.  The normal validator's disassembly differs by
more than that -- basic blocks are rescheduled and registers reallocated
-- so equivalence there rests on the source level comparison rather than
on an instruction by instruction proof.  The deliberate rewrites are the
ocfs2_read_links_count() reuse in patch 1, the OCFS2_VALID_FL spelling
unification in patch 3, flattening the mutually exclusive suballoc
if/else-if into two tests in patch 5, and the redundant self-bounding
guard added in patch 13.

In a QEMU guest running this series, on 4K blocks with inline-data,
refcount, sparse, usrquota, grpquota, xattr and indexed-dirs enabled:
mount and I/O over seventeen inode types plus all the system inodes
produced no false positive, and filecheck reported SUCCESS for every one
of them.  A separate 512-byte block volume with inline-data, xattr,
sparse and refcount was checked the same way over five inode types, also
with no false positive.

The corruption tests used a third volume formatted with nometaecc, so
that a checksum failure would not mask the field being tested.  Seven
deliberately corrupted dinodes -- zero and oversized extent l_count,
oversized inline id_count, oversized fast symlink i_size, refcount flag
without i_refcount_loc, oversized suballoc bit and oversized
l_next_free_rec -- were each detected with the expected message, with no
ocfs2_error() escalation and the filesystem still read-write afterwards.
fix was then run on two of them: the zero l_count case, which repair
cannot fix, returned INVALIDINO, and the l_next_free_rec case, which it
does fix, returned SUCCESS.

Forcing i_xattr_inline_size up on the 512-byte block volume drove the
inline maximum negative and produced "inline data id_count 312 exceeds
max -88", confirming the signed comparison survived the extraction.

The ocfs2 testsuite and xfstests were not run.

Joseph Qi (30):
  ocfs2: abstract the zero nlink or mode dinode check
  ocfs2: abstract the dinode i_blkno mismatch check
  ocfs2: abstract the dinode OCFS2_VALID_FL check
  ocfs2: abstract the dinode fs_generation mismatch check
  ocfs2: abstract the dinode suballoc slot checks
  ocfs2: abstract the dinode suballoc bit check
  ocfs2: abstract the dinode orphaned slot check
  ocfs2: abstract the dinode DIO orphaned slot check
  ocfs2: abstract the inline data dinode guard and cluster check
  ocfs2: abstract the inline data id_count bound check
  ocfs2: abstract the inline data i_size bound check
  ocfs2: abstract the fast symlink dinode guard and size check
  ocfs2: abstract the fast symlink NUL-termination check
  ocfs2: abstract the chain list dinode guard and count check
  ocfs2: abstract the chain list next free record check
  ocfs2: abstract the chain list bits per cluster check
  ocfs2: abstract the dinode refcount location check
  ocfs2: abstract the zero extent list count check
  ocfs2: abstract the oversized extent list count check
  ocfs2: abstract the extent list next free record check
  ocfs2: report unrepairable corruption from online filecheck fix
  ocfs2: check dinode nlink and mode in online filecheck
  ocfs2: check dinode suballoc slot in online filecheck
  ocfs2: check dinode suballoc bit in online filecheck
  ocfs2: check dinode orphaned slots in online filecheck
  ocfs2: check inline data dinodes in online filecheck
  ocfs2: check fast symlink dinodes in online filecheck
  ocfs2: check chain list dinodes in online filecheck
  ocfs2: check dinode refcount location in online filecheck
  ocfs2: check extent list dinodes in online filecheck

 fs/ocfs2/inode.c | 456 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 399 insertions(+), 57 deletions(-)

-- 
2.39.3

