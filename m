From: kbuild test robot <lkp@intel.com>
Date: Thu, 25 Feb 2016 06:10:33 +0800
Subject: [Ocfs2-devel] [PATCH 26/35] block: set op to REQ_OP
In-Reply-To: <1456343292-14535-27-git-send-email-mchristi@redhat.com>
Message-ID: <201602250636.ppkpGx7r%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mike,

[auto build test WARNING on next-20160224]
[cannot apply to dm/for-next v4.5-rc5 v4.5-rc4 v4.5-rc3 v4.5-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160225-041726
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   lib/crc32.c:148: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:148: warning: Excess function parameter 'tab' description in 'crc32_le_generic'
   lib/crc32.c:293: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:293: warning: Excess function parameter 'tab' description in 'crc32_be_generic'
   lib/crc32.c:1: warning: no structured comments found
>> block/blk-core.c:1248: warning: No description found for parameter 'op'
>> block/blk-core.c:1248: warning: No description found for parameter 'op'

vim +/op +1248 block/blk-core.c

da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1232   * @q: request_queue to allocate request from
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1233   * op: REQ_OP_READ/REQ_OP_WRITE
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1234   * @op_flags: rq_flag_bits
da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1235   * @bio: bio to allocate request for (can be %NULL)
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1236   * @gfp_mask: allocation mask
da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1237   *
d0164adc block/blk-core.c          Mel Gorman     2015-11-06  1238   * Get a free request from @q.  If %__GFP_DIRECT_RECLAIM is set in @gfp_mask,
d0164adc block/blk-core.c          Mel Gorman     2015-11-06  1239   * this function keeps retrying under memory pressure and fails iff @q is dead.
d6344532 drivers/block/ll_rw_blk.c Nick Piggin    2005-06-28  1240   *
da3dae54 block/blk-core.c          Masanari Iida  2014-09-09  1241   * Must be called with @q->queue_lock held and,
a492f075 block/blk-core.c          Joe Lawrence   2014-08-28  1242   * Returns ERR_PTR on failure, with @q->queue_lock held.
a492f075 block/blk-core.c          Joe Lawrence   2014-08-28  1243   * Returns request pointer on success, with @q->queue_lock *not held*.
^1da177e drivers/block/ll_rw_blk.c Linus Torvalds 2005-04-16  1244   */
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1245  static struct request *get_request(struct request_queue *q, int op,
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1246  				   int op_flags, struct bio *bio,
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1247  				   gfp_t gfp_mask)
^1da177e drivers/block/ll_rw_blk.c Linus Torvalds 2005-04-16 @1248  {
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1249  	const bool is_sync = rw_is_sync(op, op_flags) != 0;
450991bc drivers/block/ll_rw_blk.c Nick Piggin    2005-06-28  1250  	DEFINE_WAIT(wait);
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1251  	struct request_list *rl;
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1252  	struct request *rq;
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1253  
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1254  	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1255  retry:
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1256  	rq = __get_request(rl, op, op_flags, bio, gfp_mask);

:::::: The code at line 1248 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 6308 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160225/8d62a852/attachment.obj 
