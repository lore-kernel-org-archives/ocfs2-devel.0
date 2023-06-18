Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89008EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Sun, 18 Jun 2023 23:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0hISqz/AG5Vt2ycrIIdJfucYGTrI2WIMk1Y8ftdUtQE=;
 b=ESF1QPLkgo6bO/il27oNfb3S0Sliwuk4zF7bdDGO3K/eggJKrGj6OwSseUJlS4cbEzdAdz1xnw7P
   FRAGpIp1dyDx8Vzd1nt2imbZYRpcJ4LQvJLvPykC7H5rhE3A3q6ZvVKLAU/z/TFYilb0PkTu5nlI
   orly0ppUY8ioSaRCPny6PcoDkFqsSQpWoGCnwxPoHIm5KwgTFHgKBxAB6jiPvYfOKRm33pIOe3Fi
   KitjjKkOYPHXR4BtOXcSxZ30+Me/izusbdvivcxEW/2cBv5URNQmql84XqiN54LT4tq/KTCLvzWt
   V5kAkFblzxTGzm7Fwlz9T0CfJU2HBWTJfpmzCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0hISqz/AG5Vt2ycrIIdJfucYGTrI2WIMk1Y8ftdUtQE=;
 b=VOd5cEg17pwAp6I6V7tiHieEvd7PVryP9B7bX/Dhgo5dG6VFP5N24L0P4F9Fbk8553JGVNqcKybk
   iJtT773Wfos9zJ6Tka1FU7ojEZYuiGhqLQHIYUPoRYJ7kgsptZjVEpcOyz6PBJ5cxgHpV9/+ia71
   sRxUj1GV/Q40myR1wU9ilEEf6GXTsixcMeS11In+gNhlG+k4R10SmeHFl9Znf7AnFDj7Uuukrv+F
   E3JDaY9iCur9UQsVQuXm1De6PyMDBLI7uDsMdFyBUo9kg2PREljWSGvSXp4eoY5oE8A5Qk+8eic4
   GHHa49A7boP5jsGNBPTDI8R/sRGmoyhe4bZ8iA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWH000TK2WAM300@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 18 Jun 2023 23:36:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1687131355; x=1718667355;
 h=date:from:to:cc:subject:message-id:references: mime-version:in-reply-to;
 bh=VofrOuJxE/Vk0udrmnYtndlTeRd31idF1sSeKN8z/5Q=;
 b=DDgwPvKNkvyWm/gJ7t45HezVdZmVmQcWCNh/KIRToPWJriYQH5OEStwS
 Q/P9gL+aFkSGHm7LYSMj3+BnORFbt4n+QvwEcxX590QFwXS/QYIYnypl1
 FpQzqwH8+VaXD2yZ0bKTGXI75R6KmCkT3r6o/HtIUXlJytU5SPnDYaIbu
 A/iOoRmS9wVuwMUgNmClMmQvc5LlIZmeZv++41VbOWf2AQYUuHec+kkbj
 0BsbWVtMlMG98ef47iL4IsVVkjXVmzJ7SOJXbDQpwHqLTIRygTuFErmbN
 +mCOAQggR3u+c7MufueQ44YjRsYenhHbYFus8NoHcydCDqNaNSLB5ULg8 w==;
