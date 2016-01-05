From: kbuild test robot <lkp@intel.com>
Date: Wed, 6 Jan 2016 07:53:09 +0800
Subject: [Ocfs2-devel] [PATCH 35/35] block, drivers,
 fs: rename REQ_FLUSH to REQ_PREFLUSH
In-Reply-To: <1452027218-32303-36-git-send-email-mchristi@redhat.com>
Message-ID: <201601060734.Dqx8lzOI%fengguang.wu@intel.com>
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
   arch/um/drivers/ubd_kern.c:869:43: error: macro "blk_queue_flush" passed 2 arguments, but takes just 1
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
                                              ^
   arch/um/drivers/ubd_kern.c:869:2: error: 'blk_queue_flush' undeclared (first use in this function)
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
     ^
   arch/um/drivers/ubd_kern.c:869:2: note: each undeclared identifier is reported only once for each function it appears in
   arch/um/drivers/ubd_kern.c: In function 'do_ubd_request':
>> arch/um/drivers/ubd_kern.c:1293:24: error: 'REQ_FLUSH' undeclared (first use in this function)
      if (req->cmd_flags & REQ_FLUSH) {
                           ^

vim +/REQ_FLUSH +1293 arch/um/drivers/ubd_kern.c

a0044bdf Jeff Dike          2007-05-06  1287  			dev->start_sg = 0;
a0044bdf Jeff Dike          2007-05-06  1288  			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
a0044bdf Jeff Dike          2007-05-06  1289  		}
a0044bdf Jeff Dike          2007-05-06  1290  
a0044bdf Jeff Dike          2007-05-06  1291  		req = dev->request;
805f11a0 Richard Weinberger 2013-08-18  1292  
805f11a0 Richard Weinberger 2013-08-18 @1293  		if (req->cmd_flags & REQ_FLUSH) {
805f11a0 Richard Weinberger 2013-08-18  1294  			io_req = kmalloc(sizeof(struct io_thread_req),
805f11a0 Richard Weinberger 2013-08-18  1295  					 GFP_ATOMIC);
805f11a0 Richard Weinberger 2013-08-18  1296  			if (io_req == NULL) {

:::::: The code at line 1293 was first introduced by commit
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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160106/dd9787e4/attachment.obj 
