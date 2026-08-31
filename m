Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED573B47F6
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 03:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788147245; cv=pass; b=JGShncgikdjV1XJxbuKJt3dJ9wFHIhaKZm4h2tzzd4Pu9U1SwcZKSsVCOWEcpIQfSICvJXFMy9dRV76Z1roup6I5vOfnBtucxOv5OOtM4WDdRxNROZXxIc4rXfzGWUjOx7RuzAkL/hN9295MNoFmQKpJFo32w71aM4AxsQ543Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788147245; c=relaxed/simple;
	bh=AZs/sm4zt5glGIybIrEVcQWeC/fAhNCbd0FittW9YuE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PmuRjuhDFc2Uzl160TvEvQ50/RCvMXx8lDuQAqv2BRhPpTeLhX+jAAIlpsn7lRzUv8OGeP2cU6M2BUX8NcDKn8073bYwZ6rLbxslC5Y4GEhq4i+hZRk60G703P5DGtdsfbkCA9Z2ssM+pN5AharpHaSeEQs9xzix6yuIuRrtXxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dP9Q+vOu; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dP9Q+vOu"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51bfad59921so29975281cf.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Aug 2026 20:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788147241; cv=none;
        d=google.com; s=arc-20260327;
        b=LvhENN9oMsU2TAQu8As507kD16+14npjrOec9LW4YipkeGy75d4ve31nYvgqOX6T65
         /FrJ+yKrr38w9cgNgQjoWkpJgiAIOfnT2OxGZ0z0nVpzsqU9YFHDJCXYE+soHkV9BQUL
         2s8krGs3YkhVrvbOGTH9HCFY8Qy3070AgTZN9PwUuA7vYZTc8ULsjVheEBqbLQLx9Wln
         QckMRSRA6paQAgcGNRHWDAGhLieINkQYUf7hDjhCLsWdA9AX06c4kQF+VNDrdj2huZvm
         Sosj/ieRZztnhwaBzPBFxX+Q+uazVrdR7Wy0xbwR2Q5pcWuV/UvY/r7G48mI0nU718qL
         Arcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=AZs/sm4zt5glGIybIrEVcQWeC/fAhNCbd0FittW9YuE=;
        fh=mJzTCfKQ+HsjPqllz7pKQATYgyAE3JTTNmbRso+CXr4=;
        b=YW90NzP9bLhoucdp6BWUe86HRnJnqu2iSXQyr9GyF+2U15H5P1bnzfxreVyoAOExQk
         qXMr/WWzd2X804CsnRP+QMqsN6AUKau3Sr2J9ILdRXvBxDGcIWaEt5DByZFnqjOEJsj/
         kbmb7qtIOhslbJr6XtA0ap7w0BzFu/dwX4kr50EIG7IFM7huyMFiJirJjPSYDHqXKbcG
         EQPPUJ9X3ZX2s9c7JG/t4iCnn543FzWkUXS+u1u6VGz2yo1pfRJBf5j1f0jTRGzy7IfR
         +TgVqwIHqROw+RaOZwZoKP0IoKHwiwFbc8QO/LPEoKEKVlGmBc6gAi5fU0XmUi5oUo8d
         lAVw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788147241; x=1788752041; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AZs/sm4zt5glGIybIrEVcQWeC/fAhNCbd0FittW9YuE=;
        b=dP9Q+vOuE0+I7XuXc9e3ufL+X1quQz88BSnd30DHQf7j6msJ9ihOQln45+LzxU4gpN
         f3in2NqxdjlfJi5vWJBHPkNKdB4TQE7nDI9jSvaYyU7eWPT17OUTP0SZai/9rN8/tCw9
         4pCd8azgZ2lk7NQsvjfNe02lVfjVLBpjBUPb+f/2cQCd49tpm/sTNJIioP6AsbrI0O+I
         n+WyCK4/K4PUGDtT4QHyI39izlMwFoIYG7GpTmMRl5aTGEIoF0XACAX0Mb/2KEDliJ+l
         +0QLQeK4BbIilWIo9KoUH+GajuqdM4+IZF8pBHdIGzJHSMG1GHhW5dQq3OiRf2ERm57O
         rzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788147241; x=1788752041;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AZs/sm4zt5glGIybIrEVcQWeC/fAhNCbd0FittW9YuE=;
        b=Huu+513q1sp9y8qp+3GnLPuJateZCt5qBQvXJzCxRs1NqE20BmrzhgwSpwg2nbtAWZ
         nXeHMEkYGyHIyxaog5hHCTW3AWEa95jzcQuc3rYgVTMnsIPz8mpLGS8AK4GVIVU9/jXZ
         sqIR5DsFQFJFQ1mu8xnyb2nsp9WMXtpsuDVwj1D7iPfUuDE4unHY1eqhbAFR9M/KT8x/
         u1Qk9UzZB7hyziWTO+OoWR8qphlj5RJypXXtrmk2PKL3IsMw45TTCUc6QZBDdt0zLX4V
         LLII8vsz51y5ZJWS1frc3p4xlzpKmqefQL4gCLbJaFi2sUd1TWK6P/aCJJCcZawY9ppU
         aWmg==
