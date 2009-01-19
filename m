From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 19 Jan 2009 15:15:11 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation Strategy
	Improvement.v2
In-Reply-To: <1232348850.6623.16.camel@tristan-laptop.cn.oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>	
	<1232093128.6601.12.camel@tristan-laptop.cn.oracle.com>	
	<49704272.4080000@oracle.com>	
	<1232122135.6601.51.camel@tristan-laptop.cn.oracle.com>	
	<4972EF47.5090202@oracle.com>	
	<73490225-F30E-4CF1-ACCE-FBCA845ACBDC@oracle.com>
	<1232348850.6623.16.camel@tristan-laptop.cn.oracle.com>
Message-ID: <4974287F.5040103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



tristan.ye wrote:
> On Sun, 2009-01-18 at 07:17 -0800, Sunil Mushran wrote:
>> How big is this disk? Maybe one kernel tree untar is not be enough to  
>> expose the original issue. Also, use ls -i and/or debugfs to see if  
>> the inodes have some locality.
> 
> Tao, sunil
> 
> I've tested it out with more attempts, it may have something to do with
> the disk size. but the root pause why i did not get a excited speed-up
> performance gain was due to the iscsi-target(iscsi server) cache. the
> operation in your testcase which was meant for cache dropping is aimed
> at client side(a 'echo 2>/proc/sys/vm/drop_cache' only flush the fs's
> cache for iscsi initor(isci client)). 
> 
> Tao,
> 
> You can verify this by pausing the tests at the right point before we
> start '2rd ls -lR', then flush the iscsi-target's cache by 'service
> iscsi-target restart'(there may be a more graceful way to do this),after
> this done, resume the tests, then you'll find the the realtime it
> consumed will be up to 3 mins around:)
cool, so I am very glad that you got the same result as mine. ;)
> 
> Btw, i really saw lots of locality by 'ls -li' for inodes under a same
> dir, take /mnt/ocfs2/linux-2.6.28/include/linux for instance, almost all
> of its inodes are contiguous one by one regarding to its inode number.
yeah, that is the desired behaviour with my 3 patches. :)

Then do you have any updated test statistics?

Regards,
Tao
