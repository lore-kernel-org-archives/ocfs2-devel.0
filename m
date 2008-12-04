From: tristan.ye <tristan.ye@oracle.com>
Date: Thu, 04 Dec 2008 09:31:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error
	in	concurrent file locking
In-Reply-To: <4936E284.6030000@suse.de>
References: <493524C0.4090506@suse.de> <4935B20B.9040309@oracle.com>
	<4936E284.6030000@suse.de>
Message-ID: <1228354293.6492.6.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2008-12-04 at 03:48 +0800, Coly Li wrote:
> 
> Sunil Mushran Wrote:
> [snip]
> 
> > Corrections welcome.
> > 
> > Lastly, test the patch not only with the flock() test but also otherwise.
> > Say, with recovery. Part of fixing bugs is ensuring the fix does not break
> > existing functionality. Run all multinode tests in ocfs2-test.
> On a 8 nodes cluster setup by xen, I tested these test cases,
> - run_buildkernel.py
> - cross_delete.py
> - dlmstress1.sh
> - run_extend_and_write.py
> - run_lvb_torture.py
> - mmap_test
> - test_netfail.py
> 
> Not tested cases are run_create_racer.py and open_delete.py, cause I encountered some error when
> setup them.
Hi Coly,

How did you setup the env for testing? are you using the latest
testsuite from ocfs2-test.git? As for the cluster testing, we need to
install openmpi first, and setup passwordless ssh&rsh connection among
all nodes.

Besides, all testing binaries need to be run from a installed BINDIR
after a successful building&installation.

Regards,
Tristan

> 
> When I ran dlmsress1.sh and test_netfail.py,
> - Kernel BUG at fs/ocfs2/dlm/dlmast.c:334 was triggered 3 times.
> - Kernel BUG at fs/ocfs2/dlm/dlmmaster.c:1694 was triggered once.
> Right now, there is not obvious clue they are directly related to this patch. They might stay there
> already, I will do more testing to confirm.
> 
> Thanks.
