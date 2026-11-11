Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794364510;
	b=nJZCisZ8ixaq3FA/AfWVtSnmnT0gPnZi/EpamyQIMB4TLxJUOAtFm3L8sf5jrSjaVJp2
	 Hc6q2SFF2xarAkYLlvROuHrsvRvZDQ4NSSmoj6JsYT/zhPS/rZ7I2i2QlVAx99rTWkIeK
	 FRIA64t44Du9Gqm+OQlm80gMfX69IoWLILVUsmzspOc80/3VNq/6GEJuVQREjD0f+7za/
	 lKOKIzr30njrSqmpqQcu6GO5yCSy3iW764OcoQgGwLSOjbnRJ/BZtLysFR5adh3xOxYeM
	 jCQ27UJEykFgET7RJBqTFgjRo5nTUQvCCNyWUgTwOj8p9/TE9EfCisFa0lWRJi2ta6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794364510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pvFlzi2o7O4yiwN3RVeD+t8QNKHH1e+ewDHzVj4XZ1I=;
	b=tAnUfNt4T60czLFmMUt1+lt2t0K/5xz7dp7f890zUt25+fJAdZLOSCEjnalmMPVlUOQU
	 3+MQVAxE1SFyad1vE+/5FmpaNl9I6uvAYNg6iNiOEedJTcPhs6xrCIpUspp4ull65VWhK
	 LwXx7/LOJyCVRLwwJo2mpXJF/adEJFaXDGtece0z1393cNyYI9yHV2KBd90GgD91+vFcN
	 MKQLaB+Gs4sQdbteDK4wbx852IObIMM69fSCuHVV4i1I+9T57gSz0m4h8lkIgnPIqodmv
	 BFsPxuzOBpSMsg19x1rHywg5hzvdX9uX5StXAW7l3k+4ENnBvGY6bXPVXzc5Bly4j3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QxDRIKeW;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BA2606A320
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Nov 2026 02:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15BA2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QxDRIKeW
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so34909395e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 18:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794364508; x=1794969308; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pvFlzi2o7O4yiwN3RVeD+t8QNKHH1e+ewDHzVj4XZ1I=;
        b=QxDRIKeWUjIcqbP8umQE5CvNLJVehTnddYOLb3E+BuczQ2w1GdPcwvQbaLFb68xVbt
         m1H+QQK3yRwwsPcavLDEfp7HoEZFbnN0wH6gGWGFCF5PsosaMRKnVB+5mouoUMJE+EkU
         tSdPtehCDAAdt4HmM66LbEpsMHeUIcFdWec5ffZjLrhyMPuTrYJPk3Zpgh5LAP/UVFgM
         Q3FL+XJtOSUJRTPmJr1wc1Tz/ldZcmzlUe2wTv7P/jZoe3hMk7O9vfJu3jJSIxJg4eLY
         3Drxvrzv0avq+vwhVo5R+JpGp23spKuns3/VaXqEIoC2i9BNwagZxIlfN5Y/gvlzxlIk
         BC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794364508; x=1794969308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pvFlzi2o7O4yiwN3RVeD+t8QNKHH1e+ewDHzVj4XZ1I=;
        b=Yk1e0Y57FHnhvPCMYoQKyOTBhZViaxim7Ku4KXIgtV7YRu8hmIQEe35qlAYPkJDtJs
         jQ+/8OOeTYzs0OOIWSY7/jnkPmnRMrOIr3cTgr5iiGmuKt1Fafth76Sc5SN7YW0IVWbV
         uK+3Q8Pmi4IDLia98TJqhvZ0PVS3aot9hg/z63kAvcCpPjiHIz71hdtxpPZ4yG8vNn1h
         CrEU7WiZUaXDki4nLHhEtEJ59SENnuPAhWhibKcTOrjKlRceqQUtKGVdyMM+eyeD4aRC
         /PDoxQn4W6/ADR5vlXtemKqIlFzHn9hszQCsYypdvMnztoIiSTav68XRQpM3Pj6EdSUh
         MX8Q==
X-Forwarded-Encrypted: i=1; AL+hErFlISwRWGmAqyfsX7Aw+Ht+iVKpIXSg3OLu9+ZWWh2F4xBvalokXpCiuYunTWeTNdOanMzxjLgs8LiZkg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9RvwOm664CR9R74eZQjy0FmqDDlU5BOknpj6DI84+XTfFhjZa2
	CAz6Szv7sXFt/oVcTQwicHvTR1xJkfNzQMimgY/SOpg3mSEmoViUazIR
X-Gm-Gg: AYBFou2E1NAvj1ygf/MjU6eAtsyj+JbzrgQlas5oC/4nniz77t72CjiELuyrG/81vhY
	D1SHCPgjzUqbz6gcSFHbGEy/nBm3pmw0ip2cL51Ur0D+lmN01aNKWHpYktZMqre6mqMf1bdppYc
	xQ9BSxSrndm1h68MfDPwX/ezNAt0tI1v7uLeeju6dPZ299TOB0ono4nQjne8uBz26ctsSjpFiR8
	TbCji2zSRbGgVQQeyd1tOYjwuRrhZAZbZGL3esybhH0T8E3YF8sJ6BqE7pHWFgc2JGveu28lMxd
	H5HKDeK8Gvy7mOMJ4LjvLsI5S+agRe/jWDezt98IHs8mQ2Pexnba1yUm7Iao1+9e1zH9tRtAGir
	93eM6ryU0p70BC6qt7nZ1hKXh8Td3fFeCZ5zzmubDKcNYXeWELZBX75J6DUIzvkJ4gLG7Hk2jNT
	2ZffSxMeoUhMz27flSeXdtq0eoRQiluZ7rpf3jNnjOyE71tP8prtZTAjiRFw4fnS9+UCtmz7Jx+
	B2QRjdm5pz7rVwKH++f0uGnPlBx84E9VnSy/brigRBeVnOOcU9Tf7tnmcjMsmADfMfmmTRBOThf
	kKNsJWcMUpND8bS6Z6cW1gU7kDaofNJXI62CeLfz8fnZpbLT3m6uIRRkL62YB1Lpt8SVMyoQT2x
	4SqFTeaDJi7ADi0rCrfwJtWGZc2PW1AMtYfuNTOWsWtitzB/pADM24cx0zYfL1p0=