X-Gm-Message-State: AFuF++mv12o0/eSWyVTOwazuk6kiiant7Flw1LfL1540ubK1UPpGvBan
	uO4hv9rApS/f8M0RknLMZ3a+ujjUvQh85JQ3J35eN1zkuF1ZrYoi8dXHaqZI81r1wRrOJ5BcT+h
	qJybykpwcIxN/CBedzy/Q5CW1vMDYo2Y=
X-Gm-Gg: AR+sD126/WSroKL6XDqjRaKg5FA7WI1BSRtka2AKV9riOaS8a6VebzCFEhXz2/29OTl
	UjuM6b9HSgeaZc1emd+xcciok2A7BMuSD1Jhv1E+YxREs8/E29OdB935/x+ZIFyaxeE7Fuwq4iD
	y+gKpoLyQYKx3bRjzp07+Tegn7SwUfNcE0t06IG99gp8gd2hAm1RQDp6fVvu9xF+BpkcFUMqDhI
	mzRcC+3G2c7X/AMleF4Vz5Y1L9+dW8vfA38R3DcDyIUnqx49CuE+oJ578pJ+baMZCZ4vSs8PwPE
	QPpQoxeUi4pfAnouNdOqvkS41vaX6Ms09xzrJfh6JH3PJKvjOmq1fKGWIJ5EAQSoivVRX6DwcSk
	SSV0UMB4oTXoNLd9twqlpUzY7kG6UqBRRPKuEzikUveyQ0DPD
X-Received: by 2002:a05:622a:8c6:b0:52e:fb1b:b50f with SMTP id
 d75a77b69052e-52fb967eab5mr305370061cf.35.1788147241018; Sun, 30 Aug 2026
 20:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 31 Aug 2026 11:33:49 +0800
X-Gm-Features: AcwNN1WTGXlb64mE7CNrNMnGsVoCgwkmdcjAFwSLONHTAjlK2eSrVlp7QOX01pc
Message-ID: <CAA2SOT7zxMtbW3=ZkEnb4R-Cmyqg=gX+yGr6NdG05--Nz=2pQQ@mail.gmail.com>
Subject: [BUG] ocfs2: non-static lock key warning in ocfs2_dlm_shutdown on
 crafted readonly image
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a lockdep warning triggered by a syzkaller reproducer on
Linux 7.2.0-rc3. A similar issue has been reported before, but I can still
reproduce this warning on Linux 7.2.0-rc3 with HEAD commit
1137d8b5df06137fb49513cc923b3b24d94cb809.

The reproducer mounts a crafted OCFS2 filesystem image through a loop
device. The image reports block check CRC errors, and the loop device is
detected as readonly. OCFS2 mounts the image in local mode and skips
cluster recovery. During unmount, ocfs2_dlm_shutdown() drops DLM lock
resources and reaches ocfs2_mark_lockres_freeing(), where lockdep reports
that a non-static key is being registered.

This looks like an OCFS2 shutdown-path issue for a partially initialized
or corrupted readonly mount. A lock resource appears to be dropped during
ocfs2_dlm_shutdown(), but its lockdep state/class is not initialized in a
way that lockdep can track.

Reproducer:

syz reproducer: https://pastebin.com/raw/TYgtTYYu
console output: https://pastebin.com/raw/pU2bSEGZ
kernel config: https://pastebin.com/raw/y7Hyukfc

Kernel:

HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
git tree: torvalds/linux
kernel version: 7.2.0-rc3 #1 PREEMPT(full) (QEMU Ubuntu 24.10)

Relevant log:

loop0: detected capacity change from 0 to 32768

ocfs2_block_check_validate:400 ERROR: CRC32 failed:
stored: 0xb3775c19, computed 0x2dd1c265. Applying ECC.

ocfs2: Readonly device (7,0) detected. Cluster services will not be used
for this mount. Recovery will be skipped.

ocfs2: Mounting device (7,0) on (node local, slot 65535) with ordered data mode.

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.

CPU: 1 UID: 0 PID: 10387 Comm: syz-executor Not tainted 7.2.0-rc3 #1
PREEMPT(full)

Call Trace:
<TASK>
dump_stack_lvl+0x116/0x1b0
register_lock_class+0x778/0x7c0
__lock_acquire+0xa4/0x27a0
lock_acquire+0x1a4/0x350
_raw_spin_lock_irqsave+0x3d/0x60
ocfs2_mark_lockres_freeing+0xb4/0x5a0
ocfs2_simple_drop_lockres+0x1e/0x80
ocfs2_dlm_shutdown+0x43/0x250
ocfs2_dismount_volume+0x33b/0xa70
generic_shutdown_super+0x166/0x400
kill_block_super+0x3b/0x90
deactivate_locked_super+0xbb/0x130
deactivate_super+0xb1/0xd0
cleanup_mnt+0x378/0x510
task_work_run+0x172/0x280
exit_to_user_mode_loop+0x201/0x660
do_syscall_64+0x5ba/0x7a0
entry_SYSCALL_64_after_hwframe+0x76/0x7e
</TASK>

ocfs2: Unmounting device (7,0) on (node local)
