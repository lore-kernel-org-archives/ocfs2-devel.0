From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Mar  2 03:01:29 2004
Subject: [Ocfs2-devel] 
	Fail to create OCFS volumn on the hard disk via a QLA2312 fiber
	channel card.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E5A30D0@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	I am Sonic Zhang from Intel PRC. I am now working with Rusty to
port the OCFSv2 to kernel 2.6. 

	I have set up an environment to compile and run the OCFS v2
driver. I run kernel 2.6.0 on 2 IA32 servers with 2 QLogic QLA2312 fiber
channel cards and 1 hard disk array. After I download the source code of
OCFS tools and compile them, I found I can't create OCFS volume on the
disk connected via the fiber channel card, while EXT3 volume can be
created successful on the same disk. 

	I run following command to create the OCFS volume.

[host1]>mkfs.ocfs -F -b 128 -L testocfs -m /mnt/ocfs /dev/sdb2
Error opening /dev/rawctl .
No such device, bindraw.c 62.


	Does anybody know what's the cause?

	Thank you.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
