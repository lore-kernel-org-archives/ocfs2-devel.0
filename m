Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C5374178
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 May 2026 05:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033157; cv=pass; b=V50k6EkH2glkp63wlGWh2pGPIY7uIDZYcniCqEZsDP3jS8f/48WMLiW8/3eE0D59IQnhQJw+INLl4+Pjq5NtB7EjDxZkOC1sXzOyzC6HVhek3PSsP+DCWIW+XQ8w0eQxNNzQWTCk+Kw12Bu7y7vjaWjWTf0lITpOzXAm8dvVHDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033157; c=relaxed/simple;
	bh=cIz4IXUEDoFUoxclFspBGU8qSLhJ0Mk1kU7uqi9hgdw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HVL/JeJ5IZT9cRrv2yYguLvBgp3tvFwoFLHB30K8SactW5JqNHgy188xB3vW+oHLDB71ahs3RqMNIFFHlVE/I5HEa6lUWs2wbHxiK6J0VbOxFohc2PMckrMJNp48LP8489MRGdcPizIjv9edc5YAILxq360KndkuScpln+Eg9yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=dgP/FFAT; arc=pass smtp.client-ip=209.85.128.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="dgP/FFAT"
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-7b4ee3a88e1so130328457b3.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 22:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780033155; cv=none;
        d=google.com; s=arc-20240605;
        b=dy0G1yoVkvcFoX/y8SYnw8k0itcnLD1sozWTC2hEjBFOR+mkvqfU418xf2y2e+jRWC
         IL9WkGoU5lJ+fI9SuUGqOq3wKQo+nICoKX9FE+xi6vwflwTnaAQKeNiJS5Yd5MoI8ZyX
         QQxwOBxsvWFpZL70cWqnWh2mcofUoaIWLzzfGcQngCjEZW9S14wfdMuux+3e21AXrJgD
         v0Ou5jepFyvsq38DDuPRX6HIwKa3VpJVRoFP9ZUAEaZTyEnbJpeastyV151nGcTrWdFF
         Dt8K8rqHJ2XDYsxf5Y8xBu4/2+VA5mQ5mOEF25F1lJJQldhyHv1oVXK5UYUad7kkCqnx
         03sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uh9rb4RR9J5qbJnM29BNM5OXl5WYkdGt8ID4buPiHd8=;
        fh=Tq/wB0tKGmJOQTTvAyTg6xhnWZcB1u/gHdX9lX1gySs=;
        b=kSYl11hHYXNPDX5n2NLd/wUgaBzS42ELsMtKSO7dxOdKbS7KzENLDUjDviCYOXtrP2
         vy5MWBm/xaCXlTSdyv5ovwwmIMx43eVuBcijOED7l332tkb2GIgzxdR5OoW90waecwZg
         LcIXflMmtRZPBdz8hTm19RJvNV1Old3WcJDSqTSiQzQIxlElT/Vt3qXUHXWb/+BE1wP2
         jVCIrgxMtdqjtl5onD2u7Y4ZWMa5nNEeaerpD9AKJeZAYUM2zNI+42iA6ZEqKV3DRvZR
         XqkWxNkdw+77WFq5saPZ2yBV8J2T3p0YtwhVziftp+P+3g4dZuCky5GF9/mxsPAkJMGw
         O2FA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1780033155; x=1780637955; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uh9rb4RR9J5qbJnM29BNM5OXl5WYkdGt8ID4buPiHd8=;
        b=dgP/FFAT5iqa+4ad3ydU188inXqKlEVWP/8omWHPN8gehwI+RKDIfVffqE/3NX45ov
         yMPv/oULHjFH7cfpTfnXF4Ay45bGgqk4fhW6FPU3xx+WCVH4So07tWk1lqQtWX+/jiKN
         0LnpsojdBwhnx8pLdzKIzkKfE7hH87jNP3E6JtCf7pbBO3KV4MYy85qEEhqHKC0id+0a
         1JAfH20D/enNoaR/PUgLTUo0j97JNSZNB0OBX7kZp22zomPgvbQlRf/Q99eabrtJdBCm
         Al2s9VvniEIZ3U3PSA7e96lolLuW/4Jjvgx1VfkgBKudhKT/mKKx+p9bBlBGGKiPAcfj
         3V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780033155; x=1780637955;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uh9rb4RR9J5qbJnM29BNM5OXl5WYkdGt8ID4buPiHd8=;
        b=dKmRFY8tmUurfdVyKsa8K+aKEqAoVJ12Ke/K5oTvmN6aODu3rn9BksS88HsuhdUyuV
         mZhSZhWKn7KzoDorf5uxFnuMaZT4RU1TOCBupfihZ6u8IHTzJu7sqf+Fhy/mnZ5OmAXC
         uk2K1jH96V048/8L3Siyjy6JLE9kpqo21BbpW5I2iXOJlBWMchxb85JLScvVErlrrHVB
         h872AjnkENnff4PdyuFEsisRkDzC8nBDvjrCkVkx/aE06+WVhNVqm+wR8pxcmSHv8yaM
         hJiEiGGQ+jPEnJxkKT+LstcAJMkvEtz9Aoou/ogDbuiaYw9/XVwmY0uNGfoaohpVpYVM
         Sk9w==
