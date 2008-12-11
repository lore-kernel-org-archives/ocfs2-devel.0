From: tristan.ye <tristan.ye@oracle.com>
Date: Thu, 11 Dec 2008 16:26:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS
	error	in	concurrent file locking
In-Reply-To: <4940CC19.5010801@suse.de>
References: <493524C0.4090506@suse.de> <4935B20B.9040309@oracle.com>
	<4936E284.6030000@suse.de>
	<1228354293.6492.6.camel@tristan-laptop.cn.oracle.com>
	<4940CC19.5010801@suse.de>
Message-ID: <1228983983.6611.18.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2008-12-11 at 16:15 +0800, Coly Li wrote:
> 
> tristan.ye Wrote:
> > On Thu, 2008-12-04 at 03:48 +0800, Coly Li wrote:
> >> Sunil Mushran Wrote:
> >> [snip]
> >>
> >>> Corrections welcome.
> >>>
> >>> Lastly, test the patch not only with the flock() test but also otherwise.
> >>> Say, with recovery. Part of fixing bugs is ensuring the fix does not break
> >>> existing functionality. Run all multinode tests in ocfs2-test.
> >> On a 8 nodes cluster setup by xen, I tested these test cases,
> >> - run_buildkernel.py
> >> - cross_delete.py
> >> - dlmstress1.sh
> >> - run_extend_and_write.py
> >> - run_lvb_torture.py
> >> - mmap_test
> >> - test_netfail.py
> >>
> >> Not tested cases are run_create_racer.py and open_delete.py, cause I encountered some error when
> >> setup them.
> > Hi Coly,
> > 
> > How did you setup the env for testing? are you using the latest
> > testsuite from ocfs2-test.git? As for the cluster testing, we need to
> I download the code by svn, here is my command,
> svn co http://oss.oracle.com/projects/ocfs2-test/src ocfs2-test
> Is it out of date ?

Actually we've moved to git repository for ocfs2-test src management, so
you'd better turn to our git repo for pulling latest test sources. Such
as,

1. git clone git://oss.oracle.com/git/ocfs2-test ocfs2-test

2. ./autogen.sh 

3. make && make install DESTDIR=/your/dest/path

All testing binaries should be fairly ready for test if you've already
configed your openmpi and ssh&rsh connection well.

Just feel free to let Marcos and me know if you're being hindered by any
problem during the testing:)


Regards,
Tristan

> 
> > install openmpi first, and setup passwordless ssh&rsh connection among
> > all nodes.
> > 
> Yeah, I did that. There is very helpful document on ocfs2 wiki, thanks to the author :)
> 
> > Besides, all testing binaries need to be run from a installed BINDIR
> > after a successful building&installation.
> When I tried run_create_racer.py and open_delete.py, maybe I didn't input correct/proper parameters
> to the scripts, I will start another thread to ask for help :)
> [snip]
> 
> Thanks for your feedback. Since I switched my email address, my reply comes late ...
