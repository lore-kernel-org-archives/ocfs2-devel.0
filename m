From: Eugene Istomin <E.Istomin@edss.ee>
Date: Mon, 18 May 2015 13:05:25 +0300
Subject: [Ocfs2-devel] Read IOPS storm in case of reflinking running VM
	disk
In-Reply-To: <7399970.tYBXgTWiTd@evis>
References: <2921711.4r2dU24ThL@evis> <7399970.tYBXgTWiTd@evis>
Message-ID: <16475571.Tn5VYR8sPy@evis>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello, 

ping
-- 
Best regards,
Eugene Istomin

On Monday, May 11, 2015 11:48:11 AM Eugene Istomin wrote:
> Hello Goldwyn,
> 
> Do you know something about such behavior?
> The question is why a reflink operation on VM disk leads to plenty of read
> ops? Is this related to CoW specific structures?
> 
> We can provide others details & ssh to testbed.
> 
> > Hello,
> > 
> > after deploying reflink-based VM snapshots to production servers we
> > discovered a performace degradation:
> > 
> > OS: Opensuse 13.1, 13.2
> > Hypervisors: Xen 4.4, 4.5
> > Dom0 kernels: 3.12, 3.16, 3.18
> > DomU kernels: 3.12, 3.16, 3.18
> > Tested DomU disk backends: tapdisk2, qdisk
> > 
> > 
> > 1) on DomU (VM)
> > #dd if=/dev/zero of=test2 bs=1M count=6000
> > 
> > 2) atop on Dom0:
> > sdb - busy:92% - read:375 - write:130902
> > Reads are from others VMs, seems OK
> > 
> > 3) DomU dd finished:
> > 6291456000 bytes (6.3 GB) copied, 16.6265 s, 378 MB/s
> > 
> > 4) Lets start dd again & do a snapshot:
> > #dd if=/dev/zero of=test2 bs=1M count=6000
> > #reflink test.raw ref/
> > 
> > 5) atop on Dom0:
> > sdb - busy:97% - read:112740 - write:28037
> > So, Read IOPS = 112740, why?
> > 
> > 6) DomU dd finished:
> > 6291456000 bytes (6.3 GB) copied, 175.45 s, 35.9 MB/s
> > 
> > 7) Second & further reflinks do not change the atop stat & dd time
> > #dd if=/dev/zero of=test2 bs=1M count=6000
> > #reflink --backup=t test.raw ref/    \\ * n times
> > ~ 6291456000 bytes (6.3 GB) copied, 162.959 s, 38.6 MB/s
> > 
> > The question is why reflinking a running VM disk leads to read IOPS storm?
> > 
> > 
> > Thanks!
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150518/fd9107e5/attachment.html 