X-Forwarded-Encrypted: i=1; AFNElJ9t2rhUW2eCnT6LOT54xuYbqik+Iy2QYSZnM9q+1nrsEjgf1DE/5Y9USHJU46DJCaTWysqujJOR8WUxQw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2xQpsdT1GwobFCNM7BQg2wxIlOIEuz3XRx4iAU+/pfUlLzL5Q
	1c3E3fUUs7t/XhhK9vCpDvBIbSZLkq6eT9qxlI9TVWJAvRJkWeh2/vjGBxu8ofFN88YuEXl16/U
	rpf1FRyLjG29oK1LWb+gqzMHnTrDmiU+pvhxHe2XR
X-Gm-Gg: Acq92OE67tfNpI0XrhYjwn9+w0GZCQcmvXx51MOJWn/2GL2KnRlGPEz6jjIA9emDgLE
	Q+7ixq3269C6f0Q/c+E3fiEUzjwA3zPP/bJEnE3MjmhQQ2XPP9RVU+WU94hGepyaGZsLdfPUZwM
	rVUHIIsnI/OxPH7xfivvprGQbFuHsP/6PXlHXqEHYLJQhvBg9tHgGb+XMZno19VkaL6ZVHfcBBp
	I2Bw5a+f1tpgVDJqVthftxEPPeEEZ/vG6rCQ01S3q0gbsg+a7s5JiRc26Cv7DKU5wDNzf17hGCJ
	5Sq3l50ywjlrXVC+bw4NgdgDd8w0WOSbrNvnd5gdsJX8w578iaVX
X-Received: by 2002:a05:690c:360e:b0:7dc:2161:bde0 with SMTP id
 00721157ae682-7de4cf7db41mr10380267b3.37.1780033153787; Thu, 28 May 2026
 22:39:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Thu, 28 May 2026 22:39:02 -0700
X-Gm-Features: AVHnY4KGK8PWxSBJldOaJUXgz1d9-vve8tgrMHCDemeKYgX31KUfTRgWj5rz5Gw
Message-ID: <CA+0ovCjF9enBdtPGJ-b=ewXnZBV0QmjThaOrvhOx0KavCFft5Q@mail.gmail.com>
Subject: [BUG] ocfs2: NULL osb->journal deref via ocfs2_checkpoint_inode on unmount
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: falemi@asu.edu, Tiffany Bao <tbao@asu.edu>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d30f490652ee43d9"

--000000000000d30f490652ee43d9
Content-Type: text/plain; charset="UTF-8"

Hello Joseph, Mark, Joel, and the ocfs2 team,

I am reporting a KASAN null-ptr-deref GPF in the ocfs2 unmount path
found by syzkaller as part of research at the SEFCOM Lab at ASU.

Summary:
During unmount, ocfs2_clear_inode() calls ocfs2_checkpoint_inode()
without checking that osb->journal is still live. At
fs/ocfs2/inode.c:1223-1224:

  if (!(oi->ip_flags & OCFS2_INODE_DELETED))
          ocfs2_checkpoint_inode(inode);

