From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Tue Mar  2 09:04:13 2004
Subject: [Ocfs2-devel] Fail to create OCFS volumn on the hard disk via a
	QLA2312 fiberchannel card.
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E16423B@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

/dev/rawctl is part of the "raw block device" driver interface.  You
need to turn on the raw device driver option (CONFIG_RAW_DRIVER) in your
kernel build.

I have always created a new file system from my 2.4 kernel (that has all
possible modules built and properly configured to load when needed), so
I don't know for sure if mkfs.ocfs will work correctly after turning on
the raw block device driver on a 2.6 kernel, but it should.

    --rusty

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-
>bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
>Sent: Tuesday, March 02, 2004 1:01 AM
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] Fail to create OCFS volumn on the hard disk via
a
>QLA2312 fiberchannel card.
>
>Hi,
>
>	I am Sonic Zhang from Intel PRC. I am now working with Rusty to
>port the OCFSv2 to kernel 2.6.
>
>	I have set up an environment to compile and run the OCFS v2
>driver. I run kernel 2.6.0 on 2 IA32 servers with 2 QLogic QLA2312
fiber
>channel cards and 1 hard disk array. After I download the source code
of
>OCFS tools and compile them, I found I can't create OCFS volume on the
>disk connected via the fiber channel card, while EXT3 volume can be
>created successful on the same disk.
>
>	I run following command to create the OCFS volume.
>
>[host1]>mkfs.ocfs -F -b 128 -L testocfs -m /mnt/ocfs /dev/sdb2
>Error opening /dev/rawctl .
>No such device, bindraw.c 62.
>
>
>	Does anybody know what's the cause?
>
>	Thank you.
>
>
>
>*********************************************
>Sonic Zhang
>Software Engineer
>Intel China Software Lab
>Tel: (086)021-52574545-1667
>iNet: 752-1667
>*********************************************
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