Date: Mon, 19 Jun 2023 07:35:21 +0800
To: Bean Huo <beanhuo@iokpp.de>, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, jack@suse.cz, jack@suse.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com
Message-id: <202306190729.oETrBjGU-lkp@intel.com>
References: <20230618213250.694110-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230618213250.694110-3-beanhuo@iokpp.de>
X-Source-IP: 192.55.52.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=381 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=319 impostorscore=0 spamscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306180225 domainage_hfrom=13599
Cc: linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/5] fs/buffer.c: convert
 block_commit_write to return void
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: kernel test robot via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: kernel test robot <lkp@intel.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="445896148"
X-IronPort-AV: E=Sophos;i="6.00,253,1681196400"; d="scan'208";a="445896148"
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="887734980"
X-IronPort-AV: E=Sophos;i="6.00,253,1681196400"; d="scan'208";a="887734980"
X-ServerName: mga05.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: okD-dHT5JNGDTKx0o15TybQgUei8wJ7o
X-Proofpoint-GUID: okD-dHT5JNGDTKx0o15TybQgUei8wJ7o
Reporting-Meta:
 AAHVCJPQJ0aYldk4HyvYRr3mb2/HaQtUQDWPKTAnotW2RvY5R12TQY/trs7o4mRj
 832od1h6xYJHLuu4AZHvirL+/wMg/DTl+WJSrW6cxnVJitkUpcdr/wHOf1F7q4BL
 4XhlgErXweWHE0a/i+BI7iQ63BW4blS/ZFqP7udiVLEWpZAC7rNIZrDf8h37iAtB
 BMu225UdFjLOwskinbfjuzouTo4Wyf0I2yAxsrB3RVghwG7Slxfa1WQqfUCM4HFq
 9wJLnPD90sz78CB5I9qkPGKrZSoLJDSVnnCtgGyVG6WkHO+BDwwwOlt5tPR5THvs
 wewCiOWDt8dWt3C/KoM/0l/ZLIK06DIvoUbOGVrXE1xuH/1yENn4FWYywoyMx4vf
 yo7wIUsTpSZdCFiglqI/F7YXBMB55MuzuaxycFLeMH+lQ6sj+a0cu0T9PzYOoJXm
 wHWRqw/CBakzbuBpqfdzxgjZoP/pqPOHB4sY2m9ZF8ZtcbHURs88th07kyyJvsxN
 EkEUvd0L7SOm0it/pWsvc9I7UHFzTkZawXghifq8Gfg=

Hi Bean,

kernel test robot noticed the following build errors:

