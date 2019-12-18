From: Changwei Ge <chge@linux.alibaba.com>
Date: Wed, 18 Dec 2019 20:34:35 +0800
Subject: [Ocfs2-devel] OCFS2 has low performance when writing the same
 file from the different nodes concurrently
In-Reply-To: <CH2PR18MB320632DA31A85DB151E9BA75CF530@CH2PR18MB3206.namprd18.prod.outlook.com>
References: <CH2PR18MB320632DA31A85DB151E9BA75CF530@CH2PR18MB3206.namprd18.prod.outlook.com>
Message-ID: <8dd1927a-6fa7-97ac-f45d-e71d353f35d0@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,

Do we really have customer use case that an unique file is writing from 
different nodes concurrently?

If an cluster application on top of ocfs2 can collaborate its each 
member, it might make sense. Can you share some particular use cases?

Speaking of the poor performance as you reported, I admit that it's true.

As ocfs2 doesn't have its own journal module but re-use ext4/jbd2 which 
is not designed for cluster file system, it doesn't have a global 
journal transaction number assigned to each node. So each time we have 
to update metadata(system files, regular files(even a/t/cime), etc), 
the blocked node has to drain its journal region to checkpoint all the 
records to final destination of file system, then release the cluster 
lock. Thus to keep the file system consistency, of course, ocfs2 now 
does some trick like passing inode meta via dlm lock reply directly to 
save a round of disk read. But the checkpoint is still time consuming. 
If we can have global transaction mechanism, it can alleviate the 
performance drop.

Another point I can think of is that even different nodes are wring 
different regions of a single file, ocfs2 still drops the whole address 
mapping of the inode. I don't this it's necessary. This point can be 
optimized. Perhaps, you can tweak your test workload to direct-io to see 
if we still have such an obvious drop?

Another thing I recall is that right now, for bigger cluster size like 
1M, with 'sparse-file' enabled, ocfs2 has a serious write penalty which 
occupies underlying bandwidth when workload is something like 4k random 
write. Better we can do something to improve it too. :-)

Thanks,
Changwei


On 12/18/19 6:26 PM, Gang He wrote:
> Hi Guys,
> 
> OCFS2 has low performance when writing the same file from the different nodes concurrently,
> it is very easy to reproduce this problem via dd command.
> For example, there are 5 ocfs2 nodes with a shared disk(ram disk) from one physical machine,
> then run dd command to write the same file in the shared disk(ocfs2 partition) from these 5
> ocfs2 nodes concurrently.
> the result is as below,
> sle12sp4-nd1:/ # /dd_f.sh
> + ssh sle12sp4-nd5 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd4 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd3 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd2 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd1 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 72.0841 s, 1.1 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 72.4865 s, 1.1 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 72.4921 s, 1.1 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 72.5006 s, 1.1 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 72.5029 s, 1.1 MB/s
> /dd_f.sh done ... 73 sec.
> 
> But, if you run this dd command from only one ocfs2 node or run this dd command from 5 gfs2 nodes concurrently,
> the execution time is very short.
> sle12sp4-nd1:/ # /dd_f.sh 1
> + ssh sle12sp4-nd5 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd4 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd3 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd2 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
> + ssh sle12sp4-nd1 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 0.318876 s, 257 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 0.738694 s, 111 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 0.795672 s, 103 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 0.850756 s, 96.3 MB/s
> 10000+0 records in
> 10000+0 records out
> 81920000 bytes (82 MB, 78 MiB) copied, 0.90767 s, 90.3 MB/s
> /dd_f.sh done ... 2 sec.
> 
> So far, I feel this problem should be considered as design issue for OCFS2.
> Hopefully, we can optimize write performance in this case via learning from other file systems.
> For more detailed data, you can refer to my gist at https://urldefense.proofpoint.com/v2/url?u=https-3A__gist.github.com_ganghe_bbc4f3d94e3596715dd08e39dfacd33f&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=dNLMGrZuCzc_taNLW5rBOOxiMrYH0jE9kYATcWtz9lw&s=4u6_yHYiRMe1dJeTaOXIJ9kwAIuOqLRdOVWScvqlqFM&e= .
> 
> Thanks
> Gang
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
