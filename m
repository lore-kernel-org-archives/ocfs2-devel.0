From: Eric Ren <zren@suse.com>
Date: Tue, 22 Dec 2015 15:39:48 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
In-Reply-To: <5678B6AC.1080005@oracle.com>
References: <56776B6B.2010208@oracle.com> <20151221135038.GA3194@laptop.ha>
	<5678B6AC.1080005@oracle.com>
Message-ID: <20151222073948.GA18380@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Tue, Dec 22, 2015 at 10:34:20AM +0800, Junxiao Bi wrote: 
> On 12/21/2015 09:50 PM, Eric Ren wrote:
> > Hi Junxiao,
> > 
> > Thanks for your sharing, and very appreciated your efforts.
> > 
> > On Mon, Dec 21, 2015 at 11:00:59AM +0800, Junxiao Bi wrote: 
> >> Hi,
> >>
> >> I have run a full ocfs2-test(single/multiple/discontig) to v4.3 mainline
> >> kernel. The following three issues are found. The first two are
> >> regression bugs.
> >>
> >> 1. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1357
> >>   Fix merged. Upstream commit 087ffd4eae99("jbd2: fix null committed
> >> data return in undo_access")
> >>
> >> 2. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1358
> >>   A recursive locking issue, discussing fix in ocfs2-devel.
> >>
> >> 3. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1359
> >>   o2hb-increase-unsteady-iterations.patch to fix this issue, merged by
> >> -mm tree
> >>
> >> I have setup a test env to build and auto do ocfs2 test. With it, Ocfs2
> >> for mainline and linux-next will be test regularly, the test status and
> >> bugs will be reported to ocfs2-devel. Feel free to take any bug if you
> >> are interested, it will be a good start point with ocfs2. Hope this can
> >> catch regression bugs earlier before merged by mainline.
> > I'm very interested in how your testing env works, could you briefly introduce
> > it?
> Four vm are used, one for git server, and the other three to build
> kernel and run ocfs2 test. Tag a branch and push it to the git server,
> the test will be started. The test cases to run can be set in tag message.
> 
> >>
> >> For the test cases, now only ocfs2-test is supported. Ltp is going to be
> >> merged in the future. If any other test cases or benchmark useful to
> >> ocfs2 test, please let me know.
> > Btw, recently, I did a performance testing on both ocfs2 and gfs2 using iozone. The
> > testing has 3 different cases:
> > 1. local mode: ocfs2 better than gfs2
> > 2. two files mutiple nodes  
> > 3. same file mutiple nodes, for 2 and 3 gfs2 better than ocfs2 generally
> Can you share the perf data, i am curious about the performance diff?
Sure, but I cannot guarantee it's quality;-) I'd like to put some handled data here,
and then attach the raw data.
My env has two sle12 nodes(vm) with same configuration: 4GB RAM, 4 core, 50G iscsi
shared disk. Poor equipment, isn't? hah

1. local mode
#iozone -R -s 10G -r 4 -i 0 -i 1 -i 2 -f /mnt/shared/test -b output 
        Write   Re-write    Read    Re-read Random Read Random Write
gfs2    62458   109542      104830  113967  8860        71114
ocfs2   79411   117789      123872  135462  9988        73653

2. two files mutiple nodes - use "pdsh" tools from working machine to start iozone
   on both nodes concurrently. node1 iozone on file1, node2 iozone on file2. Then
   add up the IO data and divide by 2, to get the average value.
#iozone -R -s 2G -r 4 -i 0 -i 1 -i 2 -f /mnt/shared/file1 -b multi_two-files_${FS}-2G.wks
        Write       Re-write    Read        Re-read     Random Read Random Write
GFS2    50347       51479       6079973.5   6215918.5   3885683.5   4619.5
OCFS2   38921.5     67632.5     4104709.5   3891825.5   2964093     5863.5

3. same file mutiple nodes - similar with 2th case, but both node1 and node2 iozone on the
   same file.
        Write   Re-write    Read    Re-read     Random Read Random Write
GFS2    45337   26388       48032.5 3192007     1682927.5   45014
OCFS2   19428   404.5       86296   1888067.5   1399657.5   3226.5 

Again, raw data attatched.
> > Just provide a reference here. I tried to make it as simple as possible,
> > leaving all formating and mount options as default, and with fixed-size file(2GB)
> > and buffer(4kb). 
> > 
> > Did you or anyone ever test performance for ocfs2? maybe we can discuss further on
> > this topic in future;-)
> Yes, a lot of works need to do for ocfs2 performance, to make local
> ocfs2 performance more close to ext4, and try best to make cluster ocfs2
> performance close to local.
Let's do it one by one;-)

Thanks,
Eric
> 
> Thanks,
> Junxiao.
> > 
> > Thanks,
> > Eric
> >>
> >> Thanks,
> >> Junxiao.
> >>
> >> _______________________________________________
> >> Ocfs2-devel mailing list
> >> Ocfs2-devel at oss.oracle.com
> >> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-vs-gfs2-performace-testing-data.gz
Type: application/x-gzip
Size: 57925 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151222/5e926fd8/attachment-0001.gz 
