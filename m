From: Eugene Istomin <E.Istomin@edss.ee>
Date: Thu, 21 May 2015 01:33:43 +0300
Subject: [Ocfs2-devel] Read IOPS storm in case of reflinking running VM
	disk
In-Reply-To: <555A2544.2070607@suse.de>
References: <2921711.4r2dU24ThL@evis> <16475571.Tn5VYR8sPy@evis>
	<555A2544.2070607@suse.de>
Message-ID: <2137407.TBXHbaxxee@evis>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Goldwyn,

thanks for the answer!

I read 
https://oss.oracle.com/osswiki/OCFS2(2f)DesignDocs(2f)RefcountTrees.html  
carefully to understand the problem.

As i understand:
There are B-Tree structures for reflink: ocfs2_refcount_tree; 
ocfs2_refcount_block -> ocfs2_refcount_list -> ocfs2_refcount_rec
"The refcount tree root is a refcount block pointed to by i_refcount_loc"
Some operations needs extra uncached lookups
Also i dumped frag/stat/refcount from production hypervisor node using 
debugfs.ocfs2, files are in attach (url as alt way - 
http://public.edss.ee/tmp/debugfs.tar.gz ). 

Hypervisor OCFS2 mount options: 
rw,nosuid,noexec,noatime,heartbeat=none,nointr,data=ordered,errors=remount-
ro,localalloc=2048,coherency=full,user_xattr,acl

Mkfs string:
mkfs.ocfs2 -b 4KB -C 1MB -N 2 -T vmstore -L "storage" --fs-
features=local,backup-super,sparse,unwritten,inline-
data,metaecc,refcount,xattr,indexed-dirs,discontig-bg


Can you please explain why there are so many extent blocks (204)? Is it really 
impossible to store plenty of clusters in single extent (like #25, block 
3874095 -> 20847 clusters)? 

-- 
Best regards,
Eugene Istomin
IT Architect

On Monday, May 18, 2015 12:45:40 PM Goldwyn Rodrigues wrote:
> Hi Eugene,
> 
> Sorry, had been busy with other work and this slipped on the list.
> 
> >  > Do you know something about such behavior?
> >  > 
> >  > The question is why a reflink operation on VM disk leads to plenty of
> > 
> > read
> > 
> >  > ops? Is this related to CoW specific structures?
> 
> This is in fact related to the CoW. An ocfs2 file is an extent tree,
> which the extent headers marking if the extent is a reflinked or not
> with the number of reflinks.
> 
> If you perform a reflink on a file which is being changed constantly,
> not only recreate the extent tree, but also decrease the refcount of the
> ones already present. Add to it, the extents which need to be read for
> replication.
> 
> 
> HTH,
> 
> >  > We can provide others details & ssh to testbed.
> >  > 
> >  > > Hello,
> >  > > 
> >  > > 
> >  > > 
> >  > > after deploying reflink-based VM snapshots to production servers we
> >  > > 
> >  > > discovered a performace degradation:
> >  > > 
> >  > > 
> >  > > 
> >  > > OS: Opensuse 13.1, 13.2
> >  > > 
> >  > > Hypervisors: Xen 4.4, 4.5
> >  > > 
> >  > > Dom0 kernels: 3.12, 3.16, 3.18
> >  > > 
> >  > > DomU kernels: 3.12, 3.16, 3.18
> >  > > 
> >  > > Tested DomU disk backends: tapdisk2, qdisk
> >  > > 
> >  > > 
> >  > > 
> >  > > 
> >  > > 
> >  > > 1) on DomU (VM)
> >  > > 
> >  > > #dd if=/dev/zero of=test2 bs=1M count=6000
> >  > > 
> >  > > 
> >  > > 
> >  > > 2) atop on Dom0:
> >  > > 
> >  > > sdb - busy:92% - read:375 - write:130902
> >  > > 
> >  > > Reads are from others VMs, seems OK
> >  > > 
> >  > > 
> >  > > 
> >  > > 3) DomU dd finished:
> >  > > 
> >  > > 6291456000 bytes (6.3 GB) copied, 16.6265 s, 378 MB/s
> >  > > 
> >  > > 
> >  > > 
> >  > > 4) Lets start dd again & do a snapshot:
> >  > > 
> >  > > #dd if=/dev/zero of=test2 bs=1M count=6000
> >  > > 
> >  > > #reflink test.raw ref/
> >  > > 
> >  > > 
> >  > > 
> >  > > 5) atop on Dom0:
> >  > > 
> >  > > sdb - busy:97% - read:112740 - write:28037
> >  > > 
> >  > > So, Read IOPS = 112740, why?
> >  > > 
> >  > > 
> >  > > 
> >  > > 6) DomU dd finished:
> >  > > 
> >  > > 6291456000 bytes (6.3 GB) copied, 175.45 s, 35.9 MB/s
> >  > > 
> >  > > 
> >  > > 
> >  > > 7) Second & further reflinks do not change the atop stat & dd time
> >  > > 
> >  > > #dd if=/dev/zero of=test2 bs=1M count=6000
> >  > > 
> >  > > #reflink --backup=t test.raw ref/ \\ * n times
> >  > > 
> >  > > ~ 6291456000 bytes (6.3 GB) copied, 162.959 s, 38.6 MB/s
> >  > > 
> >  > > 
> >  > > 
> >  > > The question is why reflinking a running VM disk leads to read IOPS
> > 
> > storm?
> > 
> >  > > Thanks!
> >  > 
> >  > _______________________________________________
> >  > 
> >  > Ocfs2-devel mailing list
> >  > 
> >  > Ocfs2-devel at oss.oracle.com
> >  > 
> >  > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150521/23cd43e2/attachment-0001.html 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: debugfs.tar.gz
Type: application/x-compressed-tar
Size: 729820 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150521/23cd43e2/attachment-0001.bin 
