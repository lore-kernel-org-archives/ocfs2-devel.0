Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D125405860
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886262; cv=none; b=gTdaRGf/S8ExveKj2jP7I9Tyd7z1D1ETbKunDEGDhyFYpfab3KglswOdGHwaMtBsupPVU5WL+RXHRSlory+FVk42zSHoPE4H8sxlG+bnsAwesv+kT/ImskAxsVR9CpAn8Ch8JzJiKyhWuBLttC2IFJIktwwTllBeItoD+x+V7Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886262; c=relaxed/simple;
	bh=5ScSXZL8Ax5+DIGA81DZc3FpMEu0aZKsA1liX1KTZ/8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bca1t6m1qkxqp3SsLJjEzTWdDnkzmbhhkzfNwcGfQALyfui0avwvsIIcfcuUN+rGbKXl118ctiiCjeKMsChno/gCSBPOUhc75qRTZI5IZoXpZ4oNFecrVMXVfu81dgdCpdbZk+m3DJ9dD9vSfUunBNhPGXccSVpGni2zYXuXX60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=YmcUjc6k; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="YmcUjc6k"
Received: from mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:f85:0:640:673a:0])
	by forward502b.mail.yandex.net (Yandex) with ESMTPS id 61618807B9;
	Wed, 27 May 2026 15:50:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net (smtp) with ESMTPSA id moYtiO1c2uQ0-SG5SwxQo;
	Wed, 27 May 2026 15:50:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779886249; bh=dSv4Vwsob7fJppWYDgtunQrpsNTGTtHP9QFJGHh2Vuc=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=YmcUjc6kOtSAJmeMObG4QFjhPw/f6Cudc1B0hxgKKM2gzoLb8OBX3//GvRFGj04gv
	 X2clqiZB2kXyydKA+tH3lVKc0k5HYmlaksLyqd6q0W5Fc8R43Iojs5+QPrNkGliOWr
	 shHOiuPLWxxtBL9uawBbwgHEF9YJNRWUQpDzUyto=
Authentication-Results: mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <7e301d4d2d6ab3fe4b53a81c07af5ef0dc914a74.camel@yandex.ru>
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>, Mark Fasheh
	 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 27 May 2026 15:50:18 +0300
In-Reply-To: <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
	 <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
	 <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
	 <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-05-27 at 15:52 +0800, Joseph Qi wrote:

> block was never added to the ocfs2 metadata cache because the first read =
failed

Hm. Did you ever try to run https://syzkaller.appspot.com/text?tag=3DReproC=
&x=3D14a8f142580000?
IIUC the following debug quirk shows that this is not true:

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4..77fbd9d1799f 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -187,6 +187,12 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u6=
4 block,
        return status;
 }
=20
+enum ocfs2_validation_bits {
+       BH_FailedValidation =3D BH_PrivateStart + 7,
+};
+
+BUFFER_FNS(FailedValidation, failed_validation)
+
 /* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
  * will be easier to handle read failure.
  */
@@ -380,16 +386,20 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, =
u64 block, int nr,
                                BUG_ON(buffer_jbd(bh));
                                clear_buffer_needs_validate(bh);
                                status =3D validate(sb, bh);
-                               if (status)
+                               if (status) {
+                                       set_buffer_failed_validation(bh);
                                        goto read_failure;
+                               }
                        }
                }
=20
                /* Always set the buffer in the cache, even if it was
                 * a forced read, or read-ahead which hasn't yet
                 * completed. */
-               if (bh)
+               if (bh) {
+                       BUG_ON(buffer_failed_validation(bh));
                        ocfs2_set_buffer_uptodate(ci, bh);
+               }
        }
        ocfs2_metadata_cache_io_unlock(ci);

=3D=3D>

executing program
[   44.509473][ T5467] loop0: detected capacity change from 0 to 32768
[   44.515278][ T5467] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   44.515278][ T5467] WARNING: The mand mount option has been deprecated a=
nd
[   44.515278][ T5467]          and is ignored by this kernel. Remove the m=
and
[   44.515278][ T5467]          option from the mount to silence this warni=
ng.
[   44.515278][ T5467] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   44.536046][ T5467] JBD2: Ignoring recovery information on journal
[   44.577220][ T5467] ocfs2: Mounting device (7,0) on (node local, slot 0)=
 with ordered data mode.
[   44.611995][ T5467] (repro-30b53487d,5467,0):ocfs2_check_set_options:124=
4 ERROR: Invalid heartbeat mount options
[   44.621817][ T5467] loop0: detected capacity change from 32768 to 32767
[   44.628016][ T5467] OCFS2: ERROR (device loop0): int ocfs2_validate_dx_r=
oot(struct super_block *, struct buffer_head *): Dir Index Root # 74 has ba=
d signature XDIR01
[   44.629720][ T5467] On-disk corruption discovered. Please run fsck.ocfs2=
 once the filesystem is unmounted.
[   44.630205][ T5467] OCFS2: File system is now read-only.
[   44.631290][ T5467] (repro-30b53487d,5467,0):ocfs2_find_entry_dx:1065 ER=
ROR: status =3D -30
[   44.631898][ T5467] ------------[ cut here ]------------
[   44.632168][ T5467] kernel BUG at fs/ocfs2/buffer_head_io.c:400!

Dmitry

