From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 07 Aug 2009 14:01:19 -0700
Subject: [Ocfs2-devel] mkfs.ocfs2 bug?
In-Reply-To: <1249678563.13937.685.camel@hermosa>
References: <1249678563.13937.685.camel@hermosa>
Message-ID: <4A7C961F.7090608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1.4.0 is very old. sles needs to refresh the tools.

Peter W. Morreale wrote:
> Hi all, I had the following happen when playing with adding the -C
> option to mkfs.ocfs2 commandline.  Is this a known issue?   Should I
> file a bug report?
>
> Works fine as long as I do not specify a cluster size.
>
> Best,
> -PWM
>
> silverton:/etc/slert # mkfs.ocfs2 -N 255 -C 32768 /dev/sdb3
> mkfs.ocfs2 1.4.0
> Filesystem label=
> Block size=4096 (bits=12)
> Cluster size=32768 (bits=15)
> Volume size=142618099712 (4352359 clusters) (34818872 blocks)
> 135 cluster groups (tail covers 30055 clusters, rest cover 32256
> clusters)
> Journal size=268435456
> Initial number of node slots: 255
> Creating bitmaps: done
> Initializing superblock: done
> Writing system files: *** glibc detected *** mkfs.ocfs2: double free or
> corruption (!prev): 0x00000000009f2000 ***
> ======= Backtrace: =========
> /lib64/libc.so.6[0x2b7d7f5a131e]
> /lib64/libc.so.6(__libc_free+0x6c)[0x2b7d7f5a2d7c]
> mkfs.ocfs2[0x4041d5]
> mkfs.ocfs2[0x4056c4]
> /lib64/libc.so.6(__libc_start_main+0xf4)[0x2b7d7f553184]
> mkfs.ocfs2[0x402439]
> ======= Memory map: ========
> 00400000-0041d000 r-xp 00000000 08:02
> 377243                             /sbin/mkfs.ocfs2
> 0051d000-0051e000 rw-p 0001d000 08:02
> 377243                             /sbin/mkfs.ocfs2
> 0051e000-00a10000 rw-p 0051e000 00:00 0
> [heap]
> 2b7d7f0fb000-2b7d7f116000 r-xp 00000000 08:02
> 11567106                   /lib64/ld-2.4.so
> 2b7d7f116000-2b7d7f117000 rw-p 2b7d7f116000 00:00 0 
> 2b7d7f131000-2b7d7f132000 rw-p 2b7d7f131000 00:00 0 
> 2b7d7f215000-2b7d7f217000 rw-p 0001a000 08:02
> 11567106                   /lib64/ld-2.4.so
> 2b7d7f217000-2b7d7f219000 r-xp 00000000 08:02
> 11567181                   /lib64/libcom_err.so.2.1
> 2b7d7f219000-2b7d7f318000 ---p 00002000 08:02
> 11567181                   /lib64/libcom_err.so.2.1
> 2b7d7f318000-2b7d7f319000 rw-p 00001000 08:02
> 11567181                   /lib64/libcom_err.so.2.1
> 2b7d7f319000-2b7d7f31c000 r-xp 00000000 08:02
> 11567238                   /lib64/libuuid.so.1.2
> 2b7d7f31c000-2b7d7f41b000 ---p 00003000 08:02
> 11567238                   /lib64/libuuid.so.1.2
> 2b7d7f41b000-2b7d7f41c000 rw-p 00002000 08:02
> 11567238                   /lib64/libuuid.so.1.2
> 2b7d7f41c000-2b7d7f430000 r-xp 00000000 08:02
> 11567139                   /lib64/libpthread-2.4.so
> 2b7d7f430000-2b7d7f52f000 ---p 00014000 08:02
> 11567139                   /lib64/libpthread-2.4.so
> 2b7d7f52f000-2b7d7f531000 rw-p 00013000 08:02
> 11567139                   /lib64/libpthread-2.4.so
> 2b7d7f531000-2b7d7f536000 rw-p 2b7d7f531000 00:00 0 
> 2b7d7f536000-2b7d7f66c000 r-xp 00000000 08:02
> 11567113                   /lib64/libc-2.4.so
> 2b7d7f66c000-2b7d7f76c000 ---p 00136000 08:02
> 11567113                   /lib64/libc-2.4.so
> 2b7d7f76c000-2b7d7f76f000 r--p 00136000 08:02
> 11567113                   /lib64/libc-2.4.so
> 2b7d7f76f000-2b7d7f771000 rw-p 00139000 08:02
> 11567113                   /lib64/libc-2.4.so
> 2b7d7f771000-2b7d7f777000 rw-p 2b7d7f771000 00:00 0 
> 2b7d7f800000-2b7d7f821000 rw-p 2b7d7f800000 00:00 0 
> 2b7d7f821000-2b7d7f900000 ---p 2b7d7f821000 00:00 0 
> 2b7d7f900000-2b7d7f90d000 r-xp 00000000 08:02
> 11567169                   /lib64/libgcc_s.so.1
> 2b7d7f90d000-2b7d7fa0c000 ---p 0000d000 08:02
> 11567169                   /lib64/libgcc_s.so.1
> 2b7d7fa0c000-2b7d7fa0d000 rw-p 0000c000 08:02
> 11567169                   /lib64/libgcc_s.so.1
> 7fff2b99a000-7fff2b9af000 rw-p 7fff2b99a000 00:00 0
> [stack]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
> [vdso]
> Aborted
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