[auto build test ERROR on tytso-ext4/dev]
[also build test ERROR on vfs-idmapping/for-next linus/master v6.4-rc6]
[cannot apply to akpm-mm/mm-everything next-20230616]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bean-Huo/fs-buffer-clean-up-block_commit_write/20230619-053759
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
patch link:    https://lore.kernel.org/r/20230618213250.694110-3-beanhuo%40iokpp.de
patch subject: [PATCH v1 2/5] fs/buffer.c: convert block_commit_write to return void
config: i386-defconfig (https://download.01.org/0day-ci/archive/20230619/202306190729.oETrBjGU-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230619/202306190729.oETrBjGU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306190729.oETrBjGU-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ext4/move_extent.c: In function 'move_extent_per_page':
>> fs/ext4/move_extent.c:399:22: error: void value not ignored as it ought to be
     399 |                 *err = block_commit_write(&folio[0]->page, from, from + replaced_size);
         |                      ^


vim +399 fs/ext4/move_extent.c

bb5574880574fe Dmitry Monakhov       2012-09-26  234  
748de6736c1e48 Akira Fujita          2009-06-17  235  /**
748de6736c1e48 Akira Fujita          2009-06-17  236   * move_extent_per_page - Move extent data per page
748de6736c1e48 Akira Fujita          2009-06-17  237   *
748de6736c1e48 Akira Fujita          2009-06-17  238   * @o_filp:			file structure of original file
748de6736c1e48 Akira Fujita          2009-06-17  239   * @donor_inode:		donor inode
748de6736c1e48 Akira Fujita          2009-06-17  240   * @orig_page_offset:		page index on original file
65dd8327eb055a Xiaoguang Wang        2014-10-11  241   * @donor_page_offset:		page index on donor file
748de6736c1e48 Akira Fujita          2009-06-17  242   * @data_offset_in_page:	block index where data swapping starts
748de6736c1e48 Akira Fujita          2009-06-17  243   * @block_len_in_page:		the number of blocks to be swapped
556615dcbf38b0 Lukas Czerner         2014-04-20  244   * @unwritten:			orig extent is unwritten or not
f868a48d06f888 Akira Fujita          2009-11-23  245   * @err:			pointer to save return value
748de6736c1e48 Akira Fujita          2009-06-17  246   *
748de6736c1e48 Akira Fujita          2009-06-17  247   * Save the data in original inode blocks and replace original inode extents
65dd8327eb055a Xiaoguang Wang        2014-10-11  248   * with donor inode extents by calling ext4_swap_extents().
f868a48d06f888 Akira Fujita          2009-11-23  249   * Finally, write out the saved data in new original inode blocks. Return
f868a48d06f888 Akira Fujita          2009-11-23  250   * replaced block count.
748de6736c1e48 Akira Fujita          2009-06-17  251   */
748de6736c1e48 Akira Fujita          2009-06-17  252  static int
44fc48f7048ab9 Akira Fujita          2009-09-05  253  move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  254  		     pgoff_t orig_page_offset, pgoff_t donor_page_offset,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  255  		     int data_offset_in_page,
556615dcbf38b0 Lukas Czerner         2014-04-20  256  		     int block_len_in_page, int unwritten, int *err)
748de6736c1e48 Akira Fujita          2009-06-17  257  {
496ad9aa8ef448 Al Viro               2013-01-23  258  	struct inode *orig_inode = file_inode(o_filp);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  259) 	struct folio *folio[2] = {NULL, NULL};
748de6736c1e48 Akira Fujita          2009-06-17  260  	handle_t *handle;
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  261  	ext4_lblk_t orig_blk_offset, donor_blk_offset;
748de6736c1e48 Akira Fujita          2009-06-17  262  	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
f868a48d06f888 Akira Fujita          2009-11-23  263  	unsigned int tmp_data_size, data_size, replaced_size;
bcff24887d00bc Eryu Guan             2016-02-12  264  	int i, err2, jblocks, retries = 0;
f868a48d06f888 Akira Fujita          2009-11-23  265  	int replaced_count = 0;
bb5574880574fe Dmitry Monakhov       2012-09-26  266  	int from = data_offset_in_page << orig_inode->i_blkbits;
09cbfeaf1a5a67 Kirill A. Shutemov    2016-04-01  267  	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  268  	struct super_block *sb = orig_inode->i_sb;
bcff24887d00bc Eryu Guan             2016-02-12  269  	struct buffer_head *bh = NULL;
748de6736c1e48 Akira Fujita          2009-06-17  270  
748de6736c1e48 Akira Fujita          2009-06-17  271  	/*
748de6736c1e48 Akira Fujita          2009-06-17  272  	 * It needs twice the amount of ordinary journal buffers because
748de6736c1e48 Akira Fujita          2009-06-17  273  	 * inode and donor_inode may change each different metadata blocks.
748de6736c1e48 Akira Fujita          2009-06-17  274  	 */
bb5574880574fe Dmitry Monakhov       2012-09-26  275  again:
bb5574880574fe Dmitry Monakhov       2012-09-26  276  	*err = 0;
748de6736c1e48 Akira Fujita          2009-06-17  277  	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
9924a92a8c2175 Theodore Ts'o         2013-02-08  278  	handle = ext4_journal_start(orig_inode, EXT4_HT_MOVE_EXTENTS, jblocks);
748de6736c1e48 Akira Fujita          2009-06-17  279  	if (IS_ERR(handle)) {
f868a48d06f888 Akira Fujita          2009-11-23  280  		*err = PTR_ERR(handle);
f868a48d06f888 Akira Fujita          2009-11-23  281  		return 0;
748de6736c1e48 Akira Fujita          2009-06-17  282  	}
748de6736c1e48 Akira Fujita          2009-06-17  283  
748de6736c1e48 Akira Fujita          2009-06-17  284  	orig_blk_offset = orig_page_offset * blocks_per_page +
748de6736c1e48 Akira Fujita          2009-06-17  285  		data_offset_in_page;
748de6736c1e48 Akira Fujita          2009-06-17  286  
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  287  	donor_blk_offset = donor_page_offset * blocks_per_page +
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  288  		data_offset_in_page;
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  289  
f868a48d06f888 Akira Fujita          2009-11-23  290  	/* Calculate data_size */
748de6736c1e48 Akira Fujita          2009-06-17  291  	if ((orig_blk_offset + block_len_in_page - 1) ==
748de6736c1e48 Akira Fujita          2009-06-17  292  	    ((orig_inode->i_size - 1) >> orig_inode->i_blkbits)) {
748de6736c1e48 Akira Fujita          2009-06-17  293  		/* Replace the last block */
f868a48d06f888 Akira Fujita          2009-11-23  294  		tmp_data_size = orig_inode->i_size & (blocksize - 1);
748de6736c1e48 Akira Fujita          2009-06-17  295  		/*
f868a48d06f888 Akira Fujita          2009-11-23  296  		 * If data_size equal zero, it shows data_size is multiples of
748de6736c1e48 Akira Fujita          2009-06-17  297  		 * blocksize. So we set appropriate value.
748de6736c1e48 Akira Fujita          2009-06-17  298  		 */
f868a48d06f888 Akira Fujita          2009-11-23  299  		if (tmp_data_size == 0)
f868a48d06f888 Akira Fujita          2009-11-23  300  			tmp_data_size = blocksize;
748de6736c1e48 Akira Fujita          2009-06-17  301  
f868a48d06f888 Akira Fujita          2009-11-23  302  		data_size = tmp_data_size +
748de6736c1e48 Akira Fujita          2009-06-17  303  			((block_len_in_page - 1) << orig_inode->i_blkbits);
f868a48d06f888 Akira Fujita          2009-11-23  304  	} else
f868a48d06f888 Akira Fujita          2009-11-23  305  		data_size = block_len_in_page << orig_inode->i_blkbits;
f868a48d06f888 Akira Fujita          2009-11-23  306  
f868a48d06f888 Akira Fujita          2009-11-23  307  	replaced_size = data_size;
748de6736c1e48 Akira Fujita          2009-06-17  308  
e8dfc854eef20a Vishal Moola (Oracle  2022-12-07  309) 	*err = mext_folio_double_lock(orig_inode, donor_inode, orig_page_offset,
e8dfc854eef20a Vishal Moola (Oracle  2022-12-07  310) 				     donor_page_offset, folio);
f868a48d06f888 Akira Fujita          2009-11-23  311  	if (unlikely(*err < 0))
bb5574880574fe Dmitry Monakhov       2012-09-26  312  		goto stop_journal;
8c854473917354 Dmitry Monakhov       2012-09-26  313  	/*
556615dcbf38b0 Lukas Czerner         2014-04-20  314  	 * If orig extent was unwritten it can become initialized
8c854473917354 Dmitry Monakhov       2012-09-26  315  	 * at any time after i_data_sem was dropped, in order to
8c854473917354 Dmitry Monakhov       2012-09-26  316  	 * serialize with delalloc we have recheck extent while we
8c854473917354 Dmitry Monakhov       2012-09-26  317  	 * hold page's lock, if it is still the case data copy is not
8c854473917354 Dmitry Monakhov       2012-09-26  318  	 * necessary, just swap data blocks between orig and donor.
8c854473917354 Dmitry Monakhov       2012-09-26  319  	 */
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  320) 
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  321) 	VM_BUG_ON_FOLIO(folio_test_large(folio[0]), folio[0]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  322) 	VM_BUG_ON_FOLIO(folio_test_large(folio[1]), folio[1]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  323) 	VM_BUG_ON_FOLIO(folio_nr_pages(folio[0]) != folio_nr_pages(folio[1]), folio[1]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  324) 
556615dcbf38b0 Lukas Czerner         2014-04-20  325  	if (unwritten) {
393d1d1d769338 Dr. Tilmann Bubeck    2013-04-08  326  		ext4_double_down_write_data_sem(orig_inode, donor_inode);
8c854473917354 Dmitry Monakhov       2012-09-26  327  		/* If any of extents in range became initialized we have to
8c854473917354 Dmitry Monakhov       2012-09-26  328  		 * fallback to data copying */
556615dcbf38b0 Lukas Czerner         2014-04-20  329  		unwritten = mext_check_coverage(orig_inode, orig_blk_offset,
8c854473917354 Dmitry Monakhov       2012-09-26  330  						block_len_in_page, 1, err);
8c854473917354 Dmitry Monakhov       2012-09-26  331  		if (*err)
8c854473917354 Dmitry Monakhov       2012-09-26  332  			goto drop_data_sem;
8c854473917354 Dmitry Monakhov       2012-09-26  333  
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  334  		unwritten &= mext_check_coverage(donor_inode, donor_blk_offset,
8c854473917354 Dmitry Monakhov       2012-09-26  335  						 block_len_in_page, 1, err);
8c854473917354 Dmitry Monakhov       2012-09-26  336  		if (*err)
8c854473917354 Dmitry Monakhov       2012-09-26  337  			goto drop_data_sem;
748de6736c1e48 Akira Fujita          2009-06-17  338  
556615dcbf38b0 Lukas Czerner         2014-04-20  339  		if (!unwritten) {
393d1d1d769338 Dr. Tilmann Bubeck    2013-04-08  340  			ext4_double_up_write_data_sem(orig_inode, donor_inode);
8c854473917354 Dmitry Monakhov       2012-09-26  341  			goto data_copy;
8c854473917354 Dmitry Monakhov       2012-09-26  342  		}
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  343) 		if ((folio_has_private(folio[0]) &&
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  344) 		     !filemap_release_folio(folio[0], 0)) ||
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  345) 		    (folio_has_private(folio[1]) &&
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  346) 		     !filemap_release_folio(folio[1], 0))) {
8c854473917354 Dmitry Monakhov       2012-09-26  347  			*err = -EBUSY;
8c854473917354 Dmitry Monakhov       2012-09-26  348  			goto drop_data_sem;
8c854473917354 Dmitry Monakhov       2012-09-26  349  		}
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  350  		replaced_count = ext4_swap_extents(handle, orig_inode,
8c854473917354 Dmitry Monakhov       2012-09-26  351  						   donor_inode, orig_blk_offset,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  352  						   donor_blk_offset,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  353  						   block_len_in_page, 1, err);
8c854473917354 Dmitry Monakhov       2012-09-26  354  	drop_data_sem:
393d1d1d769338 Dr. Tilmann Bubeck    2013-04-08  355  		ext4_double_up_write_data_sem(orig_inode, donor_inode);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  356) 		goto unlock_folios;
8c854473917354 Dmitry Monakhov       2012-09-26  357  	}
8c854473917354 Dmitry Monakhov       2012-09-26  358  data_copy:
3060b6ef05603c Matthew Wilcox        2023-03-24  359  	*err = mext_page_mkuptodate(folio[0], from, from + replaced_size);
bb5574880574fe Dmitry Monakhov       2012-09-26  360  	if (*err)
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  361) 		goto unlock_folios;
748de6736c1e48 Akira Fujita          2009-06-17  362  
bb5574880574fe Dmitry Monakhov       2012-09-26  363  	/* At this point all buffers in range are uptodate, old mapping layout
bb5574880574fe Dmitry Monakhov       2012-09-26  364  	 * is no longer required, try to drop it now. */
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  365) 	if ((folio_has_private(folio[0]) &&
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  366) 		!filemap_release_folio(folio[0], 0)) ||
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  367) 	    (folio_has_private(folio[1]) &&
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  368) 		!filemap_release_folio(folio[1], 0))) {
bb5574880574fe Dmitry Monakhov       2012-09-26  369  		*err = -EBUSY;
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  370) 		goto unlock_folios;
bb5574880574fe Dmitry Monakhov       2012-09-26  371  	}
6e2631463f3a2c Dmitry Monakhov       2014-07-27  372  	ext4_double_down_write_data_sem(orig_inode, donor_inode);
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  373  	replaced_count = ext4_swap_extents(handle, orig_inode, donor_inode,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  374  					       orig_blk_offset, donor_blk_offset,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  375  					   block_len_in_page, 1, err);
6e2631463f3a2c Dmitry Monakhov       2014-07-27  376  	ext4_double_up_write_data_sem(orig_inode, donor_inode);
bb5574880574fe Dmitry Monakhov       2012-09-26  377  	if (*err) {
f868a48d06f888 Akira Fujita          2009-11-23  378  		if (replaced_count) {
f868a48d06f888 Akira Fujita          2009-11-23  379  			block_len_in_page = replaced_count;
f868a48d06f888 Akira Fujita          2009-11-23  380  			replaced_size =
f868a48d06f888 Akira Fujita          2009-11-23  381  				block_len_in_page << orig_inode->i_blkbits;
ac48b0a1d06888 Akira Fujita          2009-11-24  382  		} else
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  383) 			goto unlock_folios;
748de6736c1e48 Akira Fujita          2009-06-17  384  	}
bb5574880574fe Dmitry Monakhov       2012-09-26  385  	/* Perform all necessary steps similar write_begin()/write_end()
bb5574880574fe Dmitry Monakhov       2012-09-26  386  	 * but keeping in mind that i_size will not change */
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  387) 	if (!folio_buffers(folio[0]))
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  388) 		create_empty_buffers(&folio[0]->page, 1 << orig_inode->i_blkbits, 0);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  389) 	bh = folio_buffers(folio[0]);
bcff24887d00bc Eryu Guan             2016-02-12  390  	for (i = 0; i < data_offset_in_page; i++)
bcff24887d00bc Eryu Guan             2016-02-12  391  		bh = bh->b_this_page;
bcff24887d00bc Eryu Guan             2016-02-12  392  	for (i = 0; i < block_len_in_page; i++) {
bcff24887d00bc Eryu Guan             2016-02-12  393  		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
bcff24887d00bc Eryu Guan             2016-02-12  394  		if (*err < 0)
bcff24887d00bc Eryu Guan             2016-02-12  395  			break;
6ffe77bad545f4 Eryu Guan             2016-02-21  396  		bh = bh->b_this_page;
bcff24887d00bc Eryu Guan             2016-02-12  397  	}
bb5574880574fe Dmitry Monakhov       2012-09-26  398  	if (!*err)
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17 @399) 		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
748de6736c1e48 Akira Fujita          2009-06-17  400  
bb5574880574fe Dmitry Monakhov       2012-09-26  401  	if (unlikely(*err < 0))
bb5574880574fe Dmitry Monakhov       2012-09-26  402  		goto repair_branches;
bb5574880574fe Dmitry Monakhov       2012-09-26  403  
bb5574880574fe Dmitry Monakhov       2012-09-26  404  	/* Even in case of data=writeback it is reasonable to pin
bb5574880574fe Dmitry Monakhov       2012-09-26  405  	 * inode to transaction, to prevent unexpected data loss */
73131fbb003b36 Ross Zwisler          2019-06-20  406  	*err = ext4_jbd2_inode_add_write(handle, orig_inode,
73131fbb003b36 Ross Zwisler          2019-06-20  407  			(loff_t)orig_page_offset << PAGE_SHIFT, replaced_size);
bb5574880574fe Dmitry Monakhov       2012-09-26  408  
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  409) unlock_folios:
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  410) 	folio_unlock(folio[0]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  411) 	folio_put(folio[0]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  412) 	folio_unlock(folio[1]);
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  413) 	folio_put(folio[1]);
bb5574880574fe Dmitry Monakhov       2012-09-26  414  stop_journal:
748de6736c1e48 Akira Fujita          2009-06-17  415  	ext4_journal_stop(handle);
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  416  	if (*err == -ENOSPC &&
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  417  	    ext4_should_retry_alloc(sb, &retries))
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  418  		goto again;
bb5574880574fe Dmitry Monakhov       2012-09-26  419  	/* Buffer was busy because probably is pinned to journal transaction,
bb5574880574fe Dmitry Monakhov       2012-09-26  420  	 * force transaction commit may help to free it. */
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  421  	if (*err == -EBUSY && retries++ < 4 && EXT4_SB(sb)->s_journal &&
88c6b61ff1cfb4 Dmitry Monakhov       2014-11-05  422  	    jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal))
bb5574880574fe Dmitry Monakhov       2012-09-26  423  		goto again;
f868a48d06f888 Akira Fujita          2009-11-23  424  	return replaced_count;
bb5574880574fe Dmitry Monakhov       2012-09-26  425  
bb5574880574fe Dmitry Monakhov       2012-09-26  426  repair_branches:
bb5574880574fe Dmitry Monakhov       2012-09-26  427  	/*
bb5574880574fe Dmitry Monakhov       2012-09-26  428  	 * This should never ever happen!
bb5574880574fe Dmitry Monakhov       2012-09-26  429  	 * Extents are swapped already, but we are not able to copy data.
bb5574880574fe Dmitry Monakhov       2012-09-26  430  	 * Try to swap extents to it's original places
bb5574880574fe Dmitry Monakhov       2012-09-26  431  	 */
393d1d1d769338 Dr. Tilmann Bubeck    2013-04-08  432  	ext4_double_down_write_data_sem(orig_inode, donor_inode);
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  433  	replaced_count = ext4_swap_extents(handle, donor_inode, orig_inode,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  434  					       orig_blk_offset, donor_blk_offset,
fcf6b1b729bcd2 Dmitry Monakhov       2014-08-30  435  					   block_len_in_page, 0, &err2);
393d1d1d769338 Dr. Tilmann Bubeck    2013-04-08  436  	ext4_double_up_write_data_sem(orig_inode, donor_inode);
bb5574880574fe Dmitry Monakhov       2012-09-26  437  	if (replaced_count != block_len_in_page) {
54d3adbc29f0c7 Theodore Ts'o         2020-03-28  438  		ext4_error_inode_block(orig_inode, (sector_t)(orig_blk_offset),
54d3adbc29f0c7 Theodore Ts'o         2020-03-28  439  				       EIO, "Unable to copy data block,"
bb5574880574fe Dmitry Monakhov       2012-09-26  440  				       " data will be lost.");
bb5574880574fe Dmitry Monakhov       2012-09-26  441  		*err = -EIO;
bb5574880574fe Dmitry Monakhov       2012-09-26  442  	}
bb5574880574fe Dmitry Monakhov       2012-09-26  443  	replaced_count = 0;
6dd8fe86fa8472 Vishal Moola (Oracle  2022-11-17  444) 	goto unlock_folios;
748de6736c1e48 Akira Fujita          2009-06-17  445  }
748de6736c1e48 Akira Fujita          2009-06-17  446  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