ocfs2_checkpoint_inode() (fs/ocfs2/journal.h:192) reaches
ocfs2_ci_fully_checkpointed() (fs/ocfs2/journal.h:91), which loads
osb->journal and dereferences it:

  struct ocfs2_journal *journal =
          OCFS2_SB(ocfs2_metadata_cache_get_super(ci))->journal;
  spin_lock(&trans_inc_lock);
  ret = time_after(journal->j_trans_id, ci->ci_last_trans);   <-- :98

On the unmount-side slot-info eviction, ocfs2_journal_shutdown() has
already set osb->journal = NULL (fs/ocfs2/journal.c:1130) before
ocfs2_delete_osb() evicts the slot inodes, so the journal->j_trans_id
load at journal.h:98 faults. The KASAN range is [0x70, 0x77] (see
crash-report.txt); the RIP chain is:

  ocfs2_ci_fully_checkpointed fs/ocfs2/journal.h:98 [inline]
  ocfs2_checkpoint_inode fs/ocfs2/journal.h:199 [inline]
  ocfs2_clear_inode fs/ocfs2/inode.c:1224 [inline]
  ocfs2_evict_inode+0x244c/0x43c0 fs/ocfs2/inode.c:1303

Observed on:
- Linux v7.1-rc3-200-g70eda68668d1-dirty,
  x86_64, QEMU Q35
- KASAN enabled
- The only local dirty file in my tree is
  drivers/tty/serial/serial_core.c, a ttyS0 console guard for the
  fuzzing harness, unrelated to fs/ocfs2/.
- Source inspection of linus/master at commit e8c2f9fdadee
  (v7.1-rc4-754-ge8c2f9fdadee) shows the structure is unchanged:
  ocfs2_clear_inode() at fs/ocfs2/inode.c:1223-1224 still calls
  ocfs2_checkpoint_inode() with no osb->journal check, and
  ocfs2_ci_fully_checkpointed() at fs/ocfs2/journal.h:98 still
  dereferences journal->j_trans_id unconditionally. As no reproducer
  is available for this seed, I have not re-run it against e8c2f9fdadee.

Impact:
An ocfs2 unmount kills the kernel with a GPF / KASAN null-ptr-deref.
The full Oops header, register dump, and call trace are in
crash-report.txt.

Expected behavior:
Either ocfs2_clear_inode() should skip ocfs2_checkpoint_inode() when
osb->journal is NULL (the same shape as the existing guard at
fs/ocfs2/inode.c:1286), or ocfs2_ci_fully_checkpointed() should treat
a NULL journal as "fully checkpointed".

Reproducer:
A standalone .syz or C reproducer was not produced for this seed; the
crash fired during automated ocfs2 mount/unmount fuzzing. The console
report is attached as crash-report.txt.

Novelty check:
I searched the syzbot dashboard's upstream open, fixed, stable, and
invalid (per-subsystem ocfs2) namespaces; the Android dashboard; the
marc.info linux-fsdevel archive; and lore, for
"ocfs2_ci_fully_checkpointed", "ocfs2_checkpoint_inode",
"ocfs2_clear_inode" + journal, and "ocfs2_evict_inode" + GPF. I did
not find a prior report of this specific dereference.

