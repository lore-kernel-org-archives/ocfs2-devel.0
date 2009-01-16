From: tristan.ye <tristan.ye@oracle.com>
Date: Sat, 17 Jan 2009 00:08:55 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation
	Strategy	Improvement.v2
In-Reply-To: <49704272.4080000@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
	<1232093128.6601.12.camel@tristan-laptop.cn.oracle.com>
	<49704272.4080000@oracle.com>
Message-ID: <1232122135.6601.51.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 2009-01-16 at 16:16 +0800, Tao Ma wrote:
> 
> tristan.ye wrote:
> > On Fri, 2009-01-16 at 05:58 +0800, Tao Ma wrote:
> >> Changelog from V1 to V2:
> >> 1. Modify some codes according to Mark's advice.
> >> 2. Attach some test statistics in the commit log of patch 3 and in
> >> this e-mail also. See below.
> >>
> >> Hi all,
> >> 	In ocfs2, when we create a fresh file system and create inodes in it, 
> >> they are contiguous and good for readdir+stat. While if we delete all 
> >> the inodes and created again, the new inodes will get spread out and 
> >> that isn't what we need. The core problem here is that the inode block 
> >> search looks for the "emptiest" inode group to allocate from. So if an 
> >> inode alloc file has many equally (or almost equally) empty groups, new 
> >> inodes will tend to get spread out amongst them, which in turn can put 
> >> them all over the disk. This is undesirable because directory operations 
> >> on conceptually "nearby" inodes force a large number of seeks. For more 
> >> details, please see 
> >> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy. 
> <snip>
> >> echo 'y'|mkfs.ocfs2 -b 4K -C 4K -M local /dev/sda11
> >>
> >> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> >> time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null
> >>
> >> real	0m20.548s 0m20.106s
> >>
> >> umount /mnt/ocfs2/
> >> echo 2 > /proc/sys/vm/drop_caches
> >> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> >> time ls -lR /mnt/ocfs2/ 1>/dev/null
> >>
> >> real	0m13.965s 0m13.766s
> >>
> >> umount /mnt/ocfs2/
> >> echo 2 > /proc/sys/vm/drop_caches
> >> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> >> time rm /mnt/ocfs2/linux-2.6.28/ -rf
> >>
> >> real	0m13.198s 0m13.091s
> >>
> >> umount /mnt/ocfs2/
> >> echo 2 > /proc/sys/vm/drop_caches
> >> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> >> time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null
> >>
> >> real	0m23.022s 0m21.360s
> >>
> >> umount /mnt/ocfs2/
> >> echo 2 > /proc/sys/vm/drop_caches
> >> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> >> time ls -lR /mnt/ocfs2/ 1>/dev/null
> >>
> >> real	2m45.189s 0m15.019s 
> >> yes, that is it. ;) I don't know we can improve so much when I start up.
> > 
> > Tao,
> > 
> > I'm wondering why the 1st 'ls -lR' did not show us such a huge
> > enhancement, are the system load(by uptime) simliar when doing your 2rd
> > 'ls -lR' contrast tests? if so, that's a really significant
> > gain!!!!:-),great congs!
> Because when we do the 1st 'ls -lR', the inodes are almost contiguous. 
> So the read is very fast. But with the 2nd 'ls -lR' because the old '2nd 
> tar' spread inodes, so we have a poor performance. See
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy 
> for more details.
> > 
> > To get more persuasive testing results, i suggest you do the same tests
> > by considerable times,and then a average statistic results should be
> > more attractive to us:-), and it also minimize the influence of some
> > exceptional system loads:-)
> I don't have that many times to do a large number of tests. ;) Actually 
> I only run my test cases about 2~3 times and give the average time. btw, 
> I have left test env there, if you are interested, you can run it as you 
> wish and give us a complete test result. :)
Tao,

I've done 10 times tests with single-node testcase repeatly, following
is a average statistic reports
=============== Tests with 10 times iteration================ 

1st 'Tar xjvf' result:

Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 43.578s                                       0m 49.355s

1st 'ls -lR' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 23.622s                                        0m 23.508s

1st 'rm -rf' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 57.039s                                       0m 58.612s

2rd 'Tar xjvf' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches
 0m 49.550s                                       0m 52.214s

2rd 'ls -lR' result:
Average real time with 10 times: 
Original kernel                            kernel with enhanced patches

0m 23.591s                                       0m 23.487s

===============Tests end============================ 


From above tests, we really have had a speed-up performance gain when
traversing files  by 'ls -lR' against a kernel tree:),but seems also
encountered a performance lose when populating the files by 'tar xvjf'
according to the contrast tests.


Regards,

Tristan

> 
> Regards,
> Tao
