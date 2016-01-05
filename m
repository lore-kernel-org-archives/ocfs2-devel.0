From: kbuild test robot <lkp@intel.com>
Date: Wed, 6 Jan 2016 07:46:39 +0800
Subject: [Ocfs2-devel] [PATCH 34/35] block: add QUEUE_FLAGs for flush
	and fua
In-Reply-To: <1452027218-32303-35-git-send-email-mchristi@redhat.com>
Message-ID: <201601060735.1UARVDdr%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mike,

[auto build test ERROR on next-20160105]
[cannot apply to dm/for-next v4.4-rc8 v4.4-rc7 v4.4-rc6 v4.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160106-052858
config: um-x86_64_defconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

All errors (new ones prefixed by >>):

   arch/um/drivers/ubd_kern.c: In function 'ubd_add':
>> arch/um/drivers/ubd_kern.c:869:43: error: macro "blk_queue_flush" passed 2 arguments, but takes just 1
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
                                              ^
>> arch/um/drivers/ubd_kern.c:869:2: error: 'blk_queue_flush' undeclared (first use in this function)
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
     ^
   arch/um/drivers/ubd_kern.c:869:2: note: each undeclared identifier is reported only once for each function it appears in

vim +/blk_queue_flush +869 arch/um/drivers/ubd_kern.c

62f96cb0 Jeff Dike          2007-02-10  863  	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
62f96cb0 Jeff Dike          2007-02-10  864  	if (ubd_dev->queue == NULL) {
62f96cb0 Jeff Dike          2007-02-10  865  		*error_out = "Failed to initialize device queue";
80c13749 Jeff Dike          2006-09-29  866  		goto out;
62f96cb0 Jeff Dike          2007-02-10  867  	}
62f96cb0 Jeff Dike          2007-02-10  868  	ubd_dev->queue->queuedata = ubd_dev;
805f11a0 Richard Weinberger 2013-08-18 @869  	blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
62f96cb0 Jeff Dike          2007-02-10  870  
8a78362c Martin K. Petersen 2010-02-26  871  	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
792dd4fc Christoph Hellwig  2009-03-31  872  	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);

:::::: The code at line 869 was first introduced by commit
:::::: 805f11a0d515658106bfbfadceff0eb30bd90ad2 um: ubd: Add REQ_FLUSH suppport

:::::: TO: Richard Weinberger <richard@nod.at>
:::::: CC: Richard Weinberger <richard@nod.at>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 7110 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160106/0c7512d6/attachment-0001.obj 
