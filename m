Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [178.154.239.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60411798F
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 06:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759992377; cv=none; b=CMUmUVEQaXRC/Os2l5vxvXjrjvyFMOQVRe9W0EF/g+mEgQver2qxEhlsVMg3MO+FLhzkqKibOw5srmntcRRgrJZjhMHLNtc9J1Uofeigz5O1eq0xpiJvvjAR61Fre5IhUs6LEp98r5E72JZ++0xr8+dIbg/iwoPn3vEKwpvULho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759992377; c=relaxed/simple;
	bh=8fgt+qX9s8wqLp/iF1eOZfJ5gIv6Qi9ym1+HwH/RLh4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=b7aPny5dS65KOy80t+oRmgeb57MvfcLLiy4UCjkqXfDShfRaEon2wYYY40/ldWFV/rqbLJ+LV5Pyt2smwLvc6SRAWDL2B7pzf5MvAUmFIWkmasrO9cmOFrG8pZgw3r31kLrZgBPhl19T4j+LAwWGzSRl/hbAZlT6UkWjby9bpO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=AOK3nbD7; arc=none smtp.client-ip=178.154.239.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="AOK3nbD7"
Received: from mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:ea2:0:640:ef77:0])
	by forward502d.mail.yandex.net (Yandex) with ESMTPS id 5F6F8C0B03;
	Thu, 09 Oct 2025 09:39:08 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 6dDw1sUL9uQ0-2sSkjdUI;
	Thu, 09 Oct 2025 09:39:07 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1759991947; bh=NhIT4BxVL7oWTyvCufarXYtdPb42Dwhw0iFcChCFALg=;
	h=In-Reply-To:Subject:To:From:Cc:Date:References:Message-ID;
	b=AOK3nbD7pfaE2AE9qoLoh0s2R7AM7vTydHO7wfLf0j8fe2rtrCcMqNF7+aVDgnb7t
	 stWAgaRpMOzKMCy3udI+f3bFd7i2To8lRNfCDbLN2gWrgBAiLMlI8nVG8py249Jkdo
	 Fur4ZKwjPys66KGM8S7+ZPlXg0/zyFW0JRPnbpEE=
Authentication-Results: mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <f35612bf-e1f7-4bf6-871d-a95f0127856c@yandex.ru>
Date: Thu, 9 Oct 2025 09:39:06 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
References: <20251008112031.2369598-1-dmantipov@yandex.ru>
 <8df4d266-6e41-43fb-9412-5a2ccbcf0d96@linux.alibaba.com>
Content-Language: en-MW
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
Subject: Re: [PATCH] ocfs2: add extra flags check in
 ocfs2_ioctl_move_extents()
In-Reply-To: <8df4d266-6e41-43fb-9412-5a2ccbcf0d96@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/25 5:15 AM, Joseph Qi wrote:

> The check here looks fine.
> Could you please elaborate more how it fixes the reported bug?

