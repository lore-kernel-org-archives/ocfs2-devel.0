Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315E5446C09
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 10:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784628542; cv=none; b=tWTJjEUVcdEg64XTvGAOS5OQLDBp1tv3r1s2CXvUuBjvtVpa2ihsykcDB9bV/Bar8XXWmwrHY5iWw5pClUfaq9hzuyQqdjBgvYWWiHo5tgbt21xCJxUCe47y+3hyetO5JJRSOtOodBf4E4dUWD/2MDRE6eVBKok5bhRfI7hZXDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784628542; c=relaxed/simple;
	bh=NtvjdWNxurcs2GjwtZScLFaeHT1UE+KnEyTY/TsAhBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+mNWYKH2NMn5eszfDYp+eYMUN5T0z0ktSh6PSub/Y1riUZ0kVnBR5WeAW16ZeKSLtk40t/sSxJLCzQdMJAPske1q35e2vlpsbzesz9U0BXMyIoKVWbfrbHicixLMzoIj3EJUPkSuXRt0Lpt9rvx8z3kSNfG4dTfKbcwTwTpTnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CrSdT3QP; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CrSdT3QP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784628536; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Y1+6+I/cUK8OoL57z0nuPLue6qfEXzmfbtAtQd5sp/A=;
	b=CrSdT3QP6A3N/Gx3BROp9A/WjR75ghSMiVZkIh8U4SPUm9+6iGc7Qq6O1Gx2syJEB18wJ/51cVx6GHr8jKidfvOHu5GIyQoZH5DFiCRzmIYMc5AfS0q2rGhAY8cyTmP5f4ZkKBktbts27TUJuO6+UCwgyBNhX1TfILxoRzbX22U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7Zh1wu_1784628533;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7Zh1wu_1784628533 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 18:08:53 +0800
Message-ID: <0b60eb13-564f-445f-9bcb-cd0a2a147af0@linux.alibaba.com>
Date: Tue, 21 Jul 2026 18:08:52 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: always run deallocs on copy-on-write completion
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <20260720113957.58219-1-dmantipov@yandex.ru>
 <9b036404-0863-420a-9cf4-1cc33d506cd9@linux.alibaba.com>
 <f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/26 5:08 PM, Dmitry Antipov wrote:
> On 7/21/26 4:35 AM, Joseph Qi wrote:
> 
>> The identical idiom also exists in other places:
>>    ocfs2_attach_refcount_tree
>>    ocfs2_create_reflink_node
>>    ocfs2_reflink_remap_blocks
>>    ocfs2_reflink_xattrs
>>
>> So please check if it will leak the same way. If so, please apply the
>> same changes as well.
> 
> So the basic problem is to check whether 'ocfs2_cache_block_dealloc()'
> can be called from these functions as well. Since I have the only
> .syz reproducer that proves that 'ocfs2_cache_block_dealloc()' can
> be called from 'ocfs2_replace_cow()', time to try some static analysis.
> 
> 1. Collect LLVM bitcode of the relevant source code:
> 
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index cc9b32b9db7c..6163df78e873 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -ccflags-y := -I$(src)
> +ccflags-y := -I$(src) --save-temps=obj
> 
>  obj-$(CONFIG_OCFS2_FS) +=      \
>         ocfs2.o                 \
> 
> 2. Link them into a single unified bitcode and produce call graph:
> 
> $ llvm-link $(find fs/ocfs2 -name '*.bc') -o ocfs2.bc
> $ opt --passes=dot-callgraph ocfs2.bc
> 
> This produces ocfs2.bc.callgraph.dot.
> 
> 3. Use the following gvpr(1) (comes from graphviz) script:
> 
> // AI-assisted breadth-first search
> 
> BEGIN {
>     if (ARGC < 2) {
>         printf(2, "Error: Please provide source and target node names as arguments.\n");
>         printf(2, "Usage: gvpr -f reachable.gvpr -a [source] -a [target] input.gv\n");
>         exit(1);
>     }
>     string src = ARGV[0];
>     string tgt = ARGV[1];
> 
>     // Arrays for tracking BFS
>     node_t queue[];
>     int visited[string];
>     int Head = 0;
>     int Tail = 0;
> }
> 
> BEG_G {
>     node_t s = node($, src);
>     node_t t = node($, tgt);
> 
>     if (s == NULL || t == NULL) {
>         printf(2, "Error: One or both nodes do not exist in the graph.\n");
>         exit(1);
>     }
> 
>     if (s == t) {
>         print("yes (source is equal to target)");
>         exit(0);
>     }
> 
>     // Initialize BFS queue
>     queue[Tail++] = s;
>     visited[s.name] = 1;
> 
>     // Run BFS loop
>     while (Head < Tail) {
>         node_t curr = queue[Head++];
>         edge_t e;
> 
>         // Loop through all outgoing edges of the current node
>         for (e = fstedge(curr); e; e = nxtedge(e, curr)) {
>             if (e.head == curr) continue;
> 
>             node_t nextNode = e.head;
>             if (!visited[nextNode.name]) {
>                 if (nextNode == t) {
>                     print("yes");
>                     exit(0);
>                 }
>                 visited[nextNode.name] = 1;
>                 queue[Tail++] = nextNode;
>             }
>         }
>     }
> 
>     print("no");
> }
> 
> and simple shell script to check suspected functions:
> 
> #!/bin/bash
> 
> TARGET=ocfs2_cache_block_dealloc
> NODE_target=$(grep "{$TARGET}" ocfs2.bc.callgraph.dot  | awk '{print $1}')
> 
> for NAME in ocfs2_replace_cow \
>         ocfs2_attach_refcount_tree \
>         ocfs2_create_reflink_node \
>         ocfs2_reflink_remap_blocks \
>         ocfs2_reflink_xattrs
> do
>     NODE_check=$(grep "{$NAME}" ocfs2.bc.callgraph.dot  | awk '{print $1}')
>     echo -ne "Check whether $TARGET() is reachable from $NAME()..."
>     gvpr -f reachable.gvpr -a $NODE_check -a $NODE_target ocfs2.bc.callgraph.dot
> done
> 
> This produces the following output:
> 
> Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_replace_cow()...yes
> Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_attach_refcount_tree()...yes
> Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_create_reflink_node()...no
> Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_reflink_remap_blocks()...yes
> Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_reflink_xattrs()...no
> 
> So I would assume that 'ocfs2_create_reflink_node()' and 'ocfs2_reflink_xattrs()'
> are better to leave untouched.
> 
Reasons for ocfs2_create_reflink_node() and ocfs2_reflink_xattrs() are
marked unreachable:
ocfs2_create_reflink_node() - it's purely additive without remove blocks.
ocfs2_reflink_xattrs() - allocate new xattr blocks for the destination, with
the source's xattr tree untouched.

Since ocfs2_run_deallocs() is a no-op with an empty dealloc context, so it
seems marking it unconditional is safe. And this will keep the code pattern
consistent.

Thanks,
Joseph
