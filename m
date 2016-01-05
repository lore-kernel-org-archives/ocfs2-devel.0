From: kbuild test robot <lkp@intel.com>
Date: Wed, 6 Jan 2016 07:20:33 +0800
Subject: [Ocfs2-devel] [PATCH 05/35] fs: have ll_rw_block users pass in
 op and flags separately
In-Reply-To: <1452027218-32303-6-git-send-email-mchristi@redhat.com>
Message-ID: <201601060709.woTc6jMw%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mike,

[auto build test WARNING on next-20160105]
[cannot apply to dm/for-next v4.4-rc8 v4.4-rc7 v4.4-rc6 v4.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160106-052858
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

>> fs/buffer.c:3091: warning: No description found for parameter 'op_flags'
   include/linux/jbd2.h:439: warning: No description found for parameter 'i_transaction'
   include/linux/jbd2.h:439: warning: No description found for parameter 'i_next_transaction'
   include/linux/jbd2.h:439: warning: No description found for parameter 'i_list'
   include/linux/jbd2.h:439: warning: No description found for parameter 'i_vfs_inode'
   include/linux/jbd2.h:439: warning: No description found for parameter 'i_flags'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_rsv_handle'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_reserved'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_type'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_line_no'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_start_jiffies'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_requested_credits'
   include/linux/jbd2.h:495: warning: No description found for parameter 'h_lockdep_map'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_chkpt_bhs[JBD2_NR_BATCH]'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_devname[BDEVNAME_SIZE+24]'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_average_commit_time'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_min_batch_time'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_max_batch_time'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_commit_callback'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_failed_commit'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_chksum_driver'
   include/linux/jbd2.h:1038: warning: No description found for parameter 'j_csum_seed'
   include/linux/jbd2.h:1038: warning: Excess struct/union/enum/typedef member 'j_history' description in 'journal_s'
   include/linux/jbd2.h:1038: warning: Excess struct/union/enum/typedef member 'j_history_max' description in 'journal_s'
   include/linux/jbd2.h:1038: warning: Excess struct/union/enum/typedef member 'j_history_cur' description in 'journal_s'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'rsv_blocks'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'gfp_mask'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'type'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'line_no'
   fs/jbd2/transaction.c:505: warning: No description found for parameter 'type'
   fs/jbd2/transaction.c:505: warning: No description found for parameter 'line_no'
   fs/jbd2/transaction.c:635: warning: No description found for parameter 'gfp_mask'

vim +/op_flags +3091 fs/buffer.c

^1da177e Linus Torvalds    2005-04-16  3075   *
^1da177e Linus Torvalds    2005-04-16  3076   * This function drops any buffer that it cannot get a lock on (with the
9cb569d6 Christoph Hellwig 2010-08-11  3077   * BH_Lock state bit), any buffer that appears to be clean when doing a write
9cb569d6 Christoph Hellwig 2010-08-11  3078   * request, and any buffer that appears to be up-to-date when doing read
9cb569d6 Christoph Hellwig 2010-08-11  3079   * request.  Further it marks as clean buffers that are processed for
9cb569d6 Christoph Hellwig 2010-08-11  3080   * writing (the buffer cache won't assume that they are actually clean
9cb569d6 Christoph Hellwig 2010-08-11  3081   * until the buffer gets unlocked).
^1da177e Linus Torvalds    2005-04-16  3082   *
^1da177e Linus Torvalds    2005-04-16  3083   * ll_rw_block sets b_end_io to simple completion handler that marks
e227867f Masanari Iida     2014-02-18  3084   * the buffer up-to-date (if appropriate), unlocks the buffer and wakes
^1da177e Linus Torvalds    2005-04-16  3085   * any waiters. 
^1da177e Linus Torvalds    2005-04-16  3086   *
^1da177e Linus Torvalds    2005-04-16  3087   * All of the buffers must be for the same device, and must also be a
^1da177e Linus Torvalds    2005-04-16  3088   * multiple of the current approved size for the device.
^1da177e Linus Torvalds    2005-04-16  3089   */
3390b48e Mike Christie     2016-01-05  3090  void ll_rw_block(int op, int op_flags,  int nr, struct buffer_head *bhs[])
^1da177e Linus Torvalds    2005-04-16 @3091  {
^1da177e Linus Torvalds    2005-04-16  3092  	int i;
^1da177e Linus Torvalds    2005-04-16  3093  
^1da177e Linus Torvalds    2005-04-16  3094  	for (i = 0; i < nr; i++) {
^1da177e Linus Torvalds    2005-04-16  3095  		struct buffer_head *bh = bhs[i];
^1da177e Linus Torvalds    2005-04-16  3096  
9cb569d6 Christoph Hellwig 2010-08-11  3097  		if (!trylock_buffer(bh))
^1da177e Linus Torvalds    2005-04-16  3098  			continue;
3390b48e Mike Christie     2016-01-05  3099  		if (op == WRITE) {

:::::: The code at line 3091 was first introduced by commit
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
Size: 6240 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160106/4cba246c/attachment.obj 
