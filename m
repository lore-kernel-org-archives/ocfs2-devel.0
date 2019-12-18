From: Gang He <GHe@suse.com>
Date: Wed, 18 Dec 2019 10:26:25 +0000
Subject: [Ocfs2-devel] OCFS2 has low performance when writing the same file
 from the different nodes concurrently
Message-ID: <CH2PR18MB320632DA31A85DB151E9BA75CF530@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guys,

OCFS2 has low performance when writing the same file from the different nodes concurrently, 
it is very easy to reproduce this problem via dd command.
For example, there are 5 ocfs2 nodes with a shared disk(ram disk) from one physical machine, 
then run dd command to write the same file in the shared disk(ocfs2 partition) from these 5 
ocfs2 nodes concurrently.
the result is as below,
sle12sp4-nd1:/ # /dd_f.sh
+ ssh sle12sp4-nd5 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd4 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd3 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd2 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd1 'dd if=/dev/zero of=/mnt/ocfs2/dd.txt conv=notrunc bs=8k count=10000'
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 72.0841 s, 1.1 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 72.4865 s, 1.1 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 72.4921 s, 1.1 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 72.5006 s, 1.1 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 72.5029 s, 1.1 MB/s
/dd_f.sh done ... 73 sec.

But, if you run this dd command from only one ocfs2 node or run this dd command from 5 gfs2 nodes concurrently,
the execution time is very short.
sle12sp4-nd1:/ # /dd_f.sh 1
+ ssh sle12sp4-nd5 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd4 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd3 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd2 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
+ ssh sle12sp4-nd1 'dd if=/dev/zero of=/mnt/gfs2/dd.txt conv=notrunc bs=8k count=10000'
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 0.318876 s, 257 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 0.738694 s, 111 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 0.795672 s, 103 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 0.850756 s, 96.3 MB/s
10000+0 records in
10000+0 records out
81920000 bytes (82 MB, 78 MiB) copied, 0.90767 s, 90.3 MB/s
/dd_f.sh done ... 2 sec.

So far, I feel this problem should be considered as design issue for OCFS2.
Hopefully, we can optimize write performance in this case via learning from other file systems.
For more detailed data, you can refer to my gist at https://urldefense.proofpoint.com/v2/url?u=https-3A__gist.github.com_ganghe_bbc4f3d94e3596715dd08e39dfacd33f&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=dNLMGrZuCzc_taNLW5rBOOxiMrYH0jE9kYATcWtz9lw&s=4u6_yHYiRMe1dJeTaOXIJ9kwAIuOqLRdOVWScvqlqFM&e= .

Thanks
Gang
