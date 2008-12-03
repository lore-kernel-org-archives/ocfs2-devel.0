From: Coly Li <coyli@suse.de>
Date: Thu, 04 Dec 2008 03:48:20 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in
 concurrent file locking
In-Reply-To: <4935B20B.9040309@oracle.com>
References: <493524C0.4090506@suse.de> <4935B20B.9040309@oracle.com>
Message-ID: <4936E284.6030000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
[snip]

> Corrections welcome.
> 
> Lastly, test the patch not only with the flock() test but also otherwise.
> Say, with recovery. Part of fixing bugs is ensuring the fix does not break
> existing functionality. Run all multinode tests in ocfs2-test.
On a 8 nodes cluster setup by xen, I tested these test cases,
- run_buildkernel.py
- cross_delete.py
- dlmstress1.sh
- run_extend_and_write.py
- run_lvb_torture.py
- mmap_test
- test_netfail.py

Not tested cases are run_create_racer.py and open_delete.py, cause I encountered some error when
setup them.

When I ran dlmsress1.sh and test_netfail.py,
- Kernel BUG at fs/ocfs2/dlm/dlmast.c:334 was triggered 3 times.
- Kernel BUG at fs/ocfs2/dlm/dlmmaster.c:1694 was triggered once.
Right now, there is not obvious clue they are directly related to this patch. They might stay there
already, I will do more testing to confirm.

Thanks.
-- 
Coly Li
SuSE PRC Labs
