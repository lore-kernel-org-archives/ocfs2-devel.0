From: Robert Smith <spamfree@wansecurity.com>
Date: Fri, 1 Jan 2010 15:12:18 +0900
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JBD2,
	huge partition support,
	Volume might try to write to blocks beyond what jbd can address in 32
	bits)
In-Reply-To: <20091231200836.GA3301@mail.oracle.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
	<20091231034243.GA2560@mail.oracle.com>
	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
	<4B3CF610.4070603@oracle.com>
	<6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
	<20091231200836.GA3301@mail.oracle.com>
Message-ID: <F5F35C06-77A8-4902-908D-52BC2A052F44@wansecurity.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I started a new kernel compile before I went to bed, and installed it this morning.

To my surprise, when the system booted up, it mounted the partition.


root at s2-replay02:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/s2--replay02-root
                      1.9T   11G  1.8T   1% /
udev                  1.9G  204K  1.9G   1% /dev
none                  1.9G     0  1.9G   0% /dev/shm
none                  1.9G   36K  1.9G   1% /var/run
none                  1.9G     0  1.9G   0% /var/lock
none                  1.9G     0  1.9G   0% /lib/init/rw
/dev/sda5             228M  165M   51M  77% /boot
/dev/mapper/replays-ReplayDataVolume001
                       37T  1.3G   37T   1% /data/storage/ReplayDataVolume001
root at s2-replay02:~# mounted.ocfs2 
usage: mounted.ocfs2 [-d] [-f] [device]
        -d quick detect
        -f full detect
root at s2-replay02:~# mounted.ocfs2 -f /dev/replays/ReplayDataVolume001 
Device                FS     Nodes
/dev/replays/ReplayDataVolume001  ocfs2  s2-replay02
root at s2-replay02:~#


1.3G for FS overhead. Partially due to the way I formatted I'm sure.

ie. mkfs.ocfs2 -L "ReplayDataVolume001" -C 1M -N 2 -J block64 -F -v -T datafiles -M cluster --fs-feature-level=max-features /dev/replays/ReplayDataVolume001


And for some quick performance checks:

root at s2-replay02:~# time dd bs=100M count=10 if=/dev/zero of=/data/storage/ReplayDataVolume001/big_file
10+0 records in
10+0 records out
1048576000 bytes (1.0 GB) copied, 1.00014 s, 1.0 GB/s

real    0m1.008s
user    0m0.000s
sys     0m0.920s
root at s2-replay02:~# time dd bs=100M count=100 if=/dev/zero of=/data/storage/ReplayDataVolume001/bigger_file
100+0 records in
100+0 records out
10485760000 bytes (10 GB) copied, 17.1197 s, 612 MB/s

real    0m17.796s
user    0m0.000s
sys     0m10.350s
root at s2-replay02:~# time dd bs=100M count=1000 if=/dev/zero of=/data/storage/ReplayDataVolume001/biggest_file
1000+0 records in
1000+0 records out
104857600000 bytes (105 GB) copied, 176.464 s, 594 MB/s

real    2m57.357s
user    0m0.000s
sys     1m50.520s
root at s2-replay02:~# time dd bs=1000M count=1000 if=/dev/zero of=/data/storage/ReplayDataVolume001/biggest_yet_file
1000+0 records in               
1000+0 records out
1048576000000 bytes (1.0 TB) copied, 1825.52 s, 574 MB/s

real    30m26.573s
user    0m0.000s
sys     18m59.110s
root at s2-replay02:~#


Every 1.0s: ls -aFl /data/storage/ReplayDataVolume001/*                           Fri Jan  1 00:03:50 2010

-rw-r--r-- 1 root root    1048576000 2009-12-31 23:23 /data/storage/ReplayDataVolume001/big_file
-rw-r--r-- 1 root root   10485760000 2009-12-31 23:24 /data/storage/ReplayDataVolume001/bigger_file
-rw-r--r-- 1 root root  104857600000 2009-12-31 23:28 /data/storage/ReplayDataVolume001/biggest_file
-rw-r--r-- 1 root root 1048576000000 2010-01-01 00:01 /data/storage/ReplayDataVolume001/biggest_yet_file

/data/storage/ReplayDataVolume001/lost+found:
total 0
drwxr-xr-x 2 root root 3896 2009-12-31 11:53 ./
drwxr-xr-x 3 root root 3896 2009-12-31 23:31 ../


I guess I'll try a 20 terabyte file now, and seek past 16TB ?

Any other tests I can run to see how she's gonna hold up? What can I do to try to break it?

-Robert



On Jan 1, 2010, at 5:08 AM, Joel Becker wrote:

> On Fri, Jan 01, 2010 at 04:36:02AM +0900, Robert Smith wrote:
>> Oh, I found it at line #2163 of fs/ocfs2/super.c.
>> 
>> I imagine that something as simple as the following would work, but perhaps I'll wait for your feedback.
>> 
>> 
>> /*
>>        if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
>>> (u32)~0UL) {
>>                mlog(ML_ERROR, "Volume might try to write to blocks beyond "
>>                     "what jbd can address in 32 bits.\n");
>>                status = -EINVAL;
>>                goto bail;
>>        }
>> */
> 
> 	That should work.  The real solution will check based on the
> journal flags.  Be warned, there be tygers in here.
> 
> Joel
> 
> -- 
> 
> "But all my words come back to me
> In shades of mediocrity.
> Like emptiness in harmony
> I need someone to comfort me."
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
