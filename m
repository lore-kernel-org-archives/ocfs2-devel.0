From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 19 Jan 2009 20:57:00 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation
	Strategy	Improvement.v2
In-Reply-To: <4974287F.5040103@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
	<1232093128.6601.12.camel@tristan-laptop.cn.oracle.com>
	<49704272.4080000@oracle.com>
	<1232122135.6601.51.camel@tristan-laptop.cn.oracle.com>
	<4972EF47.5090202@oracle.com>
	<73490225-F30E-4CF1-ACCE-FBCA845ACBDC@oracle.com>
	<1232348850.6623.16.camel@tristan-laptop.cn.oracle.com>
	<4974287F.5040103@oracle.com>
Message-ID: <1232369820.6623.41.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2009-01-19 at 15:15 +0800, Tao Ma wrote:
> 
> tristan.ye wrote:
> > On Sun, 2009-01-18 at 07:17 -0800, Sunil Mushran wrote:
> >> How big is this disk? Maybe one kernel tree untar is not be enough to  
> >> expose the original issue. Also, use ls -i and/or debugfs to see if  
> >> the inodes have some locality.
> > 
> > Tao, sunil
> > 
> > I've tested it out with more attempts, it may have something to do with
> > the disk size. but the root pause why i did not get a excited speed-up
> > performance gain was due to the iscsi-target(iscsi server) cache. the
> > operation in your testcase which was meant for cache dropping is aimed
> > at client side(a 'echo 2>/proc/sys/vm/drop_cache' only flush the fs's
> > cache for iscsi initor(isci client)). 
> > 
> > Tao,
> > 
> > You can verify this by pausing the tests at the right point before we
> > start '2rd ls -lR', then flush the iscsi-target's cache by 'service
> > iscsi-target restart'(there may be a more graceful way to do this),after
> > this done, resume the tests, then you'll find the the realtime it
> > consumed will be up to 3 mins around:)
> cool, so I am very glad that you got the same result as mine. ;)
> > 
> > Btw, i really saw lots of locality by 'ls -li' for inodes under a same
> > dir, take /mnt/ocfs2/linux-2.6.28/include/linux for instance, almost all
> > of its inodes are contiguous one by one regarding to its inode number.
> yeah, that is the desired behaviour with my 3 patches. :)
> 
> Then do you have any updated test statistics?

Tao,

With iscsi-target cache flushed everytime before tests getting started,
following is the updated testing result:

Testing node:test7
Testing volume: iscsi sdd1

=============== Tests with 10 times iteration================ 

1st 'Tar xjvf' result:

Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 22.468s                                       0m 23.472s

1st 'ls -lR' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 30.682s                                        0m 30.414s

1st 'rm -rf' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 1m5.715s                                       0m 1m3.835s

2rd 'Tar xjvf' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 31.550s                                       0m 28.726s

2rd 'ls -lR' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches

0m 3m5.772s                                       0m 30.274s

===============Tests end============================ 

Glad to see your guy's patch has greatly improved the performance of
inodes traversing:),

Unfortunately, the 1st Tar testcase still get a performance
penality(around 1s) everytime.

I've kept the testing env on test7 for your verification.


Regards,

Tristan

> 
> Regards,
> Tao