There are three closely related syzbot reports, all titled by the
outer frame:
"general protection fault in ocfs2_evict_inode" (id 9d4aa7d1...),
"general protection fault in ocfs2_clear_inode" (id 9eca3ca3...),
and "...ocfs2_clear_inode (2)" (id 9e34a0dc...). They share this
unmount slot-info eviction reach path but fault at offset 0x8 of the
NULL pointer (KASAN range [0x8, 0xf]); this crash faults at offset
0x70, inside ocfs2_ci_fully_checkpointed() at journal.h:98 (the
journal->j_trans_id read) -- a distinct dereference site. Commit
f46e8ef8bb7b ("ocfs2: prevent release journal inode after journal
shutdown", first in v6.17-rc5) added an osb->journal guard before the
jbd2_journal_release_jbd_inode() call at fs/ocfs2/inode.c:1286, but
the earlier ocfs2_checkpoint_inode() call in the same
ocfs2_clear_inode() is not guarded.


I appreciate your time and consideration, and I'm grateful for your
work on this subsystem. I'd be glad to test any candidate patches.

Regards,

--000000000000d30f490652ee43d9
Content-Type: text/plain; charset="US-ASCII"; name="crash-report.txt"
Content-Disposition: attachment; filename="crash-report.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mpqhq8z50>
X-Attachment-Id: f_mpqhq8z50

b2NmczI6IFVubW91bnRpbmcgZGV2aWNlICg3LDMpIG9uIChub2RlIDApCk9vcHM6IGdlbmVyYWwg
cHJvdGVjdGlvbiBmYXVsdCwgcHJvYmFibHkgZm9yIG5vbi1jYW5vbmljYWwgYWRkcmVzcyAweGRm
ZmZmYzAwMDAwMDAwMGU6IDAwMDAgWyMxXSBTTVAgS0FTQU4gTk9QVEkKS0FTQU46IG51bGwtcHRy
LWRlcmVmIGluIHJhbmdlIFsweDAwMDAwMDAwMDAwMDAwNzAtMHgwMDAwMDAwMDAwMDAwMDc3XQpD
UFU6IDAgVUlEOiAwIFBJRDogODEzMSBDb21tOiBzeXotZXhlY3V0b3IgTm90IHRhaW50ZWQgNy4x
LjAtcmMzLTAwMjAwLWc3MGVkYTY4NjY4ZDEtZGlydHkgIzEgUFJFRU1QVChmdWxsKSAKSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoUTM1ICsgSUNIOSwgMjAwOSksIEJJT1MgMS4xNi4z
LWRlYmlhbi0xLjE2LjMtMiAwNC8wMS8yMDE0ClJJUDogMDAxMDpvY2ZzMl9jaV9mdWxseV9jaGVj
a3BvaW50ZWQgZnMvb2NmczIvam91cm5hbC5oOjk4IFtpbmxpbmVdClJJUDogMDAxMDpvY2ZzMl9j
aGVja3BvaW50X2lub2RlIGZzL29jZnMyL2pvdXJuYWwuaDoxOTkgW2lubGluZV0KUklQOiAwMDEw
Om9jZnMyX2NsZWFyX2lub2RlIGZzL29jZnMyL2lub2RlLmM6MTIyNCBbaW5saW5lXQpSSVA6IDAw
MTA6b2NmczJfZXZpY3RfaW5vZGUrMHgyNDRjLzB4NDNjMCBmcy9vY2ZzMi9pbm9kZS5jOjEzMDMK
Q29kZTogYzEgZWMgMDMgNDMgODAgM2MgMmMgMDAgNzQgMDggNDggODkgZGYgZTggM2MgZDEgZDYg
ZmUgNGMgOGIgMmIgNDkgODMgYzYgNzAgNGMgODkgZjAgNDggYzEgZTggMDMgNDggYjkgMDAgMDAg
MDAgMDAgMDAgZmMgZmYgZGYgPDgwPiAzYyAwOCAwMCA3NCAwOCA0YyA4OSBmNyBlOCAxNiBkMSBk
NiBmZSA0ZCA4YiAzNiA0OCBjNyBjNyBhMCA4OQpSU1A6IDAwMTg6ZmZmZmM5MDAwMDU1NzMyMCBF
RkxBR1M6IDAwMDEwMjAyClJBWDogMDAwMDAwMDAwMDAwMDAwZSBSQlg6IGZmZmY4ODgxMmU3MjI0
MjggUkNYOiBkZmZmZmMwMDAwMDAwMDAwClJEWDogMDAwMDAwMDAwMDAwMDAwMSBSU0k6IDAwMDAw
MDAwMDAwMDAwMDQgUkRJOiBmZmZmYzkwMDAwNTU3MmEwClJCUDogZmZmZmM5MDAwMDU1N2E1MCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDMgUjA5OiAwMDAwMDAwMDAwMDAwMDA0ClIxMDogZGZmZmZjMDAw
MDAwMDAwMCBSMTE6IGZmZmZmNTIwMDAwYWFlNTQgUjEyOiAxZmZmZjExMDI1Y2U0NDg1ClIxMzog
MDAwMDAwMDAwMDAwMDAwMCBSMTQ6IDAwMDAwMDAwMDAwMDAwNzAgUjE1OiBmZmZmZjUyMDAwMGFh
ZTc0CkZTOiAgMDAwMDU1NTU2YTBmODUwMCgwMDAwKSBHUzpmZmZmODg4MmFiNmI2MDAwKDAwMDAp
IGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDog
MDAwMDAwMDA4MDA1MDAzMwpDUjI6IDAwMDA3ZmZjNjU0ZjJkNjAgQ1IzOiAwMDAwMDAwMTRhYWY3
MDAwIENSNDogMDAwMDAwMDAwMDc1MGVmMApEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAw
MDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApEUjM6IDAwMDAwMDAwMDAwMDAwMDAg
RFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDYwMApQS1JVOiA4MDAwMDAw
MApDYWxsIFRyYWNlOgogPFRBU0s+CiBldmljdCsweDYyMy8weGIxMCBmcy9pbm9kZS5jOjg0MQog
X19vY2ZzMl9mcmVlX3Nsb3RfaW5mbyBmcy9vY2ZzMi9zbG90X21hcC5jOjMxMSBbaW5saW5lXQog
b2NmczJfZnJlZV9zbG90X2luZm8rMHg3ZS8weDI2MCBmcy9vY2ZzMi9zbG90X21hcC5jOjQ2NQog
b2NmczJfZGVsZXRlX29zYisweDVkLzB4MTgwIGZzL29jZnMyL3N1cGVyLmM6MjQ1MAogb2NmczJf
ZGlzbW91bnRfdm9sdW1lKzB4NTdkLzB4OGUwIGZzL29jZnMyL3N1cGVyLmM6MTg4NAogZ2VuZXJp
Y19zaHV0ZG93bl9zdXBlcisweDE0Mi8weDJkMCBmcy9zdXBlci5jOjY0Ngoga2lsbF9ibG9ja19z
dXBlcisweDQ5LzB4YTAgZnMvc3VwZXIuYzoxNzI1CiBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisw
eGMxLzB4MTMwIGZzL3N1cGVyLmM6NDc2CiBjbGVhbnVwX21udCsweDQzYy8weDRlMCBmcy9uYW1l
c3BhY2UuYzoxMzEyCiB0YXNrX3dvcmtfcnVuKzB4MWRlLzB4MjcwIGtlcm5lbC90YXNrX3dvcmsu
YzoyMzMKIHJlc3VtZV91c2VyX21vZGVfd29yayBpbmNsdWRlL2xpbnV4L3Jlc3VtZV91c2VyX21v
ZGUuaDo1MCBbaW5saW5lXQogX19leGl0X3RvX3VzZXJfbW9kZV9sb29wIGtlcm5lbC9lbnRyeS9j
b21tb24uYzo2NyBbaW5saW5lXQogZXhpdF90b191c2VyX21vZGVfbG9vcCsweGU3LzB4NGIwIGtl
cm5lbC9lbnRyeS9jb21tb24uYzo5OAogX19leGl0X3RvX3VzZXJfbW9kZV9wcmVwYXJlIGluY2x1
ZGUvbGludXgvaXJxLWVudHJ5LWNvbW1vbi5oOjIwNyBbaW5saW5lXQogc3lzY2FsbF9leGl0X3Rv
X3VzZXJfbW9kZV9wcmVwYXJlIGluY2x1ZGUvbGludXgvaXJxLWVudHJ5LWNvbW1vbi5oOjIzOCBb
aW5saW5lXQogc3lzY2FsbF9leGl0X3RvX3VzZXJfbW9kZSBpbmNsdWRlL2xpbnV4L2VudHJ5LWNv
bW1vbi5oOjMxOCBbaW5saW5lXQogZG9fc3lzY2FsbF82NCsweDMzZS8weDU2MCBhcmNoL3g4Ni9l
bnRyeS9zeXNjYWxsXzY0LmM6MTAwCiBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3
Ny8weDdmClJJUDogMDAzMzoweDdmMmM0MTYwOTE4YgpDb2RlOiAzYiAxNiAwMCAwMCA2NiAyZSAw
ZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCA5MCBmMyAwZiAxZSBmYSAzMSBmNiBlOSAwNSAwMCAwMCAw
MCAwZiAxZiA0NCAwMCAwMCBmMyAwZiAxZSBmYSBiOCBhNiAwMCAwMCAwMCAwZiAwNSA8NDg+IDNk
IDAwIGYwIGZmIGZmIDc3IDA1IGMzIDBmIDFmIDQwIDAwIDQ4IGM3IGMyIGIwIGZmIGZmIGZmIGY3
IGQ4ClJTUDogMDAyYjowMDAwN2ZmYzY1NGYzNDI4IEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6
IDAwMDAwMDAwMDAwMDAwYTYKUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDdmMmM0MTZh
ZGZlZCBSQ1g6IDAwMDA3ZjJjNDE2MDkxOGIKUkRYOiAwMDAwN2YyYzQxNGIzNWMxIFJTSTogMDAw
MDAwMDAwMDAwMDAwOSBSREk6IDAwMDA3ZmZjNjU0ZjM0ZTAKUkJQOiAwMDAwN2ZmYzY1NGYzNGUw
IFIwODogMDAwMDAwMDAwMDAwMDA3MyBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEwOiAwMDAwMDAw
MDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDA3ZmZjNjU0ZjQ1YjAKUjEz
OiAwMDAwN2YyYzQxNmFkZmVkIFIxNDogMDAwMDAwMDAwMDAwMDAzMiBSMTU6IDAwMDAwMDAwMDAw
ODA1OTkKIDwvVEFTSz4KTW9kdWxlcyBsaW5rZWQgaW46Ci0tLVsgZW5kIHRyYWNlIDAwMDAwMDAw
MDAwMDAwMDAgXS0tLQpSSVA6IDAwMTA6b2NmczJfY2lfZnVsbHlfY2hlY2twb2ludGVkIGZzL29j
ZnMyL2pvdXJuYWwuaDo5OCBbaW5saW5lXQpSSVA6IDAwMTA6b2NmczJfY2hlY2twb2ludF9pbm9k
ZSBmcy9vY2ZzMi9qb3VybmFsLmg6MTk5IFtpbmxpbmVdClJJUDogMDAxMDpvY2ZzMl9jbGVhcl9p
bm9kZSBmcy9vY2ZzMi9pbm9kZS5jOjEyMjQgW2lubGluZV0KUklQOiAwMDEwOm9jZnMyX2V2aWN0
X2lub2RlKzB4MjQ0Yy8weDQzYzAgZnMvb2NmczIvaW5vZGUuYzoxMzAzCkNvZGU6IGMxIGVjIDAz
IDQzIDgwIDNjIDJjIDAwIDc0IDA4IDQ4IDg5IGRmIGU4IDNjIGQxIGQ2IGZlIDRjIDhiIDJiIDQ5
IDgzIGM2IDcwIDRjIDg5IGYwIDQ4IGMxIGU4IDAzIDQ4IGI5IDAwIDAwIDAwIDAwIDAwIGZjIGZm
IGRmIDw4MD4gM2MgMDggMDAgNzQgMDggNGMgODkgZjcgZTggMTYgZDEgZDYgZmUgNGQgOGIgMzYg
NDggYzcgYzcgYTAgODkKUlNQOiAwMDE4OmZmZmZjOTAwMDA1NTczMjAgRUZMQUdTOiAwMDAxMDIw
MgpSQVg6IDAwMDAwMDAwMDAwMDAwMGUgUkJYOiBmZmZmODg4MTJlNzIyNDI4IFJDWDogZGZmZmZj
MDAwMDAwMDAwMApSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiAwMDAwMDAwMDAwMDAwMDA0IFJE
STogZmZmZmM5MDAwMDU1NzJhMApSQlA6IGZmZmZjOTAwMDA1NTdhNTAgUjA4OiAwMDAwMDAwMDAw
MDAwMDAzIFIwOTogMDAwMDAwMDAwMDAwMDAwNApSMTA6IGRmZmZmYzAwMDAwMDAwMDAgUjExOiBm
ZmZmZjUyMDAwMGFhZTU0IFIxMjogMWZmZmYxMTAyNWNlNDQ4NQpSMTM6IDAwMDAwMDAwMDAwMDAw
MDAgUjE0OiAwMDAwMDAwMDAwMDAwMDcwIFIxNTogZmZmZmY1MjAwMDBhYWU3NApGUzogIDAwMDA1
NTU1NmEwZjg1MDAoMDAwMCkgR1M6ZmZmZjg4ODJhYjZiNjAwMCgwMDAwKSBrbmxHUzowMDAwMDAw
MDAwMDAwMDAwCkNTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAw
MzMKQ1IyOiAwMDAwN2ZmYzY1NGYyZDYwIENSMzogMDAwMDAwMDE0YWFmNzAwMCBDUjQ6IDAwMDAw
MDAwMDA3NTBlZjAKRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBE
UjI6IDAwMDAwMDAwMDAwMDAwMDAKRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBm
ZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA2MDAKUEtSVTogODAwMDAwMDAKLS0tLS0tLS0tLS0t
LS0tLQpDb2RlIGRpc2Fzc2VtYmx5IChiZXN0IGd1ZXNzKToKICAgMDoJYzEgZWMgMDMgICAgICAg
ICAgICAgCXNociAgICAkMHgzLCVlc3AKICAgMzoJNDMgODAgM2MgMmMgMDAgICAgICAgCWNtcGIg
ICAkMHgwLCglcjEyLCVyMTMsMSkKICAgODoJNzQgMDggICAgICAgICAgICAgICAgCWplICAgICAw
eDEyCiAgIGE6CTQ4IDg5IGRmICAgICAgICAgICAgIAltb3YgICAgJXJieCwlcmRpCiAgIGQ6CWU4
IDNjIGQxIGQ2IGZlICAgICAgIAljYWxsICAgMHhmZWQ2ZDE0ZQogIDEyOgk0YyA4YiAyYiAgICAg
ICAgICAgICAJbW92ICAgICglcmJ4KSwlcjEzCiAgMTU6CTQ5IDgzIGM2IDcwICAgICAgICAgIAlh
ZGQgICAgJDB4NzAsJXIxNAogIDE5Ogk0YyA4OSBmMCAgICAgICAgICAgICAJbW92ICAgICVyMTQs
JXJheAogIDFjOgk0OCBjMSBlOCAwMyAgICAgICAgICAJc2hyICAgICQweDMsJXJheAogIDIwOgk0
OCBiOSAwMCAwMCAwMCAwMCAwMCAJbW92YWJzICQweGRmZmZmYzAwMDAwMDAwMDAsJXJjeAogIDI3
OglmYyBmZiBkZgoqIDJhOgk4MCAzYyAwOCAwMCAgICAgICAgICAJY21wYiAgICQweDAsKCVyYXgs
JXJjeCwxKSA8LS0gdHJhcHBpbmcgaW5zdHJ1Y3Rpb24KICAyZToJNzQgMDggICAgICAgICAgICAg
ICAgCWplICAgICAweDM4CiAgMzA6CTRjIDg5IGY3ICAgICAgICAgICAgIAltb3YgICAgJXIxNCwl
cmRpCiAgMzM6CWU4IDE2IGQxIGQ2IGZlICAgICAgIAljYWxsICAgMHhmZWQ2ZDE0ZQogIDM4Ogk0
ZCA4YiAzNiAgICAgICAgICAgICAJbW92ICAgICglcjE0KSwlcjE0CiAgM2I6CTQ4ICAgICAgICAg
ICAgICAgICAgIAlyZXguVwogIDNjOgljNyAgICAgICAgICAgICAgICAgICAJLmJ5dGUgMHhjNwog
IDNkOgljNyAgICAgICAgICAgICAgICAgICAJKGJhZCkKICAzZToJYTAgICAgICAgICAgICAgICAg
ICAgCS5ieXRlIDB4YTAKICAzZjoJODkgICAgICAgICAgICAgICAgICAgCS5ieXRlIDB4ODkKCjw8
PDw8PDw8PDw8PDw8PCB0YWlsIHJlcG9ydCA+Pj4+Pj4+Pj4+Pj4+Pj4KCg==
--000000000000d30f490652ee43d9--