Ugh. This just catches the reproducer early, thus stopping it the way
before the actual BUG() is triggered :-(.

According to fsck.ocfs2, the filesystem used by the reproducer in this
particular case is totally broken and even fsck.ocfs2 is unable to
repair it automatically:

fsck.ocfs2 1.8.8
Checking OCFS2 filesystem in /dev/loop0:
   Label:              <NONE>
   UUID:               B1DE653C5FFC4D88B33B244AAB9EB3E9
   Number of blocks:   16384
   Block size:         512
   Number of clusters: 1024
   Cluster size:       8192
   Number of slots:    1

/dev/loop0 was run with -f, check forced.
Pass 0a: Checking cluster allocation chains
[GROUP_FREE_BITS] Group descriptor at block 32 claims to have 427 free bits which is more than 420 bits indicated by the bitmap. Drop its free bit count down to the total? y
[CHAIN_BITS] Chain 0 in allocator inode 71 has 427 bits marked free out of 1024 total bits but the block groups in the chain have 420 free out of 1024 total.  Fix this by updating the chain record? y
[CHAIN_GROUP_BITS] Allocator inode 71 has 597 bits marked used out of 1024 total bits but the chains have 604 used out of 1024 total.  Fix this by updating the inode counts? y
[CHAIN_I_SIZE] Allocator inode 71 has 1024 clusters represented in its allocator chain which accounts for 8388608 total bytes, but its i_size is 16777216. Fix this by updating i_size? y
Pass 0b: Checking inode allocation chains
[CHAIN_I_SIZE] Allocator inode 68 has 288 clusters represented in its allocator chain which accounts for 73728 total bytes, but its i_size is 147456. Fix this by updating i_size? y
[CHAIN_HEAD_LINK_RANGE] Chain 0 in allocator inode 74 contains an initial block reference to 17056 which is out of range.  Clear this reference? y
[CHAIN_BITS] Chain 0 in allocator inode 74 has 2046 bits marked free out of 2048 total bits but the block groups in the chain have 0 free out of 0 total.  Fix this by updating the chain record? y
[CHAIN_EMPTY] Chain 0 in allocator inode 74 is empty.  Remove it from the chain record array in the inode and shift further chains into its place? y
[CHAIN_GROUP_BITS] Allocator inode 74 has 2 bits marked used out of 2048 total bits but the chains have 0 used out of 0 total.  Fix this by updating the inode counts? y
[CHAIN_I_CLUSTERS] Allocator inode 74 has 0 clusters represented in its allocator chains but has an i_clusters value of 64. Fix this by updating i_clusters? y
[CHAIN_I_SIZE] Allocator inode 74 has 0 clusters represented in its allocator chain which accounts for 0 total bytes, but its i_size is 1048576. Fix this by updating i_size? y
Pass 0c: Checking extent block allocation chains
[CHAIN_I_SIZE] Allocator inode 73 has 0 clusters represented in its allocator chain which accounts for 0 total bytes, but its i_size is 90133. Fix this by updating i_size? y
Pass 1: Checking inodes and blocks
pass1: Internal logic failure while trying to set inode 65's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
pass1: Internal logic failure while trying to set inode 66's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
pass1: Internal logic failure while trying to set inode 67's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
pass1: Internal logic failure while trying to set inode 68's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
[EXTENT_BLKNO_RANGE] Extent record 0 in owner 69 refers to a block that is out of range.  Remove this record from the extent list? y
[INODE_SPARSE_CLUSTERS] Inode 69 has 1 clusters but its blocks fit in 0 clusters. Correct the number of clusters? y
pass1: Internal logic failure while trying to set inode 69's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
...
[INODE_ALLOC_REPAIR] Inode 128 is marked as invalid but its position in the inode allocator is marked as in use.  Fix the allocation of this and all future inodes? y
[CLUSTER_ALLOC_BIT] Cluster 3 is marked in the global cluster bitmap but it isn't in use.  Clear its bit in the bitmap? y
...
Pass 2: Checking directory entries
pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
[DIRENT_INODE_RANGE] Directory entry 'lost+found' refers to inode number 17057 which is out of range, clear the entry? y
pass2: Bit does not exist in bitmap range while testing if inode 72 is allocated.  Continuing as though it is.
[DIRENT_NOT_DOTTY] The first directory entry in directory inode 72 is '' instead of '.'.  Clobber the current name with the expected dot name? y
pass2: Bit does not exist in bitmap range while testing if inode 72 is allocated.  Continuing as though it is.
pass2: Bit does not exist in bitmap range while testing if inode 66 is allocated.  Continuing as though it is.
pass2: Bit does not exist in bitmap range while testing if inode 66 is allocated.  Continuing as though it is.
[DX_TREE_MISSING] Directory 66 is missing index. Rebuild? y
...
pass2: Invalid block number while rebuild indexed dirs.
fsck.ocfs2: Invalid block number while performing pass 2

(exited with status 8)

I assume that any attempt to modify anything on such a filesystem just makes
the things even worse. So what about just relaxing BUG() to ocfs2_error(), i.e.

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 86f2631e6360..bf3f3f0f6eb5 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t *handle,

         rec = &el->l_recs[index];

-       BUG_ON(ext_flags != rec->e_flags);
+       if (ext_flags != rec->e_flags) {
+               ret = ocfs2_error(inode->i_sb,
+                                 "Inode %llu has corrupted extent %d at cpos %u\n",
+                                 (unsigned long long)ino, index, cpos);
+               goto out;
+       }
+
         /*
          * after moving/defraging to new location, the extent is not going
          * to be refcounted anymore.

Dmitry

