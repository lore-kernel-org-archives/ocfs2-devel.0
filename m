From: Eric Ren <zren@suse.com>
Date: Mon, 21 Dec 2015 21:50:38 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
In-Reply-To: <56776B6B.2010208@oracle.com>
References: <56776B6B.2010208@oracle.com>
Message-ID: <20151221135038.GA3194@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

Thanks for your sharing, and very appreciated your efforts.

On Mon, Dec 21, 2015 at 11:00:59AM +0800, Junxiao Bi wrote: 
> Hi,
> 
> I have run a full ocfs2-test(single/multiple/discontig) to v4.3 mainline
> kernel. The following three issues are found. The first two are
> regression bugs.
> 
> 1. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1357
>   Fix merged. Upstream commit 087ffd4eae99("jbd2: fix null committed
> data return in undo_access")
> 
> 2. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1358
>   A recursive locking issue, discussing fix in ocfs2-devel.
> 
> 3. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1359
>   o2hb-increase-unsteady-iterations.patch to fix this issue, merged by
> -mm tree
> 
> I have setup a test env to build and auto do ocfs2 test. With it, Ocfs2
> for mainline and linux-next will be test regularly, the test status and
> bugs will be reported to ocfs2-devel. Feel free to take any bug if you
> are interested, it will be a good start point with ocfs2. Hope this can
> catch regression bugs earlier before merged by mainline.
I'm very interested in how your testing env works, could you briefly introduce
it?
> 
> For the test cases, now only ocfs2-test is supported. Ltp is going to be
> merged in the future. If any other test cases or benchmark useful to
> ocfs2 test, please let me know.
Btw, recently, I did a performance testing on both ocfs2 and gfs2 using iozone. The
testing has 3 different cases:
1. local mode: ocfs2 better than gfs2
2. two files mutiple nodes  
3. same file mutiple nodes, for 2 and 3 gfs2 better than ocfs2 generally
Just provide a reference here. I tried to make it as simple as possible,
leaving all formating and mount options as default, and with fixed-size file(2GB)
and buffer(4kb). 

Did you or anyone ever test performance for ocfs2? maybe we can discuss further on
this topic in future;-)

Thanks,
Eric
> 
> Thanks,
> Junxiao.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