X-Received: by 2002:a05:600c:3b86:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4ba0939aef5mr14296425e9.27.1794364508185;
        Tue, 10 Nov 2026 18:35:08 -0800 (PST)
Received: from localhost.localdomain (cl-hedp4-wifi-nat.herts.ac.uk. [147.197.250.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba08e423dfsm24233455e9.1.2026.11.10.18.35.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 18:35:07 -0800 (PST)
From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	yangwenfang <vicky.yangwenfang@huawei.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zhiyuan Zhang <zhiyuanzhang912@gmail.com>,
	syzbot+42984127d45ad96219de@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when write_end fails
Date: Wed, 11 Nov 2026 02:34:44 +0000
Message-ID: <20261111023444.22688-1-zhiyuanzhang912@gmail.com>
X-Mailer: git-send-email 2.50.1
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

From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>

syzbot reported a kernel BUG in the ocfs2 write fault path:

  (syz.0.17,5578,0):ocfs2_write_end_nolock:1945 ERROR: status = -30
  kernel BUG at fs/ocfs2/mmap.c:106!
  Call Trace:
   do_page_mkwrite+0x147/0x310 mm/memory.c:3879
   do_shared_fault mm/memory.c:6145 [inline]
   handle_mm_fault+0x1a53/0x3750 mm/memory.c:6943

__ocfs2_page_mkwrite() calls ocfs2_write_begin_nolock() and then
ocfs2_write_end_nolock(), and uses BUG_ON() to assert that the latter
returns the full length.  But ocfs2_write_end_nolock() can fail: since
commit 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before
ocfs2_journal_dirty() in ocfs2_write_end_nolock()") it gets journal
access to the inode buffer again, because the handle may have been
restarted since ocfs2_write_begin_nolock().  That fails with -EROFS or
-EIO once the journal has been aborted or jbd2 has seen write errors
on the device.  The syzbot reproducer gets there by shrinking the
backing loop device to zero with LOOP_SET_STATUS while writing to a
shared file mapping.

Handle the failure instead of crashing.  ocfs2_write_end_nolock()
leaves the mmap folio locked, because ocfs2_unlock_folios() skips it
when w_target_locked is set so that it can be returned with
VM_FAULT_LOCKED, and do_page_mkwrite() does not unlock it either when
->page_mkwrite() returns an error.  So unlock it and fail the fault;
the faulting task gets SIGBUS, like for the other errors in this
function.

For an mmap write ocfs2_write_end_nolock() returns either len or a
negative errno: inline data has already been converted to extents by
ocfs2_write_begin_nolock(), and copied is equal to len.

The BUG matters for local mounts, where the filesystem is expected to
go read-only and keep running after a journal abort.  On clustered
mounts ocfs2_abort() panics the node anyway as soon as it notices the
aborted journal.

Fixes: 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()")
Reported-by: syzbot+42984127d45ad96219de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=42984127d45ad96219de
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-2
Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
---

Notes:
    Testing: syzbot C reproducer in QEMU (x86_64) on a defconfig-based
    kernel with KASAN, lockdep, DEBUG_VM and hung task detection enabled
    (not syzbot's own config).
    
     - Unpatched: BUG in 3 of 3 runs, within 22 iterations.
     - Patched: 437 iterations over 3 runs hit the failing write_end 21
       times (11 x -EROFS, 10 x -EIO), all ending in SIGBUS, with no BUG,
       KASAN, lockdep, DEBUG_VM or hung task report.
     - Negative control: without the folio_unlock(), inode eviction hangs
       on the locked folio in truncate_inode_pages_range() in 3 of 3 runs
       that hit the error.
    
    Not tested on a clustered mount.
    
    AI assistants were used to analyse the report, to write the patch
    and the changelog, and to run the tests above.
    
    ocfs2_dio_wr_get_block() has the same BUG_ON(ret != len).  It is left
    alone here because the pending "migrates ocfs2 DIO from buffer_head to
    iomap" series removes that function.

 fs/ocfs2/mmap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 6c570157caf1..1c03f45e8965 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -103,7 +103,17 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 		goto out;
 	}
 	err = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
-	BUG_ON(err != len);
+	if (err != len) {
+		/*
+		 * ocfs2_write_end_nolock() keeps the mmap folio locked so
+		 * that it can be returned to the VM with VM_FAULT_LOCKED.
+		 * On failure nobody else will unlock it, so do it here.
+		 */
+		folio_unlock(locked_folio);
+		mlog_errno(err);
+		ret = vmf_error(err);
+		goto out;
+	}
 	ret = VM_FAULT_LOCKED;
 out:
 	return ret;

base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.50.1 (Apple Git-155)

