Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468024;
	b=mnbMGFLASsjjzCPlyK+s7oRv8QRnsLNlvIf24jbIX4KMnl6oPD9G20T0y7AYiN4lpzZM
	 gDxdGGEqxKo38FUuEauVGHtnzlNnjVp8eg8dSQToMN2qQMLc/fKIB0Io6DfEPMdyfcoeW
	 y3o6hzlpn+81aqfvHyW6H0MOUOTOjv3dw+zdpwQSDjz3+W5/g3BIwrsz2SAOHHeQ7LZAK
	 yJwBBeNJ4Fs4vxcWHXbTW6GaGlbupEDO9IX77U0tYgemLAAUcLwraJoQWsirpEqIOsmvE
	 /ZEu0T94Qg12wvbiEzhobe7iI7obedXV+5fNj2ekazF4zWuxJfPQfz3xns+Qkh5m5/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468024;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UB6HYEms+K962i3HEPLnI0I4jiiME+TfZzV30sjGwXE=;
	b=GvrJZ11XqNpZELyu0TVCPdY2pZi7u0yXRCVV9/EARYXr33RRJ5yvPwQ8DabrBqscgcqn
	 7YHI61vTI0zEjVxwxGZe2NbvgmT2LAH40JDFw0ubTAEX7AWTFchR9Vl4Fa20leFw1CrFV
	 WTVMcNew84HKdExScf4vFl8fFjkv9TFGhFzFYorlOjQNM7H6Li7hTtLPS2Yr5Z34Qty3N
	 h141VH+eGgJM97h5mM74OC/v/QdtRNg9j2zYZeFPz764G97cjtV0P9JrbC1z6vRSUgyhk
	 B0yBy8mv1G1D66iDydmRZAjcANkc1AMgRzdbk09zGXS4cfuPjXbnMXajByntVsfjRaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nsWY1JvB;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83317606A31C
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83317606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nsWY1JvB
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792468014; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UB6HYEms+K962i3HEPLnI0I4jiiME+TfZzV30sjGwXE=;
	b=nsWY1JvBiBXcWWG3WpboRY6MKA2dL+O4oSuRzp3Kw9cCo3eR9da1DUk1b5jy7eKD0j6+EGbYu9nFJ1ri41LQBpgAIE1Z5lJdF+X/Bx7MKFq/racGHkjjCGLHF0zQ34KhyIUwt/L7agiYxTASo9PV0gNzysx+un2lSwOPnQ9X43Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XDBOjxi_1792468012;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDBOjxi_1792468012 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 11:46:53 +0800
Message-ID: <a5aad315-d1a6-44cd-9b2c-23b2e8a0a3f1@linux.alibaba.com>
Date: Tue, 20 Oct 2026 11:46:51 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: Pin owning modules for open debugfs files
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 kees@kernel.org, kmehltretter@gmail.com, christophe.jaillet@wanadoo.fr,
 ericterminal@gmail.com, rppt@kernel.org, rollkingzzc@gmail.com,
 kurt.hackel@oracle.com, brauner@kernel.org, jack@suse.cz,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 9:17 AM, Cen Zhang wrote:
> The OCFS2 debugfs file operation tables do not set owner. The
> full debugfs proxy obtains real_fops with fops_get() at open and
> keeps it until final release. Without an owner, this does not acquire
> a reference to the module containing the table and its callbacks.
> Removing the debugfs entries does not drain retained open files.
> 
> An open connected_nodes file can therefore outlive ocfs2_nodemanager
> and make full_proxy_release() read real_fops->release from freed
> module memory. Heming also reproduced the issue with fs_state and
> asked for the other OCFS2 debugfs operation tables to be checked.
> 
> Set owner to THIS_MODULE in all eleven explicit debugfs operation
> tables: five in ocfs2_nodemanager, four in ocfs2_dlm, and two in
> ocfs2. The existing debugfs get/put pair then holds the appropriate
> module until final release. Leave the open, read and release callbacks
> unchanged. The blockcheck table already sets owner through
> DEFINE_DEBUGFS_ATTRIBUTE(), so it needs no change.
> 
> The original controlled test used an unloadable OCFS2 module and
> case-local probe filters without changing the candidate open, unload
> or release logic. Closing a retained connected_nodes file after
> normal unload produced:
> 
>   BUG: unable to handle page fault for address: fffffbfff804cfef
>   Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:full_proxy_release+0xbf/0x190
>   Call Trace:
>    <TASK>
>    __fput+0x39a/0xa60
>    fput_close_sync+0xff/0x200
>    __x64_sys_close+0x8c/0xf0
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>   Modules linked in: [last unloaded: ocfs2_nodemanager]
> 
> Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
> Fixes: 87d3d3f3931f ("ocfs2/hb: Expose the list of heartbeating nodes via debugfs")
> Fixes: 3ba169ccec1c ("ocfs2/cluster: Add new function o2net_fill_node_map()")
> Fixes: 50397507e856 ("ocfs2: Expose the file system state via debugfs")
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Fixes: 7209300a9b98 ("ocfs2/dlm: Dumps the purgelist into a debugfs file")
> Fixes: d0129aceaecc ("ocfs2/dlm: Dumps the mles into a debugfs file")
> Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
> Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
> Assisted-by: LLM
> Cc: <stable@vger.kernel.org>
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> 
> ---
> Changes in v3:
> - Match each .owner assignment to the indentation of neighboring members
>   throughout, as requested by Kees Cook.
> 
> Changes in v2:
> - Cover fs_state and locking_state in the OCFS2 filesystem module.
> - Cover all four OCFS2 DLM debugfs operation tables.
> - Keep the five node manager fixes and the original diagnostic.
> - Add explicit module headers and Fixes tags for the added tables.
> - Add Cc: stable@vger.kernel.org.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v2-4c67f48d4e2d0fc85990@gmail.com
> Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com
> 
>  fs/ocfs2/cluster/heartbeat.c | 1 +
>  fs/ocfs2/cluster/netdebug.c  | 4 ++++
>  fs/ocfs2/dlm/dlmdebug.c      | 5 +++++
>  fs/ocfs2/dlmglue.c           | 2 ++
>  fs/ocfs2/super.c             | 1 +
>  5 files changed, 13 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 8e6ead433228e7419bfbbe5c7cdde65c654a24f4..1cb516df53f4e1b3b2a292eb2550faa3d16e3fa2 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1447,6 +1447,7 @@ static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
>  #endif  /* CONFIG_DEBUG_FS */
>  
>  static const struct file_operations o2hb_debug_fops = {
> +	.owner =	THIS_MODULE,
>  	.open =		o2hb_debug_open,
>  	.release =	o2hb_debug_release,
>  	.read =		o2hb_debug_read,
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> index f7ab66e70799302f3ed4e70ab6a8fb057dd0bfa9..5d373002297de1fdd9a05e270f7942d8c1ce2dac 100644
> --- a/fs/ocfs2/cluster/netdebug.c
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -183,6 +183,7 @@ static int nst_fop_release(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations nst_seq_fops = {
> +	.owner = THIS_MODULE,
>  	.open = nst_fop_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,
> @@ -415,6 +416,7 @@ static int stats_fop_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations stats_seq_fops = {
> +	.owner = THIS_MODULE,
>  	.open = stats_fop_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,

Seems it misses the Fixes tag for stats_seq_fops:
db02754c8a12 ocfs2/cluster: Show o2net timing statistics

Other looks fine to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
