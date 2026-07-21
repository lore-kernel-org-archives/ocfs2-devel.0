Received: from forward501d.mail.yandex.net (forward501d.mail.yandex.net [178.154.239.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CCA3C73E1
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625524; cv=none; b=GApGQtoKhYYEC/0wqXsJ+CpTBDpQPo8SvNMlAXx0kYayLdFFisOxsrLKbTLe+wrOxeE44l+fy6WbDXbGeMDagtvNaYjxegnIdylOBkioGzqfm8a61srefIVEDCEEAPi13Wly+VJdGLHDt7Fo24qJlm6Ty3hCVaaXtzMWTnPoblk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625524; c=relaxed/simple;
	bh=NrLJEUVE1tH9WhLmiu6Ue0TRYXC33NNqji0faTgg74Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EMixh0PN7f1Mc0ddNvGgAmuQ2v1njkyAdV4k30RZTS/UbBI9Oji6t9BXAv29dDbDzlyPkDhYHvEvvOLw4QkaoFb39yvEYBPlgtqK3JSg/Pb3N90TsWAG/reWX+zmWzwmI4t2YRxlnVe347rdfZix1wMyZ84M0SzdnFidF409OcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=I1xgiqYf; arc=none smtp.client-ip=178.154.239.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="I1xgiqYf"
Received: from mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:4f41:0:640:844:0])
	by forward501d.mail.yandex.net (postfix) with ESMTPS id 4A53481C38;
	Tue, 21 Jul 2026 12:11:14 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net (smtp) with ESMTPSA id BBS8NHDdxOs0-n0Xf0zl6;
	Tue, 21 Jul 2026 12:11:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784625073; bh=2w7l6b8Vskk168mu0RLrfvfSzC1/MqW5I5OXJmMvM+M=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=I1xgiqYfGGb6Ac+qNc6ScwB7FVnrXp4ptzjctVWjz03gxo/uX2e7W1llUQK4VCzqO
	 eGL586Mc91VyKxzr+WA40msVxMfcQu0ftyRtA8lN77RKkQFFKt4dOud/E9wZv15N1c
	 Bd+u1pqOtCzxisLslOBjyk4LUDQK6ljXHFg5aazQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-63.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru>
Date: Tue, 21 Jul 2026 12:08:57 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: always run deallocs on copy-on-write completion
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <20260720113957.58219-1-dmantipov@yandex.ru>
 <9b036404-0863-420a-9cf4-1cc33d506cd9@linux.alibaba.com>
Content-Language: en-US
From: Dmitry Antipov <dmantipov@yandex.ru>
In-Reply-To: <9b036404-0863-420a-9cf4-1cc33d506cd9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 4:35 AM, Joseph Qi wrote:

> The identical idiom also exists in other places:
>    ocfs2_attach_refcount_tree
>    ocfs2_create_reflink_node
>    ocfs2_reflink_remap_blocks
>    ocfs2_reflink_xattrs
> 
> So please check if it will leak the same way. If so, please apply the
> same changes as well.

So the basic problem is to check whether 'ocfs2_cache_block_dealloc()'
can be called from these functions as well. Since I have the only
.syz reproducer that proves that 'ocfs2_cache_block_dealloc()' can
be called from 'ocfs2_replace_cow()', time to try some static analysis.

1. Collect LLVM bitcode of the relevant source code:

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index cc9b32b9db7c..6163df78e873 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -1,5 +1,5 @@
  # SPDX-License-Identifier: GPL-2.0
-ccflags-y := -I$(src)
+ccflags-y := -I$(src) --save-temps=obj

  obj-$(CONFIG_OCFS2_FS) +=      \
         ocfs2.o                 \

2. Link them into a single unified bitcode and produce call graph:

$ llvm-link $(find fs/ocfs2 -name '*.bc') -o ocfs2.bc
$ opt --passes=dot-callgraph ocfs2.bc

This produces ocfs2.bc.callgraph.dot.

3. Use the following gvpr(1) (comes from graphviz) script:

// AI-assisted breadth-first search

BEGIN {
     if (ARGC < 2) {
         printf(2, "Error: Please provide source and target node names as arguments.\n");
         printf(2, "Usage: gvpr -f reachable.gvpr -a [source] -a [target] input.gv\n");
         exit(1);
     }
     string src = ARGV[0];
     string tgt = ARGV[1];

     // Arrays for tracking BFS
     node_t queue[];
     int visited[string];
     int Head = 0;
     int Tail = 0;
}

BEG_G {
     node_t s = node($, src);
     node_t t = node($, tgt);

     if (s == NULL || t == NULL) {
         printf(2, "Error: One or both nodes do not exist in the graph.\n");
         exit(1);
     }

     if (s == t) {
         print("yes (source is equal to target)");
         exit(0);
     }

     // Initialize BFS queue
     queue[Tail++] = s;
     visited[s.name] = 1;

     // Run BFS loop
     while (Head < Tail) {
         node_t curr = queue[Head++];
         edge_t e;

         // Loop through all outgoing edges of the current node
         for (e = fstedge(curr); e; e = nxtedge(e, curr)) {
             if (e.head == curr) continue;

             node_t nextNode = e.head;
             if (!visited[nextNode.name]) {
                 if (nextNode == t) {
                     print("yes");
                     exit(0);
                 }
                 visited[nextNode.name] = 1;
                 queue[Tail++] = nextNode;
             }
         }
     }

     print("no");
}

and simple shell script to check suspected functions:

#!/bin/bash

TARGET=ocfs2_cache_block_dealloc
NODE_target=$(grep "{$TARGET}" ocfs2.bc.callgraph.dot  | awk '{print $1}')

for NAME in ocfs2_replace_cow \
	    ocfs2_attach_refcount_tree \
	    ocfs2_create_reflink_node \
	    ocfs2_reflink_remap_blocks \
	    ocfs2_reflink_xattrs
do
     NODE_check=$(grep "{$NAME}" ocfs2.bc.callgraph.dot  | awk '{print $1}')
     echo -ne "Check whether $TARGET() is reachable from $NAME()..."
     gvpr -f reachable.gvpr -a $NODE_check -a $NODE_target ocfs2.bc.callgraph.dot
done

This produces the following output:

Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_replace_cow()...yes
Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_attach_refcount_tree()...yes
Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_create_reflink_node()...no
Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_reflink_remap_blocks()...yes
Check whether ocfs2_cache_block_dealloc() is reachable from ocfs2_reflink_xattrs()...no

So I would assume that 'ocfs2_create_reflink_node()' and 'ocfs2_reflink_xattrs()'
are better to leave untouched.

Dmitry

