From: kbuild test robot <lkp@intel.com>
Date: Mon, 6 Jun 2016 04:37:53 +0800
Subject: [Ocfs2-devel] [PATCH 42/45] block, fs,
 drivers: remove REQ_OP compat defs and related code
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
Message-ID: <201606060429.qfDh91VE%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

[auto build test WARNING on v4.7-rc1]
[cannot apply to dm/for-next md/for-next next-20160603]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/v8-separate-operations-from-flags-in-the-bio-request-structs/20160606-040240
config: x86_64-randconfig-i0-201623 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/linux/genhd.h:67:0,
                    from include/linux/blkdev.h:9,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   fs/ext4/crypto.c: In function 'ext4_encrypted_zeroout':
>> include/linux/fs.h:197:19: warning: passing argument 1 of 'submit_bio_wait' makes pointer from integer without a cast [-Wint-conversion]
    #define RW_MASK   REQ_OP_WRITE
                      ^
   include/linux/fs.h:201:17: note: in expansion of macro 'RW_MASK'
    #define WRITE   RW_MASK
                    ^~~~~~~
   fs/ext4/crypto.c:442:25: note: in expansion of macro 'WRITE'
      err = submit_bio_wait(WRITE, bio);
                            ^~~~~
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:471:12: note: expected 'struct bio *' but argument is of type 'int'
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~
   fs/ext4/crypto.c:442:9: error: too many arguments to function 'submit_bio_wait'
      err = submit_bio_wait(WRITE, bio);
            ^~~~~~~~~~~~~~~
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:471:12: note: declared here
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~

vim +/submit_bio_wait +197 include/linux/fs.h

   181	 * READA		Used for read-ahead operations. Lower priority, and the
   182	 *			block layer could (in theory) choose to ignore this
   183	 *			request if it runs into resource problems.
   184	 * WRITE		A normal async write. Device will be plugged.
   185	 * WRITE_SYNC		Synchronous write. Identical to WRITE, but passes down
   186	 *			the hint that someone will be waiting on this IO
   187	 *			shortly. The write equivalent of READ_SYNC.
   188	 * WRITE_ODIRECT	Special case write for O_DIRECT only.
   189	 * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
   190	 * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
   191	 *			non-volatile media on completion.
   192	 * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA. The IO is preceded
   193	 *			by a cache flush and data is guaranteed to be on
   194	 *			non-volatile media on completion.
   195	 *
   196	 */
 > 197	#define RW_MASK			REQ_OP_WRITE
   198	#define RWA_MASK		REQ_RAHEAD
   199	
   200	#define READ			REQ_OP_READ
   201	#define WRITE			RW_MASK
   202	#define READA			RWA_MASK
   203	
   204	#define READ_SYNC		REQ_SYNC
   205	#define WRITE_SYNC		(REQ_SYNC | REQ_NOIDLE)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 23301 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160606/4349da71/attachment-0001.obj 
